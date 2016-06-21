//
//  NSStringExtension.swift
//  RealTransfer
//
//  Created by Apple on 6/20/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Foundation

extension NSString {
    
    class func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 1...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return String(randomString)
    }
}
