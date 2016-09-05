//
//  NZSplitViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright (c) 2559 nuizoro. All rights reserved.
//

import UIKit

class NZSplitViewController: UISplitViewController {
    var nzNavigationController:NZNavigationViewController?
    
    static var shareInstance:NZSplitViewController?
    
    class func sharedInstance()->NZSplitViewController {
        if self.shareInstance == nil {
            self.shareInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NZSplitViewController") as? NZSplitViewController
        }
        return self.shareInstance!
    }
    class func desTroyShareInstance() {
        
        self.shareInstance = nil;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configLayout()
        let viewSet:[UIView] = self.viewsNeedApplyFont()
        
        for view:UIView in viewSet {
            if view is UIButton
            {
                (view as! UIButton).titleLabel?.font = UIFont.appFontStyle()
            }
            else if view is UILabel
            {
                (view as! UILabel).font = UIFont.appFontStyle()
            }
            else if view is UITextField
            {
                (view as! UITextField).font = UIFont.appFontStyle()
            }
            else if view is UITextView
            {
                (view as! UITextView).font = UIFont.appFontStyle()
            }
        }
        self.stateAfterSetfont()
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(dismiss),
            name: "CLOSE_SPLITVIEW",
            object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver("CLOSE_SPLITVIEW")
    }
    func dismiss(){
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    class func close() {
        let noti = NSNotification(name: "CLOSE_SPLITVIEW", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(noti)
    }
    
    internal func configLayout(){
        
    }
    internal func viewsNeedApplyFont()->[UIView]{
        return []
    }
    internal func stateAfterSetfont() {
        
    }
    internal func stateConfigData() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.nzNavigationController?.hideMenuPopoverIfViewIsShowing()
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
