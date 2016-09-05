//
//  UIViewControllerExtension.swift
//  RealTransfer
//
//  Created by Apple on 7/1/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    
    func setTapEventOnContainer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(NZNavigationViewController.containerTapped))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    func containerTapped() {
        
        let noti = NSNotification(name: "HIDE_MENU_ON_NAV", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(noti)
        
    }
    
    class func topViewController() -> UIViewController? {
        
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
        
    }
}
extension NZViewController {

    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
}
extension NZSplitViewController {
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
}
extension NZNavigationViewController {
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
}