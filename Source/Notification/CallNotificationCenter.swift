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

import Foundation

/// The CallNotificationCenter class is used to add & remove call observer.
public class CallNotificationCenter {
    
    /// Returns the singleton CallNotificationCenter.
    public static let sharedInstance = CallNotificationCenter()
    
    private var observers = WeakArray<CallObserver>()
    
    /// Add call observer
    ///
    /// - parameter observer: CallObserver object to add.
    /// - returns: Void
    public func addObserver(observer: CallObserver) {
        observers.append(observer)
    }
    
    /// Remove call observer
    ///
    /// - parameter observer: CallObserver object to remove.
    /// - returns: Void
    public func removeObserver(observer: CallObserver) {
        observers.remove(observer)
    }
    
    func notifyCallRinging(call: Call) {
        for observer in observers {
            observer.callDidBeginRinging(call)
        }
    }
    
    func notifyCallConnected(call: Call) {
        for observer in observers {
            observer.callDidConnect(call)
        }
    }
    
    func notifyCallDisconnected(call: Call, disconnectionType: DisconnectionType) {
        for observer in observers {
            observer.callDidDisconnect(call, disconnectionType: disconnectionType)
        }
    }
    
    func notifyRemoteMediaChanged(call: Call, mediaUpdatedType: MediaChangeType) {
        for observer in observers {
            observer.remoteMediaDidChange(call, mediaChangeType: mediaUpdatedType)
        }
    }
    
    func notifyEnableDTMFChanged(call: Call) {
        for observer in observers {
            observer.enableDTMFDidChange(call, sendingDTMFEnabled: call.sendingDTMFEnabled)
        }
    }
}
