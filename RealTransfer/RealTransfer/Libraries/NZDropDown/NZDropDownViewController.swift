//
//  NZDropDownViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//
import Foundation
import UIKit

protocol NZDropDownViewDelegate{
    func dropDownViewDidClickClose(view:NZDropDownViewController)
    func nzDropDown(contorller:NZDropDownViewController, didClickCell model:DropDownModel)
}

class NZDropDownViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    var delegate:NZDropDownViewDelegate! = nil
    var rawObjects:NSMutableArray = NSMutableArray()
    var displayObjects:NSMutableArray = NSMutableArray()
    var labelReference:UILabel?
    
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let cell:NZDropDowCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! NZDropDowCell
        cell.nameLabel.text = model.text
        
        return cell
        
    }
    func closeView() {
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        if self.delegate != nil {
            self.delegate.dropDownViewDidClickClose(self)
        }
    }
    func updatePositionAtView(view:UIView){
        let rows:Int = self.tableView(UITableView(), numberOfRowsInSection: 0)
        var height:Int = 79 * rows
        if CGFloat(height) > view.frame.size.height {
            height = Int(view.frame.size.height) - 20
        }
        let y:CGFloat = (view.frame.size.height / 2) - CGFloat((height / 2))
        
        let asjustWidthVal:CGFloat = 100
        var frameDP:CGRect = self.view.frame
        frameDP.size.height = CGFloat(height)
        frameDP.size.width = view.frame.size.width - asjustWidthVal
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
        self.labelReference?.text = model.text
        if (self.delegate != nil) {
            self.delegate.nzDropDown(self, didClickCell: model)
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

