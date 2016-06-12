//
//  GettingStartViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
let CELL_LABEL_STATIC_IDENTIFIER = "CellLabelStatic"
let CELL_DROUP_DOWN_IDENTIFIER = "CellDropDown"
let CELL_TXT_SEARCH_IDENTIFIER = "CellTxtSearch"
let CELL_INFO_LABEL_IDENTIFIER = "CellInfoLabel"

class GettingStartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NZDropDownViewDelegate,CellTxtSearchDelegate,NZAutoCompleteViewDelegate,UITextFieldDelegate {
    
    var dropDownController:NZDropDownViewController?
    var autoCompleteController:NZAutoCompleteViewController?
    
    var nzNavigationController:NZNavigationViewController?

    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var components:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panelView.layer.shadowColor = UIColor.blackColor().CGColor
        self.panelView.layer.shadowOpacity = 0.3
        self.panelView.layer.shadowOffset = CGSizeMake(1, 1)
        self.panelView.layer.shadowRadius = 2
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        let row1:RowModel = RowModel()
        row1.head = "Project : "
        row1.detail = "Than living rama 9"
        row1.style = CELL_LABEL_STATIC_IDENTIFIER
        components.addObject(row1);

        let row2:RowModel = RowModel()
        row2.head = "Building : "
        row2.style = CELL_DROUP_DOWN_IDENTIFIER
        components.addObject(row2);
        
        let row3:RowModel = RowModel()
        row3.head = "Room : "
        row3.style = CELL_TXT_SEARCH_IDENTIFIER
        row3.colorNextbutton = UIColor.RGB(192, G: 193, B: 194)
        components.addObject(row3);
        
        

    }
    func addInfo()
    {
        let row4:RowInfoModel = RowInfoModel()
        row4.style = CELL_INFO_LABEL_IDENTIFIER
        row4.headInfo1 = "Name : "
        row4.headInfo2 = "Email : "
        row4.headInfo3 = "Phone No.: "
        row4.headInfo4 = "Room Type : "
        row4.headInfo5 = "Unit Type : "
        row4.headInfo6 = "Check Date : "
        row4.headInfo7 = "Defect No : "
        row4.headInfo8 = "QC Checker : "
        
        row4.detailInfo1 = "Kaniga Mingsong"
        row4.detailInfo2 = "phuncharat@mintedimages.com"
        row4.detailInfo3 = "080-123-4567"
        row4.detailInfo4 = "1 Bedroom"
        row4.detailInfo5 = "1A-M"
        row4.detailInfo6 = "25/4/2016"
        row4.detailInfo7 = "01/2016"
        row4.detailInfo8 = "Ammales Yamsompong"
        components.addObject(row4);
        
        let row5:RowModel = RowModel()
        row5.head = "CS : "
        row5.detail = "Tanakarn Chinratana"
        row5.style = CELL_DROUP_DOWN_IDENTIFIER
        components.addObject(row5);
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data:RowModel = components.objectAtIndex(indexPath.row) as! RowModel
        
        if data.style == CELL_LABEL_STATIC_IDENTIFIER
        {
            let cell:CellLabelStatic = tableView.dequeueReusableCellWithIdentifier(CELL_LABEL_STATIC_IDENTIFIER) as! CellLabelStatic
            cell.leftLabel.text = data.head
            cell.rightLabel.text = data.detail
            return cell
        }
        else if data.style == CELL_DROUP_DOWN_IDENTIFIER
        {
            let cell:CellDropDown = tableView.dequeueReusableCellWithIdentifier(CELL_DROUP_DOWN_IDENTIFIER) as! CellDropDown
            cell.leftLabel.text = data.head
            cell.rightLabel.text = data.detail
            return cell
        }
        else if data.style == CELL_TXT_SEARCH_IDENTIFIER
        {
                        let cell:CellTxtSearch = tableView.dequeueReusableCellWithIdentifier(CELL_TXT_SEARCH_IDENTIFIER) as! CellTxtSearch
            cell.leftLabel.text = data.head
            cell.delegate = self
            cell.nextBtn.setTitleColor(data.colorNextbutton, forState: UIControlState.Normal)
            return cell
        }
        else if data.style == CELL_INFO_LABEL_IDENTIFIER
        {
            let cell:CellInfoLabel = tableView.dequeueReusableCellWithIdentifier(CELL_INFO_LABEL_IDENTIFIER) as! CellInfoLabel
            cell.leftLabel1.text = (data as! RowInfoModel).headInfo1
            cell.leftLabel2.text = (data as! RowInfoModel).headInfo2
            cell.leftLabel3.text = (data as! RowInfoModel).headInfo3
            cell.leftLabel4.text = (data as! RowInfoModel).headInfo4
            cell.leftLabel5.text = (data as! RowInfoModel).headInfo5
            cell.leftLabel6.text = (data as! RowInfoModel).headInfo6
            cell.leftLabel7.text = (data as! RowInfoModel).headInfo7
            cell.leftLabel8.text = (data as! RowInfoModel).headInfo8
            
            cell.rightLabel1.text = (data as! RowInfoModel).detailInfo1
            cell.rightLabel2.text = (data as! RowInfoModel).detailInfo2
            cell.rightLabel3.text = (data as! RowInfoModel).detailInfo3
            cell.rightLabel4.text = (data as! RowInfoModel).detailInfo4
            cell.rightLabel5.text = (data as! RowInfoModel).detailInfo5
            cell.rightLabel6.text = (data as! RowInfoModel).detailInfo6
            cell.rightLabel7.text = (data as! RowInfoModel).detailInfo7
            cell.rightLabel8.text = (data as! RowInfoModel).detailInfo8
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let data:RowModel = components.objectAtIndex(indexPath.row) as! RowModel
        if data is RowInfoModel {
            return 260
        }else{
            return 60
        }
    }

    @IBAction func startAction(sender: AnyObject) {
        Queue.mainQueue { () -> Void in
            
            self.hideView()
            
            Queue.mainQueue({ () -> Void in
                let split:NZSplitViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NZSplitViewController") as! NZSplitViewController
                split.minimumPrimaryColumnWidth = 400
                split.maximumPrimaryColumnWidth = 400
                self.nzNavigationController?.pushViewController(split, completion: { () -> Void in
                    
                })
            })
        }
    }
    @IBAction func exitAction(sender: AnyObject) {
        
        self.hideView()

    }
    func hideView(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.view.alpha = 0
            
        }) { (result) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let data:RowModel = components.objectAtIndex(indexPath.row) as! RowModel
        if data.style == CELL_DROUP_DOWN_IDENTIFIER
        {
            if dropDownController != nil {
                return
            }
            let cell:CellDropDown = self.tableView.cellForRowAtIndexPath(indexPath) as! CellDropDown
            self.generateDropDownAndParseDataWithCell(cell)
            
        }else if data.style == CELL_TXT_SEARCH_IDENTIFIER
        {
            if autoCompleteController != nil {
                return
            }
            let cell:CellTxtSearch = self.tableView.cellForRowAtIndexPath(indexPath) as! CellTxtSearch
            self.generateAutoCompleteTextFieldAndParseDataWithCell(cell)
            
        }
    }
    func cellTxtSearchBeginEditting(cell: CellTxtSearch, textField: UITextField) {
        if autoCompleteController != nil {
            return
        }
        self.generateAutoCompleteTextFieldAndParseDataWithCell(cell)
    }
    func cellTxtSearchTextChange(string: String) {
        
        autoCompleteController?.searchWithString(string)
        
    }
    func nzDropDown(contorller: NZDropDownViewController, didClickCell model: DropDownModel) {
        
        self.closeDropDown()
        
    }
    func nzAutoComplete(contorller: NZAutoCompleteViewController, didClickCell model: AutoCompleteModel) {
        
        self.closeAutoComplete()
        
    }
    func dropDownViewDidClose(view: NZDropDownViewController) {
        
        self.tableView.scrollEnabled = true
        
    }
    func autoCompleteViewWillClose(view: NZAutoCompleteViewController) {
        self.tableView.scrollEnabled = true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.closeDropDown()
        self.closeAutoComplete()
    }
    func closeDropDown() {
        if dropDownController != nil {
            dropDownController?.closeView()
            dropDownController = nil
        }
    }
    func closeAutoComplete() {
        if autoCompleteController != nil {
            autoCompleteController?.closeView()
            autoCompleteController = nil
        }
    }
    func cellTxtSearchDidClickNext(cell: CellTxtSearch) {
        let indexPath:NSIndexPath =  self.tableView.indexPathForCell(cell)!
        let model:RowModel = components.objectAtIndex(indexPath.row) as! RowModel
        model.colorNextbutton = UIColor.blackColor()
        self.addInfo()
        self.tableView.reloadData()
        
        
    }
    func generateDropDownAndParseDataWithCell(cell:CellDropDown) {
        dropDownController = UIStoryboard(name: "NZDropDown", bundle: nil).instantiateViewControllerWithIdentifier("NZDropDownViewController") as? NZDropDownViewController
        dropDownController?.labelReference = cell.rightLabel
        
        dropDownController!.rawObjects.addObject(DropDownModel(text: "1"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "2"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "3"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "4"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "5"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "6"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "7"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "8"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "9"))
        dropDownController!.rawObjects.addObject(DropDownModel(text: "10"))
        
        dropDownController!.displayObjects = dropDownController!.rawObjects.mutableCopy() as! NSMutableArray
        
        dropDownController?.updatePositionAtView(self.panelView)
        dropDownController!.delegate = self
        self.addChildViewController(dropDownController!)
        self.panelView.addSubview(dropDownController!.view)
        self.tableView.scrollEnabled = false
    }
    func generateAutoCompleteTextFieldAndParseDataWithCell(cell:CellTxtSearch) -> NZAutoCompleteViewController {
        
        
        autoCompleteController = UIStoryboard(name: "NZAutoComplete", bundle: nil).instantiateViewControllerWithIdentifier("NZAutoCompleteViewController") as? NZAutoCompleteViewController
        autoCompleteController?.textFieldReference = cell.textField
        
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "101"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "201"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "301"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "401"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "501"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "601"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "701"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "801"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "901"))
        autoCompleteController!.rawObjects.addObject(AutoCompleteModel(text: "111"))
        
        autoCompleteController!.displayObjects = autoCompleteController!.rawObjects.mutableCopy() as! NSMutableArray
        
        let indexPath:NSIndexPath = self.tableView.indexPathForCell(cell)!
        let rect:CGRect = tableView.rectForRowAtIndexPath(indexPath)
        autoCompleteController?.updatePositionAtView(self.panelView, positionRect: rect)
        autoCompleteController!.delegate = self
        self.addChildViewController(autoCompleteController!)
        self.panelView.addSubview(autoCompleteController!.view)
        self.tableView.scrollEnabled = false
        self.didMoveToParentViewController(autoCompleteController)
        
        return autoCompleteController!
    
    }
    
}
