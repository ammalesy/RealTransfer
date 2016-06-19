//
//  NZNavigationViewController.swift
//  NZNavigation
//
//  Created by AmmalesPSC91 on 6/3/2559 BE.
//  Copyright © 2559 dev.com. All rights reserved.
//

import UIKit

class NZNavigationViewController: UIViewController,NZPopoverViewDelegate {
    
    
    @IBOutlet weak var cusNameLb: UILabel!
    @IBOutlet weak var roomNoLb: UILabel!
    @IBOutlet weak var roomNoCaptionLb: UILabel!
    @IBOutlet weak var cusNameCaptionLb: UILabel!
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var widthLogoView: NSLayoutConstraint!
    @IBOutlet weak var leftMarginLogoView: NSLayoutConstraint!
    @IBOutlet weak var titleCenterY: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var subTitleLb: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    
    var popover:NZPopoverView!
    var storyBoard:UIStoryboard = UIStoryboard(name: "NZNav", bundle: nil)
    var viewControllers:NSMutableArray = NSMutableArray()
    let animationDuration:NSTimeInterval = 0.7

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.titleLb.font = UIFont.fontSemiBold(22)
        self.subTitleLb.font = UIFont.fontNormal(18)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func popViewController(completion: (() -> Void)?) {
        
        let beforeController:UIViewController = viewControllers.objectAtIndex(viewControllers.count - 2) as! UIViewController
        let lastController:UIViewController = viewControllers.lastObject as! UIViewController
        
        self.setX(-self.screenWidth(), controller: beforeController)
        
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            
            self.setX(0, controller: beforeController)
            self.setX(+self.screenWidth(), controller: lastController)
            if beforeController is NZViewController {
                (beforeController as! NZViewController).stateConfigData()
            }else if beforeController is NZSplitViewController {
                (beforeController as! NZSplitViewController).stateConfigData()
            }
            
        }) { (result) -> Void in
            self.popStack(lastController)
            
            if (completion != nil) {
                completion!()
            }
        }
    }
    func pushViewController(newController:UIViewController, completion: (() -> Void)?){
        
        let oldController:UIViewController = self.viewControllers.lastObject as! UIViewController
        
        self.setX(+self.screenWidth(), controller: newController)
        self.setHeight(self.containerView.frame.size.height, controller: newController)
        
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            
            self.setX(-self.screenWidth(), controller: oldController)
            self.pushStack(newController)
            if newController is NZViewController {
                (newController as! NZViewController).stateConfigData()
            }else if newController is NZSplitViewController {
                (newController as! NZSplitViewController).stateConfigData()
            }
            
        }) { (result) -> Void in
            
            self.setX(0, controller: oldController)
            
            if (completion != nil) {
                completion!()
            }
        }
    }
    
    
    private func pushStack(controller:UIViewController!){
        
        if controller is NZViewController {
            (controller as! NZViewController).nzNavigationController = self
        }else if controller is NZSplitViewController {
            (controller as! NZSplitViewController).nzNavigationController = self
        }
        
        self.viewControllers.addObject(controller)
        self.replaceViewToContainer(controller)
        self.setX(0, controller: controller)
    }
    private func popStack(controller:UIViewController!){
        self.removeViewOnContainer(controller)
        self.viewControllers.removeLastObject()
    }
    private func setX(x:CGFloat, controller:UIViewController!){
        var oldViewFrmae:CGRect = controller.view.frame
        oldViewFrmae.origin.x = x
        controller.view.frame = oldViewFrmae
        controller.view.setNeedsDisplay()
    }
    private func setHeight(height:CGFloat, controller:UIViewController!){
        var oldViewFrmae:CGRect = controller.view.frame
        oldViewFrmae.size.height = height
        controller.view.frame = oldViewFrmae
        controller.view.setNeedsDisplay()
    }
    private func replaceViewToContainer(controller:UIViewController!){
        self.removeViewOnContainer(viewControllers.lastObject as! UIViewController)
        controller.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
        controller.view.setNeedsDisplay()
        self.containerView.setNeedsDisplay()
        
        self.addChildViewController(controller)
        self.containerView.addSubview(controller.view)
        
    }
    private func removeViewOnContainer(controller:UIViewController!){
        
        controller.view.removeFromSuperview()
        
    }
    func setRootViewController(controller:UIViewController!){
        
        viewControllers.removeAllObjects()
        viewControllers.addObject(controller)
        self.replaceViewToContainer(controller)
        
        if controller is NZViewController {
            (controller as! NZViewController).nzNavigationController = self
            (controller as! NZViewController).stateConfigData()
        }else if controller is NZSplitViewController {
            (controller as! NZSplitViewController).nzNavigationController = self
            (controller as! NZSplitViewController).stateConfigData()
        }
    }
    private func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideMenuPopoverIfViewIsShowing()
    }
    @IBAction func menuPopover(sender: AnyObject) {
        
        if popover != nil {
            popover.hide()
            popover = nil
        }else{
            popover = NZPopoverView.standardSize()
            popover.delegate = self
            popover.addRow(NZRow(text: "View info", imageName:"Info-97", tintColor: UIColor.darkGrayColor(),  identifier: "info"))
            popover.addRow(NZRow(text: "Sign out", imageName:"Enter-96", tintColor: UIColor(red: 223/255, green: 0/255, blue: 0/255, alpha: 1),  identifier: "logout"))
            
            popover.showNearView(sender as! UIButton, addToView: self.view)
        }
        
    }
    func showBackButton() {
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            self.widthLogoView.constant = 100
            self.leftMarginLogoView.constant = 40
            self.logoView.updateConstraints()
            self.logoView.layoutIfNeeded()

        }) { (result) -> Void in
                
        }
    }
    func hideBackButton() {
    
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            self.widthLogoView.constant = 120
            self.leftMarginLogoView.constant = 0
            self.logoView.updateConstraints()
            self.logoView.layoutIfNeeded()
            
        }) { (result) -> Void in
                
        }
        
    }
    @IBAction func backAction(sender: AnyObject) {
        self.popViewController { () -> Void in
            
            let lastController:AnyObject = self.viewControllers.lastObject!
            if lastController is ProjectViewController {
                self.hideBackButton()
            }
            
        }
    }
    
    func hideMenuPopoverIfViewIsShowing(){
        if popover != nil {
            popover.hide()
            popover = nil
        }
    }
    func popoverView(view: NZPopoverView, didClickRow menu: NZRow) {
        
        if menu.identifier == "logout" {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                PROJECT = nil
                Building.buldings.removeAllObjects()
                CSRoleModel.csUSers.removeAllObjects()
            })
        }
        else if menu.identifier == "info" {
            showCustomerInfoView()
        }
        
    }
    func showCustomerInfoView(){
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:CustomerInfoViewController = sb.instantiateViewControllerWithIdentifier("CustomerInfoViewController") as! CustomerInfoViewController
        controller.view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        controller.view.frame = (self.view.frame)
        controller.view.layoutIfNeeded()
        
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
    func hideRightInfo(flag:Bool){
        self.cusNameLb.hidden = flag
        self.roomNoLb.hidden = flag
        self.roomNoCaptionLb.hidden = flag
        self.cusNameCaptionLb.hidden = flag
    }
}
