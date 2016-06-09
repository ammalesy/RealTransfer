//
//  DefectViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import Foundation
import UIKit

class DefectViewController: NZViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    override func configLayout() {
        
    }
    override func viewsNeedApplyFont() -> [UIView] {
        return []
    }
    override func stateConfigData() {
        self.nzNavigationController?.titleLb.text = "The Capital Ekamai Thonglor"
        self.nzNavigationController?.subTitleLb.text = ""
        self.nzNavigationController?.titleCenterY.constant = 0
        self.nzNavigationController?.titleLb.updateConstraints()
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.nzNavigationController?.viewControllers.lastObject is DefectViewController) {
            Queue.mainQueue { () -> Void in
                self.showGettingStartView()
            }
        }
        
    }
    func showGettingStartView(){
        let controller:GettingStartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GettingStartViewController") as! GettingStartViewController
        controller.view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        controller.view.frame = (self.nzNavigationController?.view.frame)!
        controller.view.layoutIfNeeded()
        controller.nzNavigationController = self.nzNavigationController

        self.nzNavigationController?.addChildViewController(controller)
        self.nzNavigationController?.view.addSubview(controller.view)
        controller.didMoveToParentViewController(self.nzNavigationController)
    }
}
