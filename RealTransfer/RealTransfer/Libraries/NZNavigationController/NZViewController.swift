//
//  NZViewController.swift
//  NZNavigation
//
//  Created by AmmalesPSC91 on 6/3/2559 BE.
//  Copyright © 2559 dev.com. All rights reserved.
//

import UIKit

class NZViewController: UIViewController {
    
    var nzNavigationController:NZNavigationViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("touchAnyWare"))
        self.view.addGestureRecognizer(tap)
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
        self.stateInitialData()
    }
    internal func configLayout(){

    }
    internal func viewsNeedApplyFont()->[UIView]{
        return []
    }
    internal func stateAfterSetfont() {
    
    }
    internal func stateInitialData() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.nzNavigationController != nil {
        
            if self.nzNavigationController!.popover != nil {
                nzNavigationController!.popover.hide()
                nzNavigationController!.popover = nil
            }
            
        }
    }
    func touchAnyWare(){
        if self.nzNavigationController != nil {
            if self.nzNavigationController!.popover != nil {
                self.nzNavigationController!.popover.hide()
                self.nzNavigationController!.popover = nil
            }
        }
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
