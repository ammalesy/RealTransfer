//
//  LoginViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: NZViewController {

    @IBOutlet weak var logoImageview: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewsNeedApplyFont() -> [UIView] {
        
        return [usernameTxt,passwordTxt,loginBtn,titleLabel]
        
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


    @IBAction func loginAction(sender: AnyObject) {
        
        user = User();
        user?.username = self.usernameTxt.text
        user?.password = self.passwordTxt.text
        user?.login({ (result) in
            
            Category.syncCategory({

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
                    let alert = UIAlertController(title: "Fail", message: "Fail", preferredStyle: UIAlertControllerStyle.Alert)
                    let action:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
                        
                    })
                    alert.addAction(action)
                    
                    self.presentViewController(alert, animated: true, completion: {
                        
                    })
                }
            })
    
            
            
        })
        
        
        
    }
}
