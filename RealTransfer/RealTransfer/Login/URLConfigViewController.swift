//
//  URLConfigViewController.swift
//  RealTransfer
//
//  Created by Apple on 8/6/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

protocol URLConfigViewControllerDelegate {
    
    func controllerWillClose()
}

class URLConfigViewController: UIViewController,UITextFieldDelegate {

    var delegate:URLConfigViewControllerDelegate? = nil
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var protocolSegment: UISegmentedControl!
    @IBOutlet weak var txtDomainName: UITextField!
    @IBOutlet weak var txtWebDir: UITextField!
    @IBOutlet weak var txtApiDir: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtDomainName.delegate = self
        self.txtWebDir.delegate = self
        self.txtApiDir.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == self.txtDomainName {
            txtWebDir.resignFirstResponder()
            txtApiDir.resignFirstResponder()
            Queue.mainQueue({ 
                self.txtDomainName.becomeFirstResponder()
            })
            
        }
        if textField == self.txtWebDir {
            txtDomainName.resignFirstResponder()
            txtApiDir.resignFirstResponder()
            Queue.mainQueue({
                self.txtWebDir.becomeFirstResponder()
            })
        }
        if textField == self.txtApiDir {
            txtWebDir.resignFirstResponder()
            txtDomainName.resignFirstResponder()
            Queue.mainQueue({
                self.txtApiDir.becomeFirstResponder()
            })
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateTxt()->Bool{
    
        if self.txtDomainName.text == "" || self.txtWebDir.text == "" || self.txtApiDir.text == "" {
            return false
        }
        return true
    }

    @IBAction func okAction(sender: AnyObject) {
        
        if self.validateTxt() {
            
            let pathUtil = PathUtil.sharedInstance
            if self.protocolSegment.selectedSegmentIndex == 0 {
                pathUtil.set_urlProtocol("https://")
            }else{
                pathUtil.set_urlProtocol("http://")
            }
            
            pathUtil.set_DomainName((self.txtDomainName.text! as NSString).trim())
            pathUtil.set_WebDir((self.txtWebDir.text! as NSString).trim())
            pathUtil.set_ApiDir((self.txtApiDir.text! as NSString).trim())
            
            pathUtil.refresh()
            
            self.delegate?.controllerWillClose()
            closeView()
        }else{
            AlertUtil.alert("พบข้อผิดพลาด", message: "กรุณากรอกข้อมูลให้ครบถ้วน", cancleButton: "OK", atController: self)
        }
    }
    @IBAction func cancelAction(sender: AnyObject) {
        self.delegate?.controllerWillClose()
        closeView()
    }
    
    func closeView(){
    
        self.view.alpha = 1
        UIView.animateWithDuration(0.8, animations: {
            self.view.alpha = 0
            
        }) { (flag) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    class func showOnController(tarGetcontroller:UIViewController)->URLConfigViewController{
        
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:URLConfigViewController = sb.instantiateViewControllerWithIdentifier("URLConfigViewController") as! URLConfigViewController
        controller.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        controller.view.frame = (tarGetcontroller.view.frame)
        controller.view.layoutIfNeeded()
        controller.assignValue()
        
        controller.view.alpha = 0
        UIView.animateWithDuration(0.8, animations: { 
            controller.view.alpha = 1
            tarGetcontroller.addChildViewController(controller)
            tarGetcontroller.view.addSubview(controller.view)
            controller.didMoveToParentViewController(tarGetcontroller)
            
        }) { (flag) in
            
        }
        
        return controller
    }
    func assignValue(){
        if PathUtil.sharedInstance.urlProtocol == "https://" {
            self.protocolSegment.selectedSegmentIndex = 0
        }else{
            self.protocolSegment.selectedSegmentIndex = 1
        }
        
        let domainNameStr = PathUtil.sharedInstance.domainName
        let webDirStr = PathUtil.sharedInstance.webDir
        let apiDirStr = PathUtil.sharedInstance.apiDir
        
        self.txtDomainName.text = domainNameStr
        self.txtWebDir.text = webDirStr
        self.txtApiDir.text = apiDirStr
    }

}
