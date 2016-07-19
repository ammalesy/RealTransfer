//
//  NSDateFormaterExtension.swift
//  RealTransfer
//
//  Created by Apple on 6/18/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Foundation

extension NSDateFormatter {
    
    class func dateFormater()->NSDateFormatter {
    
        let format = NSDateFormatter()
        format.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        format.dateFormat = "dd/MM/yyyy|hh:mm:ss"
        return format
    }
    
    class func dateDisplayFormat()->NSDateFormatter {
        
        let format = NSDateFormatter()
        format.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        format.dateFormat = "dd/MM/yyyy hh:mm:ss"
        return format
    }
    
    
}