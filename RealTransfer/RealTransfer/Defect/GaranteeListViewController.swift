//
//  GaranteeListViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/27/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class GaranteeListViewController: DefectListViewController {

    @IBOutlet weak var allDefectBtn: UIButton!
    @IBOutlet weak var garanteeBtn: UIButton!
    var splitController:NZSplitViewController?
    
    
    var allDefect:Int = 0
    var garanteeDefect:Int = 0
    
    override func setNumberOfDefect() {
//        
//        var allDefect:Int = 0
//        var garanteeDefect:Int = 0
//        
//        if self.defectRoomRef != nil {
//            for defect:DefectModel in (((self.defectRoomRef?.listDefect)!  as NSArray) as! [DefectModel]) {
//                
//                if defect.df_type == "0" {
//                    allDefect += 1
//                }else{
//                    garanteeDefect += 1
//                }
//                
//            }
//        }
        
        self.allDefectBtn.setTitle("Defect ทั้งหมด (\(allDefect))", forState: UIControlState.Normal)
        self.garanteeBtn.setTitle("Guarantee (\(garanteeDefect))", forState: UIControlState.Normal)
        
    }
    override func className() -> String {
        return "GaranteeListViewController"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitController = (self.splitViewController as! NZSplitViewController)
        
        allDefectBtn.assignCornerRadius(5)
        garanteeBtn.assignCornerRadius(5)
    }

    @IBAction func alldefectAction(sender: AnyObject) {
        
        self.splitController?.nzNavigationController?.popViewControllerWithOutAnimate({ 
            
        })
    }
    @IBAction func garanteeAction(sender: AnyObject) {
        
    }
}
