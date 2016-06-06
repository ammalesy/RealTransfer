//
//  UIColorExtension.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//
import UIKit
import Foundation


extension UIColor{
    
    class func RGB(R:CGFloat, G:CGFloat, B:CGFloat)->UIColor {
        
        return UIColor(red: R/255, green: G/255, blue: B/255, alpha: 1)
        
    }
}
