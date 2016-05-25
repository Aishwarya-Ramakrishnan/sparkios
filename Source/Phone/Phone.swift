// Copyright 2016 Cisco Systems Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AVFoundation

/// Represents a Spark phone device.
public class Phone {
    
    static let sharedInstance = Phone()

    private let deviceService    = DeviceService.sharedInstance
    private let webSocketService = WebSocketService.sharedInstance
    
    /// Default camera facing mode, used as the default when dialing or answering a call.
    public var defaultFacingMode: Call.FacingMode {
        get {
            if let facingModeString = UserDefaults.sharedInstance.facingMode {
                return Call.FacingMode(rawValue: facingModeString)!
            }
            return Call.FacingMode.User
        }
        set {
            UserDefaults.sharedInstance.facingMode = newValue.rawValue
        }
    }
    
    /// Default loud speaker mode, used as the default when dialing or answering a call.
    /// True as using loud speaker, False as not.
    public var defaultLoudSpeaker: Bool {
        get {
            if let loudSpeaker = UserDefaults.sharedInstance.loudSpeaker {
                return loudSpeaker
            }
            return true
        }
        set {
            UserDefaults.sharedInstance.loudSpeaker = newValue
        }
    }

    /// Registers the user’s device to Spark. Subsequent invocations of this method should perform a device refresh.
    ///
    /// - parameter completionHandler: A closure to be executed once the registration is completed. True means success, and False means failure.
    /// - returns: Void
    /// - note: This function is expected to run on main thread.
    public func register(completionHandler: (Bool -> Void)?) {
        CallManager.sharedInstance.startObserving()
        
        deviceService.registerDevice() { success in
            if success {
                self.webSocketService.connect(NSURL(string: self.deviceService.webSocketUrl!)!)
                completionHandler?(true)
            } else {
                completionHandler?(false)
            }
        }
    }
    
    /// Removes the user’s device from Spark and disconnects the websocket. 
    /// Subsequent invocations of this method should behave as a no-op.
    ///
    /// - parameter completionHandler: A closure to be executed once the action is completed. True means success, and False means failure.
    /// - returns: Void
    /// - note: This function is expected to run on main thread.
    public func deregister(completionHandler: (Bool -> Void)?) {
        CallManager.sharedInstance.stopObserving()
        
        deviceService.deregisterDevice() { success in
            if success {
                self.webSocketService.disconnect()
                completionHandler?(true)
            } else {
                completionHandler?(false)
            }
        }
    }
    
    /// Makes a call to intended recipient.
    ///
    /// - parameter address: Intended recipient address. Supported URIs: Spark URI (e.g. spark:shenning@cisco.com), SIP / SIPS URI (e.g. sip:1234@care.acme.com), Tropo URI (e.g. tropo:999123456). Supported shorthand: Email address (e.g. shenning@cisco.com), App username (e.g. jp)
    /// - parameter renderView: Render view when call get connected.
    /// - parameter completionHandler: A closure to be executed once the action is completed. True means success, and False means failure.
    /// - returns: Call object
    /// - note: This function is expected to run on main thread.
    public func dial(address: String, renderView: RenderView, completionHandler: (Bool) -> Void) -> Call? {
        let call = Call()
        call.dial(address, renderView: renderView) { success in
            if success {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
        return call
    }
    
    /// Requests access for media (audio and video), user can change the settings in iOS device settings.
    ///
    /// - parameter completionHandler: A closure to be executed once the action is completed. True means access granted, and False means not.
    /// - returns: Void
    /// - note: This function is expected to run on main thread.
    public func requestAccessForMedia(completionHandler: (Bool -> Void)?) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { grantedAccessToCamera in
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeAudio) { grantedAccessToMicrophone in
                if grantedAccessToCamera && grantedAccessToMicrophone {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler?(true)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler?(false)
                    }
                }
            }
        }
    }
}
