//
//  NZNavigationViewController.swift
//  NZNavigation
//
//  Created by AmmalesPSC91 on 6/3/2559 BE.
//  Copyright © 2559 dev.com. All rights reserved.
//

import UIKit

class NZNavigationViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var widthLogoView: NSLayoutConstraint!
    @IBOutlet weak var leftMarginLogoView: NSLayoutConstraint!
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
        
        let beforeController:NZViewController = viewControllers.objectAtIndex(viewControllers.count - 2) as! NZViewController
        let lastController:NZViewController = viewControllers.lastObject as! NZViewController
        
        self.setX(-self.screenWidth(), controller: beforeController)
        
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            
            self.setX(0, controller: beforeController)
            self.setX(+self.screenWidth(), controller: lastController)
            
            
        }) { (result) -> Void in
            self.popStack(lastController)
            
            if (completion != nil) {
                completion!()
            }
        }
    }
    func pushViewController(newController:NZViewController, completion: (() -> Void)?){
        
        let oldController:NZViewController = self.viewControllers.lastObject as! NZViewController
        
        self.setX(+self.screenWidth(), controller: newController)
        self.setHeight(self.containerView.frame.size.height, controller: newController)
        
        UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
            
            self.setX(-self.screenWidth(), controller: oldController)
            self.pushStack(newController)
            
        }) { (result) -> Void in
            
            self.setX(0, controller: oldController)
            
            if (completion != nil) {
                completion!()
            }
        }
    }
    
    
    private func pushStack(controller:NZViewController!){
        controller.nzNavigationController = self
        self.viewControllers.addObject(controller)
        self.replaceViewToContainer(controller)
        self.setX(0, controller: controller)
    }
    private func popStack(controller:NZViewController!){
        self.removeViewOnContainer(controller)
        self.viewControllers.removeLastObject()
    }
    private func setX(x:CGFloat, controller:NZViewController!){
        var oldViewFrmae:CGRect = controller.view.frame
        oldViewFrmae.origin.x = x
        controller.view.frame = oldViewFrmae
        controller.view.setNeedsDisplay()
    }
    private func setHeight(height:CGFloat, controller:NZViewController!){
        var oldViewFrmae:CGRect = controller.view.frame
        oldViewFrmae.size.height = height
        controller.view.frame = oldViewFrmae
        controller.view.setNeedsDisplay()
    }
    private func replaceViewToContainer(controller:NZViewController!){
        self.removeViewOnContainer(viewControllers.lastObject as! NZViewController)
        controller.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height)
        controller.view.setNeedsDisplay()
        self.containerView.setNeedsDisplay()
        
       
        self.containerView.addSubview(controller.view)
        //self.addChildViewController(controller)
    }
    private func removeViewOnContainer(controller:NZViewController!){
        
        controller.view.removeFromSuperview()
        
    }
    func setRootViewController(controller:NZViewController!){
        controller.nzNavigationController = self
        viewControllers.removeAllObjects()
        viewControllers.addObject(controller)
        self.replaceViewToContainer(controller)
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
            //popover.delegate = self
            popover.addRow(NZRow(text: "View info", imageName:"Info-97", tintColor: UIColor.darkGrayColor(),  identifier: "id1"))
            popover.addRow(NZRow(text: "Sign out", imageName:"Enter-96", tintColor: UIColor(red: 223/255, green: 0/255, blue: 0/255, alpha: 1),  identifier: "id2"))
            
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
}
