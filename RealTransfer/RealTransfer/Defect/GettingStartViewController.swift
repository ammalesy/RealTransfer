//
//  GettingStartViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

let CELL_LABEL_STATIC_IDENTIFIER = "CellLabelStatic"
let CELL_DROUP_DOWN_IDENTIFIER = "CellDropDown"
let CELL_TXT_SEARCH_IDENTIFIER = "CellTxtSearch"
let CELL_INFO_LABEL_IDENTIFIER = "CellInfoLabel"

class GettingStartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NZDropDownViewDelegate,CellTxtSearchDelegate,NZAutoCompleteViewDelegate,UITextFieldDelegate {
    
    
    //DATA
    var buldingSelected:Building?
    var csSelected:User?
    var roomSelected:Room?
    //////
    
    var project:ProjectModel! = nil
    
    var dropDownController:NZDropDownViewController?
    var autoCompleteController:NZAutoCompleteViewController?
    var nzNavigationController:NZNavigationViewController?
    var nzSplitViewController:NZSplitViewController?

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
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let row1:RowModel = RowModel()
        row1.head = "Project : "
        row1.detail = project.pj_name!
        row1.style = CELL_LABEL_STATIC_IDENTIFIER
        components.addObject(row1);
        
        let row2:RowModel = RowModel()
        row2.head = "Building : "
        row2.style = CELL_DROUP_DOWN_IDENTIFIER
        row2.identifier = "BUILDING_LIST"
        components.addObject(row2);
        
        let row3:RowModel = RowModel()
        row3.head = "Room : "
        row3.style = CELL_TXT_SEARCH_IDENTIFIER
        row3.colorNextbutton = UIColor.RGB(192, G: 193, B: 194)
        row3.identifier = "ROOM_LIST"
        components.addObject(row3);
        
        self.tableView.reloadData()
    }
    func queryInfo(handler: (NSMutableDictionary?) -> Void)
    {
        
        if self.roomSelected == nil || self.project == nil {
            let alert = UIAlertController(title: "Waring", message: "กรุณาเลือกข้อมูลให้ครบถ้วน", preferredStyle: UIAlertControllerStyle.Alert)
            let action:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
                
            })
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: {
                
            })
            handler(nil)
        }else{
            SwiftSpinner.show("Retriving data..", animated: true)
            
            Alamofire.request(.GET, "http://\(DOMAIN_NAME)/Service/Defect/getDefectRoomInfo.php?db_name=\(self.project!.pj_datebase_name!)&un_id=\(self.roomSelected!.un_id!)", parameters: [:])
                .responseJSON { response in
                    
                    if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                        print("JSON: \(JSON)")
                        
                        let status:String = JSON.objectForKey("status") as! String
                        
                        if status == "200" {
                            handler(JSON)
                            SwiftSpinner.hide()
                        }else{
                            handler(nil)
                            SwiftSpinner.hide()
                        }
                        
                    }else{
                        handler(nil)
                        SwiftSpinner.hide()
                    }
            }
            
            
        }
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
            cell.userInteractionEnabled = data.enable
            if data.enable == false {
                cell.dropDownImage.hidden = true
            }else{
                cell.dropDownImage.hidden = false
            }
            
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
        
        
        //Queue.mainQueue { () -> Void in
            let user:User = User().getOnCache()!
            
            var isCsNil:Bool = true
            if  self.csSelected == nil && (self.components.lastObject as! RowModel).enable == false {
                isCsNil = false
            }
            if self.csSelected != nil {
                isCsNil = false
            }
            
            if(self.roomSelected == nil || self.project == nil || isCsNil) {
                let alert = UIAlertController(title: "Warning", message: "กรุณากรอกข้อมูลให้ครบ", preferredStyle: UIAlertControllerStyle.Alert)
                let action:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
                    
                })
                alert.addAction(action)
                
                self.presentViewController(alert, animated: true, completion: {
                    
                })
            }else{
                
                let defectRoom:DefectRoom = DefectRoom(room: self.roomSelected, user: user, userCS: self.csSelected, project: self.project)
                defectRoom.checkDuplicate({ (defectRoomDup, isDuplicate) in
                    
                    if isDuplicate == false {
                        
                        defectRoom.add({ (resultFlag, message, status) in
                            
                            if resultFlag == true {
                                SwiftSpinner.hide()
                                self.hideView()
                            }else{
                                
                                let alert = UIAlertController(title: "Fail", message: "Error code:\(status!) \(message!)", preferredStyle: UIAlertControllerStyle.Alert)
                                let action:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
                                    
                                })
                                alert.addAction(action)
                                
                                self.presentViewController(alert, animated: true, completion: {
                                    SwiftSpinner.hide()
                                })
                            }
                            
                        })
                        
                    }else{
                        
                        //INITIALED & RELOAD DEFECT LIST
                        defectRoomDup?.getListDefect({ 
                            
                            let defectListController:DefectListViewController = self.nzSplitViewController?.viewControllers.first as! DefectListViewController
                            defectListController.reloadData(defectRoomDup)
                            
                            
                            let nav:UINavigationController = self.nzSplitViewController?.viewControllers.last as! UINavigationController
                            let addDefectViewController:AddDefectViewController = nav.viewControllers[0] as! AddDefectViewController
                            addDefectViewController.defectRoom = defectRoomDup
                            
                            SwiftSpinner.hide()
                            self.hideView()
                        })
                        
                    }
                    
                })
                
                
                
            }
       // }
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
            if data.identifier == "BUILDING_LIST"
            {
                Building(project: self.project).getBuildings({ (list) in
                    Queue.mainQueue({
                        let listDropDown:NSMutableArray = NSMutableArray()
                        for building:Building in ((list! as NSArray) as! [Building]) {
                            let dropDown:DropDownModel = DropDownModel(text: building.building_name)
                            dropDown.identifier = building.building_id!
                            dropDown.userInfo = building
                            listDropDown.addObject(dropDown)
                        }
                        self.generateDropDownAndParseDataWithCell(cell,dataList: listDropDown, rowModel: data)
                    })

                })
                
            }
            else if data.identifier == "CS_LIST"
            {
                CSRoleModel().getCSUsers({ (list) in
                    Queue.mainQueue({
                        let listDropDown:NSMutableArray = NSMutableArray()
                        for user:User in ((list! as NSArray) as! [User]) {
                            let dropDown:DropDownModel = DropDownModel(text: "\(user.user_pers_fname!) \(user.user_pers_lname!)")
                            dropDown.identifier = user.user_id!
                            dropDown.userInfo = user
                            listDropDown.addObject(dropDown)
                        }
                        self.generateDropDownAndParseDataWithCell(cell,dataList: listDropDown, rowModel: data)
                    })
                    
                })
            }
            
            
        }else if data.style == CELL_TXT_SEARCH_IDENTIFIER
        {
            if autoCompleteController != nil {
                return
            }
            let cell:CellTxtSearch = self.tableView.cellForRowAtIndexPath(indexPath) as! CellTxtSearch
            
            if data.identifier == "ROOM_LIST" && buldingSelected != nil
            {
                self.buldingSelected?.getRooms({ (listRoom) in
                    let listDropDown:NSMutableArray = NSMutableArray()
                    for room:Room in ((listRoom! as NSArray) as! [Room]) {
                        let autoComplete:AutoCompleteModel = AutoCompleteModel(text: room.un_name)
                        autoComplete.identifier = room.un_id!
                        autoComplete.userInfo = room
                        listDropDown.addObject(autoComplete)
                    }
                    Queue.mainQueue({
                        self.generateAutoCompleteTextFieldAndParseDataWithCell(cell, dataList: listDropDown, rowModel: data)
                    })
                    
                })
                
            }
            
        }
    }
    func cellTxtSearchBeginEditting(cell: CellTxtSearch, textField: UITextField) {
        let indexPath:NSIndexPath = self.tableView.indexPathForCell(cell)!
        let data:RowModel = components.objectAtIndex(indexPath.row) as! RowModel
        
        if autoCompleteController != nil {
            return
        }
        if data.identifier == "ROOM_LIST" && buldingSelected != nil
        {
            self.buldingSelected?.getRooms({ (listRoom) in
                let listDropDown:NSMutableArray = NSMutableArray()
                for room:Room in ((listRoom! as NSArray) as! [Room]) {
                    let autoComplete:AutoCompleteModel = AutoCompleteModel(text: room.un_name)
                    autoComplete.identifier = room.un_id!
                    autoComplete.userInfo = room
                    listDropDown.addObject(autoComplete)
                }
                Queue.mainQueue({
                    self.generateAutoCompleteTextFieldAndParseDataWithCell(cell, dataList: listDropDown, rowModel: data)
                })
                
            })
            
        }
    }
    func cellTxtSearchTextChange(string: String) {
        
        autoCompleteController?.searchWithString(string)
        
    }
    func nzDropDown(contorller: NZDropDownViewController, didClickCell model: DropDownModel) {
        if contorller.userInfo is RowModel {
            let rowModel:RowModel = contorller.userInfo as! RowModel
            rowModel.detail = model.text
        }
        
        if model.userInfo is Building
        {
            self.buldingSelected = model.userInfo as? Building
        }
        else if model.userInfo is User
        {
            self.csSelected = model.userInfo as? User
        }
        
        self.closeDropDown()
        
    }
    func nzAutoComplete(contorller: NZAutoCompleteViewController, didClickCell model: AutoCompleteModel) {
        
        if model.userInfo is Room
        {
            self.roomSelected = model.userInfo as? Room
        }

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
    func getRowInfoModel() -> RowInfoModel? {
        for model:AnyObject in self.components {
            if model is RowInfoModel {
                return model as? RowInfoModel
            }
        }
        return nil
    }
    func getRowByIdentifier(identifier:String!) -> RowModel? {
        for model:RowModel in ((self.components as NSArray) as! [RowModel]) {
            if model.identifier == identifier {
                return model
            }
        }
        return nil
    }
    func cellTxtSearchDidClickNext(cell: CellTxtSearch) {
        
        if self.roomSelected == nil || self.buldingSelected == nil {
            return
        }
        
        let indexPath:NSIndexPath =  self.tableView.indexPathForCell(cell)!
        let model:RowModel = components.objectAtIndex(indexPath.row) as! RowModel
        model.colorNextbutton = UIColor.blackColor()
        
        let row4:RowInfoModel = RowInfoModel()
        let row5:RowModel = RowModel()
        
        if self.components.count > 3 {
            self.components.removeLastObject()
            self.components.removeLastObject()
        }
        
        
        self.queryInfo { (list) in
            
            
            var defectInfo:NSMutableDictionary
            var roomInfo:NSMutableDictionary
            var qcCheckerInfo:NSMutableDictionary
            var csInfo:NSMutableDictionary
            
            let userInfo:NSDictionary = (list?.objectForKey("userInfo")!)! as! NSDictionary
            
            if ((list?.objectForKey("roomInfo") as? NSMutableDictionary) != nil) {
                roomInfo = (list?.objectForKey("roomInfo") as? NSMutableDictionary)!
                
                row4.headInfo4 = "Room Type : "
                row4.headInfo5 = "Unit Type : "
                row4.detailInfo4 = roomInfo.objectForKey("room_type_info") as? String
                row4.detailInfo5 = roomInfo.objectForKey("unit_type_name") as? String
                
            }
            
            if ((list?.objectForKey("defectInfo") as? NSMutableDictionary) != nil) {
                defectInfo = (list?.objectForKey("defectInfo") as? NSMutableDictionary)!
                row4.headInfo6 = "Check Date : "
                row4.headInfo7 = "Defect No : "
                row4.detailInfo6 = defectInfo.objectForKey("df_check_date") as? String
                row4.detailInfo7 = defectInfo.objectForKey("df_room_id") as? String
            }
            
            if ((list?.objectForKey("qcCheckerInfo") as? NSMutableDictionary) != nil) {
                qcCheckerInfo = (list?.objectForKey("qcCheckerInfo") as? NSMutableDictionary)!
                row4.headInfo8 = "QC Checker : "
                row4.detailInfo8 = "\(qcCheckerInfo.objectForKey("user_pers_fname") as! String) \(qcCheckerInfo.objectForKey("user_pers_lname") as! String)"
            }
            
            
            row4.style = CELL_INFO_LABEL_IDENTIFIER
            row4.headInfo1 = "Name : "
            row4.headInfo2 = "Email : "
            row4.headInfo3 = "Phone No.: "
            row4.detailInfo1 = userInfo.objectForKey("name") as? String
            row4.detailInfo2 = userInfo.objectForKey("email") as? String
            row4.detailInfo3 = userInfo.objectForKey("tel") as? String
            
            self.components.addObject(row4);
            
            
            if ((list?.objectForKey("csInfo") as? NSMutableDictionary) != nil) {
                csInfo = (list?.objectForKey("csInfo") as? NSMutableDictionary)!
                row5.detail = "\(csInfo.objectForKey("user_pers_fname") as! String) \(csInfo.objectForKey("user_pers_lname") as! String)"
                row5.enable = false
            }else{
                row5.detail = ""
            }
            
            row5.head = "CS : "
            row5.style = CELL_DROUP_DOWN_IDENTIFIER
            row5.identifier = "CS_LIST"
            self.components.addObject(row5);
            
            self.tableView.reloadData()
            self.csSelected = nil
            
        }
        
        
        
        
        
    }
    func generateDropDownAndParseDataWithCell(cell:CellDropDown, dataList:NSMutableArray!, rowModel:RowModel?) {
        
        dropDownController = UIStoryboard(name: "NZDropDown", bundle: nil).instantiateViewControllerWithIdentifier("NZDropDownViewController") as? NZDropDownViewController
        dropDownController?.labelReference = cell.rightLabel
        dropDownController?.identifier = rowModel?.identifier!
        dropDownController?.userInfo = rowModel
        for data:DropDownModel in ((dataList as NSArray) as! [DropDownModel])
        {
            dropDownController!.rawObjects.addObject(data)
        }
        
        dropDownController!.displayObjects = dropDownController!.rawObjects.mutableCopy() as! NSMutableArray
        dropDownController!.delegate = self
        dropDownController?.updatePositionAtView(self.panelView)
        self.addChildViewController(dropDownController!)
        self.panelView.addSubview(dropDownController!.view)
        self.tableView.scrollEnabled = false
        dropDownController?.tableView.reloadData()
    }
    func nzDropDownCustomYPositon(contorller: NZDropDownViewController) -> CGFloat {
        if contorller.identifier == "BUILDING_LIST"{
            return 180;
        }
        return NZ_DROPDOWN_NOT_NEED_CUSTOM_POSITION_Y
    }
    
    func generateAutoCompleteTextFieldAndParseDataWithCell(cell:CellTxtSearch, dataList:NSMutableArray!, rowModel:RowModel?) -> NZAutoCompleteViewController {
        
        
        autoCompleteController = UIStoryboard(name: "NZAutoComplete", bundle: nil).instantiateViewControllerWithIdentifier("NZAutoCompleteViewController") as? NZAutoCompleteViewController
        autoCompleteController?.textFieldReference = cell.textField
        autoCompleteController?.userInfo = rowModel
        for data:AutoCompleteModel in ((dataList as NSArray) as! [AutoCompleteModel])
        {
            autoCompleteController!.rawObjects.addObject(data)
        }
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
