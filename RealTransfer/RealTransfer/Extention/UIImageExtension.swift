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

    func normalizedImage()->UIImage {
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func uniqNameBySeq(seq:String!)->String! {
        
        let format = NSDateFormatter()
        format.dateFormat = "ddMMyyyyhhmmss"
        let name = format.stringFromDate(NSDate())
        
        return "\(seq)\(name)"
    }
    class func resizeImage(sourceImage: UIImage, scaledToWidth: CGFloat) -> UIImage {
        
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        var newHeight = sourceImage.size.height * scaleFactor
        var newWidth = oldWidth * scaleFactor
        
        var imgRatio = sourceImage.size.width / sourceImage.size.height
        if (sourceImage.size.height > sourceImage.size.width) {
            imgRatio = sourceImage.size.height / sourceImage.size.width
        }
        
        newWidth = round(imgRatio * newWidth);
        newHeight = round(imgRatio * newHeight);
        
        UIGraphicsBeginImageContext(CGSizeMake(floor(newWidth), floor(newHeight)))
        sourceImage.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowMediumQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.4)! }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowerQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.1)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
    
}