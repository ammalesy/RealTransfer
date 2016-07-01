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
import Foundation

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
        
        self.addGesture()
    }
    func addGesture() {
    
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GettingStartViewController.closeAllPopup))
        gesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gesture)
        
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
        row3.head = "Unit No. : "
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
            
            Alamofire.request(.GET, "http://\(DOMAIN_NAME)/Defect/getDefectRoomInfo.php?db_name=\(self.project!.pj_datebase_name!)&un_id=\(self.roomSelected!.un_id!)&ransom=\(NSString.randomStringWithLength(10))", parameters: [:])
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
            cell.textField.keyboardType = UIKeyboardType.NumberPad
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
                let customer:CustomerInfo = CustomerInfo.sharedInstance
                let buildingName = self.buldingSelected?.building_name!
                let csName = (self.components.lastObject as! RowModel).detail!
                let room = self.roomSelected?.un_name!
                customer.building = buildingName!
                customer.cs = csName
                customer.room = room!
                
                
                let defectRoom:DefectRoom = DefectRoom(room: self.roomSelected, user: user, userCS: self.csSelected, project: self.project)
                defectRoom.checkDuplicate({ (defectRoomDup, isDuplicate) in
                    
                    if isDuplicate == false {
                        
                        defectRoom.add({ (resultFlag, message, status) in
                            
                            if resultFlag == true {
                                //INITIALED & RELOAD DEFECT LIST
                                defectRoom.getListDefect({
                                    
                                    self.initialRoom(defectRoom)
                                    
                                    SwiftSpinner.hide()
                                    self.hideView()
                                    
                                    customer.canShow = true
                                })
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
                        
                        if defectRoomDup?.df_sync_status == "0" {
                            //INITIALED & RELOAD DEFECT LIST
                            defectRoomDup?.getListDefect({
                                
                                self.initialRoom(defectRoomDup)
                                
                                SwiftSpinner.hide()
                                self.hideView()
                                
                                customer.canShow = true
                            })

                        }else{
                            //INITIALED & RELOAD DEFECT LIST
                            defectRoomDup?.getListDefect({
                                
                                //FILTER GATANTEE ONLY
                                
                                SwiftSpinner.hide()
                                self.initialRoomCheckingPart2(defectRoomDup)
                                self.hideView()
                                customer.canShow = true
                            })
                            
                            
                        }
                        
                        
                    }
                    
                })
                
                
                
            }
       // }
    }
    func initialRoom(defectRoom:DefectRoom!){
        let defectListController:DefectListViewController = self.nzSplitViewController?.viewControllers.first as! DefectListViewController
        defectListController.reloadData(defectRoom)
        
        
        let nav:UINavigationController = self.nzSplitViewController?.viewControllers.last as! UINavigationController
        let addDefectViewController:AddDefectViewController = nav.viewControllers[0] as! AddDefectViewController
        addDefectViewController.defectRoom = defectRoom
    }
    func initialRoomCheckingPart2(defectRoom:DefectRoom!){
        
        let controller:DefectListCheckingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DefectListCheckingViewController") as! DefectListCheckingViewController
        controller.defectRoomRef = defectRoom
        
        
        let navPointer:NZNavigationViewController = self.nzNavigationController!
        
        self.nzNavigationController?.popViewControllerWithOutAnimate({
            
            navPointer.pushViewControllerWithOutAnimate(controller, completion: {
                
                
                
            })
            
        })
        
        
//        let garanteeListViewController:GaranteeListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GaranteeListViewController") as! GaranteeListViewController
//        garanteeListViewController.reloadData(defectRoom, type: "1")
//        
//        self.nzSplitViewController?.viewControllers[0] = garanteeListViewController
//        
//        let controllers:[UIViewController] = (self.nzSplitViewController?.viewControllers)!
//        
//        for controller in controllers {
//        
//            if controller is UINavigationController {
//                let nav:UINavigationController = controller as! UINavigationController
//                let addDefectViewController:AddDefectViewController = nav.viewControllers[0] as! AddDefectViewController
//                addDefectViewController.defectRoom = defectRoom
//            }
//        }
        
        
    }
    @IBAction func exitAction(sender: AnyObject) {
        
        self.hideView()
        self.nzSplitViewController?.nzNavigationController?.popViewController({ 
            
        })
        

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
        
        self.closeAllPopup()
        
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
                    
                    if list != nil {
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
                    }
                    
                    

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
    func getCellRoom() -> CellTxtSearch {
        
        let indexPAth:NSIndexPath = NSIndexPath(forRow: 2, inSection: 0)
        let cell:CellTxtSearch = self.tableView.cellForRowAtIndexPath(indexPAth) as! CellTxtSearch
        return cell
    }
    func nzDropDown(contorller: NZDropDownViewController, didClickCell model: DropDownModel) {
        if contorller.userInfo is RowModel {
            let rowModel:RowModel = contorller.userInfo as! RowModel
            rowModel.detail = model.text
        }
        
        if model.userInfo is Building
        {
            self.buldingSelected = model.userInfo as? Building
            self.roomSelected = nil
            let cell:CellTxtSearch = self.getCellRoom()
            cell.textField.text = ""
        }
        else if model.userInfo is User
        {
            self.csSelected = model.userInfo as? User
        }
        
        self.closeDropDown()
        self.verifyButtonColor()
        
    }
    func nzAutoComplete(contorller: NZAutoCompleteViewController, didClickCell model: AutoCompleteModel) {
        
        if model.userInfo is Room
        {
            self.roomSelected = model.userInfo as? Room
        }

        self.closeAutoComplete()
        self.verifyButtonColor()
        
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
    func closeAllPopup(){
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
            let customer:CustomerInfo = CustomerInfo.sharedInstance
            
            var defectInfo:NSMutableDictionary
            var roomInfo:NSMutableDictionary
            var qcCheckerInfo:NSMutableDictionary
            var csInfo:NSMutableDictionary
            
            let userInfo:NSDictionary = (list?.objectForKey("userInfo")!)! as! NSDictionary
            
            if ((list?.objectForKey("roomInfo") as? NSMutableDictionary) != nil) {
                roomInfo = (list?.objectForKey("roomInfo") as? NSMutableDictionary)!
                
                row4.headInfo4 = "Room Type : "
                row4.headInfo5 = "Unit Type : "
                
                let roomType = roomInfo.objectForKey("room_type_info") as? String
                let unitType = roomInfo.objectForKey("unit_type_name") as? String
                
                row4.detailInfo4 = roomType!
                row4.detailInfo5 = unitType!
                
                customer.roomType = roomType!
                customer.unitType = unitType!
                
            }
            
            if ((list?.objectForKey("defectInfo") as? NSMutableDictionary) != nil) {
                defectInfo = (list?.objectForKey("defectInfo") as? NSMutableDictionary)!
                row4.headInfo6 = "Check Date : "
                row4.headInfo7 = "Defect No : "
                if let date = defectInfo.objectForKey("df_check_date") as? String {
                    
                    let dateArr = date.componentsSeparatedByString("|")
                    let dateConcat = "\(dateArr[0]) \(dateArr[1])"
                    row4.detailInfo6 = dateConcat
                    
                    customer.checkDate = dateConcat
                }
                let defectNo = defectInfo.objectForKey("df_room_id") as? String
                row4.detailInfo7 = defectNo!
                customer.defectNo = defectNo!
                
            }
            
            if ((list?.objectForKey("qcCheckerInfo") as? NSMutableDictionary) != nil) {
                qcCheckerInfo = (list?.objectForKey("qcCheckerInfo") as? NSMutableDictionary)!
                let qcChecker = "\(qcCheckerInfo.objectForKey("user_pers_fname") as! String) \(qcCheckerInfo.objectForKey("user_pers_lname") as! String)"
                row4.headInfo8 = "QC Checker : "
                row4.detailInfo8 = qcChecker
                
                customer.qcChecker = qcChecker
            }
            
            row4.style = CELL_INFO_LABEL_IDENTIFIER
            row4.headInfo1 = "Name : "
            row4.headInfo2 = "Email : "
            row4.headInfo3 = "Phone No.: "//pers_prefix
            
            
            
            let prefix = userInfo.objectForKey("pers_prefix") as? String
            let fname = userInfo.objectForKey("pers_fname") as? String
            let lname = userInfo.objectForKey("pers_lname") as? String
            let qt_unit_number_id = userInfo.objectForKey("qt_unit_number_id") as? String
            let pers_sex = userInfo.objectForKey("pers_sex") as? String
            let pers_card_id = userInfo.objectForKey("pers_card_id") as? String
            let pers_mobile = userInfo.objectForKey("pers_mobile") as? String
            let pers_email = userInfo.objectForKey("pers_email") as? String
            var pers_tel = userInfo.objectForKey("pers_mobile") as? String
            if pers_tel == "N/A" {
                pers_tel = userInfo.objectForKey("pers_tel") as? String
            }
            
            customer.pers_prefix = prefix!
            customer.pers_fname = fname!
            customer.pers_lname = lname!
            customer.qt_unit_number_id = qt_unit_number_id!
            customer.pers_sex = pers_sex!
            customer.pers_card_id = pers_card_id!
            customer.pers_mobile = pers_mobile!
            customer.pers_email = pers_email!
            customer.pers_tel = pers_tel!
            
            var name = "N/A"
            if fname != "N/A" && lname != "N/A" {
                name = "\(prefix!)\(fname!) \(lname!)"
            }
            
            row4.detailInfo1 = name
            row4.detailInfo2 = pers_email!
            row4.detailInfo3 = pers_tel!
            
            self.nzNavigationController!.assignRightInfovalue(customer, roomNo: self.roomSelected!.un_name!)
            
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
            
            self.verifyButtonColor()
            
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
    
    func verifyButtonColor() {
        if self.buldingSelected != nil && self.roomSelected != nil
        {
            let cell:CellTxtSearch = self.getCellRoom()
            var row3Color = UIColor.RGB(127, G: 191, B: 49)
            var startColor = UIColor.RGB(216, G: 216, B: 216)
            self.startBtn.enabled = false
            
            if self.components.count > 3 {
                row3Color = UIColor.blackColor()
            }
            cell.nextBtn.setTitleColor(row3Color, forState: UIControlState.Normal)
            
            let rowModel:RowModel? = self.getRowByIdentifier("CS_LIST")
            if rowModel != nil && rowModel?.detail != "" {
                self.startBtn.enabled = true
                startColor = UIColor.RGB(127, G: 191, B: 49)
            }

            self.startBtn.setTitleColor(startColor, forState: UIControlState.Normal)
        }
    }
    
}
