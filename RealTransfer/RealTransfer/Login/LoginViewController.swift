//
//  LoginViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SDWebImage

class LoginViewController: NZViewController,URLConfigViewControllerDelegate {

    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var textFieldActive:UITextField?
    
    var user:User?
    
    override func viewDidLoad() {
        
//        let vvv = NSMutableDictionary()
//        var fff:String? = "asd"
//        fff = nil
//        vvv.setObject(fff!, forKey: "MMM");

        super.viewDidLoad()
        self.setIconImage()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapAnyWhere))
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        
        
        NetworkDetection.manager.isConected { (result) in
            if result == false {
                let user = User().getOnCache()
                let isOnSession = Session.shareInstance.isOnSession()
                
                if user != nil && isOnSession == true {
                    
                    Category.sharedInstance
                    self.openPageWhenLoginsuccess()
                    
                }
            }
        }
    }
    func tapAnyWhere(){
        self.usernameTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
    }
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            var rect:CGRect = self.view.frame
            let moreMinusPositionY = (self.view.frame.size.height) - (self.passwordTxt.frame.origin.y) - (self.passwordTxt.frame.size.height)
            rect.origin.y -= ((keyboardFrame.size.height+20) - moreMinusPositionY)
            self.view.frame = rect
            self.view.setNeedsDisplay()
        })
    }
    func keyboardWasHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            var rect:CGRect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
            self.view.setNeedsDisplay()
        })
    }
    func setIconImage(){
        Queue.mainQueue({
            self.logoImageview.image = UIImage(named: "logo_large")
            
        })
    }
    override func viewsNeedApplyFont() -> [UIView] {
        
        return [loginBtn,titleLabel]
        
    }
    override func stateAfterSetfont(){
        self.titleLabel.font = UIFont.fontMedium(20)
    }
    override func configLayout(){
        
        self.usernameTxt.backgroundColor = UIColor.RGB(240, G: 240, B: 240)
        self.passwordTxt.backgroundColor = UIColor.RGB(240, G: 240, B: 240)
        self.loginBtn.assignCornerRadius(5)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func isSuperAdmin(username:String!, password:String!)->Bool{
    
        if username == SUPER_ADMIN_USERNAME && password == SUPER_ADMIN_PASSWORD {
            return true
        }
        return false
    }
    func controllerWillClose() {
        
        self.usernameTxt.text = ""
        self.passwordTxt.text = ""
        
    }
    @IBAction func loginAction(sender: AnyObject) {
        
        self.usernameTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        user = User();
        user?.username = self.usernameTxt.text
        user?.password = self.passwordTxt.text
        
        if self.isSuperAdmin(user?.username!, password: user?.password!) {
            
            
            let urlController = URLConfigViewController.showOnController(self)
            urlController.delegate = self
    
            
            return
        }
        
        user?.login({ (result) in
            
            self.haldlerAfterLogin(result!)
            
        }, networkFail: { 
            SwiftSpinner.hide()
            AlertUtil.alertNetworkFail(self)
            
        })
        
        
        
    }
    
    func haldlerAfterLogin(result:Bool){
        SwiftSpinner.show("Retriving data..", animated: true)
        
        
        Category.syncCategory({
            
            SwiftSpinner.hide()
            
            if result == true {
                
                self.openPageWhenLoginsuccess()
                
            }else{
                AlertUtil.alert("Warning", message: "Login fail", cancleButton: "OK", atController: self)
            }
        })
        
        /*
         if result == true {
         
         SwiftSpinner.show("Retriving data..", animated: true)
         
         Category.syncCategory({
         
         SwiftSpinner.hide()
         
         self.openPageWhenLoginsuccess()
         
         })
         
         }else{
         AlertUtil.alert("Warning", message: "Login fail", cancleButton: "OK", atController: self)
         }
         */
    }
    func openPageWhenLoginsuccess() {
        let nzNavController:NZNavigationViewController = UIStoryboard(name: "NZNav", bundle: nil).instantiateViewControllerWithIdentifier("NZNavigationViewController") as! NZNavigationViewController
        let rootView:NZViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ROOT_VIEW_CONTROLLER) as! NZViewController
        
        
        self.presentViewController(nzNavController, animated: true) { () -> Void in
            
            
            
            nzNavController.setRootViewController(rootView)
            nzNavController.containerView.alpha = 0
            
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                
                nzNavController.containerView.alpha = 1
                
                }, completion: { (result) -> Void in
                    
            })
            
            
        }
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}
