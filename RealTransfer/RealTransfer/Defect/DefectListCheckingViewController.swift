//
//  DefectListCheckingViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/28/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class DefectListCheckingViewController: NZViewController {

    @IBOutlet weak var alldefectBtn: UIButton!
    @IBOutlet weak var garanteeBtn: UIButton!
    
    var defectRoomRef:DefectRoom?
    
    
    @IBAction func garanteeAction(sender: AnyObject) {
        
        let split:NZSplitViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NZSplitViewController") as! NZSplitViewController
        let controllers:[UIViewController] = split.viewControllers;
        let nav:UINavigationController = controllers[1] as! UINavigationController
        let subsNav:[UIViewController] = nav.viewControllers
        if subsNav[0] is AddDefectViewController {
            let addDefectViewController:AddDefectViewController = subsNav[0] as! AddDefectViewController
            addDefectViewController.project = PROJECT
            addDefectViewController.needShowGettingStart = false

        }
        
        split.minimumPrimaryColumnWidth = 400
        split.maximumPrimaryColumnWidth = 400
        self.nzNavigationController?.pushViewControllerWithOutAnimate(split, completion: { () -> Void in
            
            
                    let garanteeListViewController:GaranteeListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GaranteeListViewController") as! GaranteeListViewController
                    garanteeListViewController.reloadData(self.defectRoomRef!, type: "1")
            
                    split.viewControllers[0] = garanteeListViewController
            
                    let controllers:[UIViewController] = (split.viewControllers)
            
                    for controller in controllers {
            
                        if controller is UINavigationController {
                            let nav:UINavigationController = controller as! UINavigationController
                            let addDefectViewController:AddDefectViewController = nav.viewControllers[0] as! AddDefectViewController
                            addDefectViewController.defectRoom = self.defectRoomRef!
                        }
                    }
            
            
        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alldefectBtn.assignCornerRadius(5)
        garanteeBtn.assignCornerRadius(5)
    }
}
