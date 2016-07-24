//
//  NetworkDetection.swift
//  RealTransfer
//
//  Created by Apple on 7/23/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import ReachabilitySwift

class NetworkDetection: NSObject {
    
    static var manager:NetworkDetection = NetworkDetection()
    
    func isConected(handler: (Bool) -> Void)->Void {
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
    
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
               handler(true)
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            handler(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    

}
