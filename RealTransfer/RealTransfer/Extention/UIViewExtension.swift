//
//  UIViewExtension.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//
import UIKit
import Foundation

extension UIView{
    
    func assignCornerRadius(radiusValue:CGFloat){
        
        self.layer.cornerRadius = radiusValue
        self.layer.masksToBounds = true
    }
    
    
    
}

//extension UIImagePickerController {
//    override public func shouldAutorotate() -> Bool {
//        
//        if self.sourceType == UIImagePickerControllerSourceType.PhotoLibrary {
//            return false
//        }else{
//            return true
//        }
//    }
//    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        
//        return UIInterfaceOrientationMask.Portrait
//        
//    }
//}

