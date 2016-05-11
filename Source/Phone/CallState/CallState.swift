//
//  CallState.swift
//  Pods
//
//  Created by niliu2 on 3/25/16.
//
//

import Foundation

class CallState {
    
    weak var call: Call!
    let callManager = CallManager.sharedInstance
    
    init(_ call: Call) {
        self.call = call
    }
    
    var info: CallInfo {
        return call.info!
    }
    
    func isAllowedToDial() -> Bool {
        return false
    }
    
    func isAllowedToAnswer() -> Bool {
        return false
    }
    
    func isAllowedToHangup() -> Bool {
        return false
    }
    
    func isAllowedToReject() -> Bool {
        return false
    }
    
    func isAllowedToOperateMedia() -> Bool {
        return false
    }
    
    func update() {
    }
    
    final func postNotification(notification: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: call, userInfo: nil)
        print("postNotification: \(notification)")
    }
}