//
//  NZDropDownViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//
import Foundation
import UIKit

let NZ_DROPDOWN_NOT_NEED_CUSTOM_POSITION_Y:CGFloat = 9897654329.98

@objc protocol NZDropDownViewDelegate{
     optional func dropDownViewDidClose(view:NZDropDownViewController)
     optional func nzDropDown(contorller:NZDropDownViewController, didClickCell model:DropDownModel)
     optional func nzDropDown(contorller:NZDropDownViewController, shouldDisplayCell model:DropDownModel) -> Bool
     optional func nzDropDownCustomPositon(contorller:NZDropDownViewController) -> CGRect
     optional func nzDropDownCustomYPositon(contorller:NZDropDownViewController, width:CGFloat, height:CGFloat) -> CGFloat
     optional func nzDropDownHideSearchPanel(contorller:NZDropDownViewController) -> Bool
     optional func nzDropDownViewdidAppear(contorller:NZDropDownViewController)
}

class NZDropDownViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    var userInfo:AnyObject?
    
    @IBOutlet weak var searchPanelView: UIView!
    @IBOutlet weak var heightSearchPanel: NSLayoutConstraint!
    var disableSearch:Bool = false
    var identifier:String?
    var delegate:NZDropDownViewDelegate? = nil
    var rawObjects:NSMutableArray = NSMutableArray()
    var displayObjects:NSMutableArray = NSMutableArray()
    var labelReference:UIView?
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((self.delegate != nil) &&
            (self.delegate as! NSObject).respondsToSelector(#selector(NZDropDownViewDelegate.nzDropDownViewdidAppear(_:))))
        {
            
            self.delegate!.nzDropDownViewdidAppear!(self)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 62
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.view.layer.borderColor = UIColor.RGB(246, G: 245, B: 251).CGColor
        self.view.layer.borderWidth = 1.0
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.3
        self.view.layer.shadowOffset = CGSizeMake(1, 1)
        self.view.layer.shadowRadius = 3
        
        self.searchTxt.delegate = self
        
        if ((self.delegate != nil) &&
            (self.delegate as! NSObject).respondsToSelector(#selector(NZDropDownViewDelegate.nzDropDownHideSearchPanel(_:))))
        {
            
            let flag:Bool = self.delegate!.nzDropDownHideSearchPanel!(self)
            self.hideSearchPanel(flag)
        }
        
        if disableSearch == true {
            self.searchButton.hidden = true
            self.searchTxt.userInteractionEnabled = false
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayObjects.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let model:DropDownModel = displayObjects.objectAtIndex(indexPath.row) as! DropDownModel
        var cell:NZDropDowCell?
        if model.iconColor == nil {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? NZDropDowCell
            cell!.nameLabel.text = model.text
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("CellIconColor") as? NZDropDownIconColorCell
            (cell as! NZDropDownIconColorCell).nameLabel.text = model.text!
            (cell as! NZDropDownIconColorCell).iconView.backgroundColor = model.iconColor!
        }
        
        return cell!
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if ((self.delegate != nil) &&
            (self.delegate as! NSObject).respondsToSelector(#selector(NZDropDownViewDelegate.nzDropDown(_:shouldDisplayCell:))))
        {
            let model:DropDownModel = displayObjects.objectAtIndex(indexPath.row) as! DropDownModel
            let shouldDisplay = self.delegate!.nzDropDown!(self, shouldDisplayCell: model)
            if shouldDisplay == false {
                return 0
            }
            
        }
        
        return UITableViewAutomaticDimension
    }
    func closeView() {
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        if self.delegate != nil {
            self.delegate!.dropDownViewDidClose!(self)
        }
    }
    func updatePositionAtView(view:UIView){
        let asjustWidthVal:CGFloat = 100
        var frameDP:CGRect = self.view.frame
        
        if ((self.delegate != nil) &&
            (self.delegate as! NSObject).respondsToSelector(#selector(NZDropDownViewDelegate.nzDropDownCustomPositon(_:))))
        {
        
            let rect:CGRect = self.delegate!.nzDropDownCustomPositon!(self)
            if rect != CGRectZero {
                self.view.frame = rect
                self.view.setNeedsDisplay()
                return
            }
        }
        
        let rows:Int = self.tableView(UITableView(), numberOfRowsInSection: 0)
        var height:Int = 79 * rows
        if height < 120 {
            height = 120
        }
        if CGFloat(height) > view.frame.size.height {
            height = Int(view.frame.size.height) - 80
        }
        frameDP.size.height = CGFloat(height)
        frameDP.size.width = view.frame.size.width - asjustWidthVal
        
        var y:CGFloat = (view.frame.size.height / 2) - CGFloat((height / 2))
        
        if ((self.delegate != nil) &&
            (self.delegate as! NSObject).respondsToSelector(#selector(NZDropDownViewDelegate.nzDropDownCustomYPositon(_:width:height:))))
        {
            
            let yDelegate:CGFloat = self.delegate!.nzDropDownCustomYPositon!(self, width: frameDP.size.width, height: frameDP.size.height)
            if yDelegate != NZ_DROPDOWN_NOT_NEED_CUSTOM_POSITION_Y {
                y = yDelegate
            }
        }
        frameDP.origin.x += asjustWidthVal / 2
        frameDP.origin.y = y
        self.view.frame = frameDP
        self.view.setNeedsDisplay()
        
        
        
    }
    @IBAction func searchAction(sender: AnyObject) {
        let str:String = searchTxt.text!
        self.searchWithString(str)
        
    }
    func searchWithString(str:String){
        
        if str == "" {
            displayObjects = rawObjects.mutableCopy() as! NSMutableArray
        }else{
            let resultPredicate:NSPredicate = NSPredicate(format: "text contains[c] %@", str)
            
            let resultArray:[AnyObject] = rawObjects.filteredArrayUsingPredicate(resultPredicate)
            displayObjects.removeAllObjects()
            for obj in resultArray {
                displayObjects.addObject(obj)
            }
        }
        self.tableView.reloadData()
    
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let realString:String = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        self.searchWithString(realString)
        
        return true
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let model:DropDownModel = displayObjects.objectAtIndex(indexPath.row) as! DropDownModel
        
        if self.labelReference is UILabel {
            (self.labelReference as! UILabel).text = model.text
        }else if self.labelReference is UIButton {
            (self.labelReference as! UIButton).setTitle(model.text, forState: UIControlState.Normal)
        }
        
        if (self.delegate != nil) {
            self.delegate!.nzDropDown!(self, didClickCell: model)
        }
        
    }
    private func hideSearchPanel(flag:Bool!){
    
        if flag == true {
            self.disableSearch = true
            heightSearchPanel.constant = 0
        }else{
            self.disableSearch = false
            heightSearchPanel.constant = 60
        }
        searchPanelView.updateConstraints()
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

