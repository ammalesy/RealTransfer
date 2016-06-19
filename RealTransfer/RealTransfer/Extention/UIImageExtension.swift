//
//  UIImageExtension.swift
//  RealTransfer
//
//  Created by Apple on 6/19/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    
    class func uniqNameBySeq(seq:String!)->String! {
        
        let format = NSDateFormatter()
        format.dateFormat = "ddMMyyyyhhmmss"
        let name = format.stringFromDate(NSDate())
        
        return "\(seq)\(name)"
    }
    
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowMediumQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.4)! }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
    
}