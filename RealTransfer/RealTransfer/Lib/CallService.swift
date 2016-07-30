//
//  CallService.swift
//  RealTransfer
//
//  Created by Apple on 7/30/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire

class CallService: NSObject {

    static var shareInstance = CallService()
    
    var manager:Manager?
    
    func api() -> Manager {
    
        if let m = self.manager{
            return m
        }
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "demo.realsmart.in.th": .PinCertificates(
                certificates: ServerTrustPolicy.certificatesInBundle(),
                validateCertificateChain: false,
                validateHost: true
            )
        ]
        
        self.manager = Manager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return self.manager!
    
    }
    
}
