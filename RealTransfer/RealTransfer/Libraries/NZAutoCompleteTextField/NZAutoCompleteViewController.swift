//
//  NZAutoCompleteViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/9/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

protocol NZAutoCompleteViewDelegate{
    func autoCompleteViewWillClose(view:NZAutoCompleteViewController)
    func nzAutoComplete(contorller:NZAutoCompleteViewController, didClickCell model:AutoCompleteModel)
}

class NZAutoCompleteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var rawObjects:NSMutableArray = NSMutableArray()
    var displayObjects:NSMutableArray = NSMutableArray()
    var textFieldReference:UITextField?
    
    var delegate:NZAutoCompleteViewDelegate! = nil
    
    var userInfo:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()

        
        self.view.layer.borderColor = UIColor.RGB(246, G: 245, B: 251).CGColor
        self.view.layer.borderWidth = 1.0
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.3
        self.view.layer.shadowOffset = CGSizeMake(1, 1)
        self.view.layer.shadowRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return displayObjects.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let model:AutoCompleteModel = displayObjects.objectAtIndex(indexPath.row) as! AutoCompleteModel
        let cell:NZAutoCompleteCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! NZAutoCompleteCell
        cell.textLb.text = model.text
        return cell
    }
    func closeView() {
        self.textFieldReference?.resignFirstResponder()
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        if self.delegate != nil {
            self.delegate.autoCompleteViewWillClose(self)
        }
        
    }
    func updatePositionAtView(view:UIView, positionRect:CGRect){
        
        let y:CGFloat = positionRect.origin.y + positionRect.size.height + 80

        let asjustWidthVal:CGFloat = 100
        var frameDP:CGRect = self.view.frame
        frameDP.size.height = 130
        frameDP.size.width = view.frame.size.width - asjustWidthVal
        frameDP.origin.x += asjustWidthVal / 2
        frameDP.origin.y = y
        self.view.frame = frameDP
        self.view.setNeedsDisplay()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let model:AutoCompleteModel = displayObjects.objectAtIndex(indexPath.row) as! AutoCompleteModel
        self.textFieldReference?.text = model.text
        if (self.delegate != nil) {
            self.delegate.nzAutoComplete(self, didClickCell: model)
        }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
