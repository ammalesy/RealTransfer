//
//  GaranteeListViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/27/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class GaranteeListViewController: DefectListViewController {

    
    static var shareInstance:GaranteeListViewController?
    
    @IBOutlet weak var allDefectBtn: UIButton!
    @IBOutlet weak var garanteeBtn: UIButton!
    var splitController:NZSplitViewController?
    
    
    var allDefect:Int = 0
    var garanteeDefect:Int = 0
    
    
    class func sharedInstance()->GaranteeListViewController {
        if self.shareInstance == nil {
            self.shareInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GaranteeListViewController") as? GaranteeListViewController
        }
        return self.shareInstance!
    }
    class func desTroyShareInstance() {
        
        self.shareInstance = nil;
        
    }
    
    override func setNumberOfDefect() {
        self.allDefectBtn.setTitle("Defect ทั้งหมด (\(allDefect))", forState: UIControlState.Normal)
        self.setGuaranteeCount(garanteeDefect)
    }
    override func setNumberOfDefect(number:Int){
        self.garanteeBtn.setTitle("Guarantee (\(number))", forState: UIControlState.Normal)
    }
    override func setNumberOfDefect(number:Int, title:String!){
        self.garanteeBtn.setTitle("\(title) (\(number))", forState: UIControlState.Normal)
    }
    
    func plusCountGuaranteeDefectValue() {
        garanteeDefect += 1
        self.setGuaranteeCount(garanteeDefect)
    }
    func setGuaranteeCount(number:Int){
        self.garanteeBtn.setTitle("Guarantee (\(number))", forState: UIControlState.Normal)
    }
    override func className() -> String {
        return "GaranteeListViewController"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitController = (self.splitViewController as! NZSplitViewController)
        
        allDefectBtn.assignCornerRadius(5)
        garanteeBtn.assignCornerRadius(5)
        
        garanteeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        garanteeBtn.titleLabel?.numberOfLines = 2
        
       
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
         self.filterWithKey(self.filterSelected)
    }

    @IBAction func alldefectAction(sender: AnyObject) {
        
        self.splitController?.nzNavigationController?.popViewControllerWithOutAnimate({ 
            
        })
    }
    @IBAction func garanteeAction(sender: AnyObject) {
        super.openDropDown(String())
    }
    
}
