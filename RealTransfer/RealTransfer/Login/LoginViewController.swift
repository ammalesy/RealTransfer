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

class LoginViewController: NZViewController {

    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var textFieldActive:UITextField?
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setIconImage()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapAnyWhere))
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
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
    @IBAction func loginAction(sender: AnyObject) {
        
        user = User();
        user?.username = self.usernameTxt.text
        user?.password = self.passwordTxt.text
        
        if self.isSuperAdmin(user?.username!, password: user?.password!) {
         
            let alert = UIAlertController(title: "Initial new baseurl", message:"", preferredStyle: UIAlertControllerStyle.Alert)
            let cancleAction:UIAlertAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.Cancel, handler: { (action) in
                
                let txts:[UITextField] = alert.textFields!
                txts[0].resignFirstResponder()
                
            })
            let okAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
                
                let txts:[UITextField] = alert.textFields!
                PathUtil.sharedInstance.setServerPath(txts[0].text!)
                txts[0].resignFirstResponder()
                alert.dismissViewControllerAnimated(true, completion: { 
                    
                })
                
            })
            alert.addTextFieldWithConfigurationHandler({ (txt1) in
                txt1.text = DOMAIN_NAME
                (txt1 as UITextField).placeholder = "https://domainname.com/Service"
            })
            alert.addAction(cancleAction)
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
            return
        }
        
        user?.login({ (result) in
            
            SwiftSpinner.show("Retriving data..", animated: true)
            
            
            Category.syncCategory({
                
                SwiftSpinner.hide()
                
                if result == true {
                    
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
                }else{
                    AlertUtil.alert("Warning", message: "Login fail", cancleButton: "OK", atController: self)
                }
            })
            
        }, networkFail: { 
            SwiftSpinner.hide()
            AlertUtil.alertNetworkFail(self)
            
        })
        
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}
