//
//  UIFontExtention.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Foundation

extension UIFont {

    class func appFontStyle() -> UIFont
    {
        return UIFont.fontLight(16)
    }
    
    class func fontLight(size:CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Light", size: size)!
    }
    class func fontMedium(size:CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Medium", size: size)!
    }
    class func fontNormal(size:CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Text", size: size)!
    }
    class func fontBold(size:CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Bold", size: size)!
    }
    class func fontSemiBold(size:CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-SemiBold", size: size)!
    }
    class func fontThin(size:CGFloat) -> UIFont {
        return UIFont(name: "SukhumvitSet-Thin", size: size)!
    }
    

}