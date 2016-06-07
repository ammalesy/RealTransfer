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
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showGettingStartView()
    }
    func showGettingStartView(){
        let controller:GettingStartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GettingStartViewController") as! GettingStartViewController
        controller.view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        controller.view.frame = UIScreen.mainScreen().bounds
        controller.view.layoutIfNeeded()
        let window:UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        window.addSubview(controller.view)
    }
}
