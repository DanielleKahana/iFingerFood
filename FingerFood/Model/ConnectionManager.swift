//
//  NetworkStatus.swift
//  FingerFood
//
//  Created by Mac on 03/08/2018.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import SystemConfiguration
import ReachabilitySwift

class ConnectionManager : NSObject {
    static let shared = ConnectionManager()
    
    var isNetworkAvailable : Bool {
        print(reachabilityStatus)
        return reachabilityStatus != .notReachable
    }
    
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    let reachabilty = Reachability()
   
    func startMonitoring(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabiltyChanged), name: ReachabilityChangedNotification, object: reachabilty)
        
        do {
            try reachabilty?.startNotifier()
        } catch {
            print("not able to start reachability notifier")
        }
    }

    @objc func reachabiltyChanged(notification : Notification) {
     let reachabilty = notification.object as! Reachability
        
        switch reachabilty.currentReachabilityStatus {
        case .notReachable:
            self.reachabilityStatus = .notReachable
            print("Network Not Reachable")
        case .reachableViaWiFi:
            self.reachabilityStatus = .reachableViaWiFi
            print("Network Reachable via wifi")
        case .reachableViaWWAN:
            self.reachabilityStatus = .reachableViaWWAN
            print("Network Reachable via cellular")

        }
        
    }
    
    func stopMonitoring() {
        reachabilty?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachabilty)
    }
}


    /*
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil , zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
       
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        
        return isReachable && !needsConnection
       
    }
 */
 
//}
