//
//  DefectListCheckingViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/28/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire

class DefectListCheckingViewController: NZViewController,UITableViewDataSource,UITableViewDelegate,DefectCellViewDelegate,NZNavigationViewControllerDelegate,NZDropDownViewDelegate {

    var passCount:Int = 0
    var allDefect:Int = 0
    var garanteeDefect:Int = 0
    var filterSelected:String?
    var filterTypeSelected:String?
    
    @IBOutlet weak var alldefectBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var garanteeBtn: UIButton!
    @IBOutlet weak var filterTypeBtn: UIButton!
    
     var dropDownController:NZDropDownViewController?
    
    var defectRoomRef:DefectRoom?
    var list:NSMutableArray = NSMutableArray()
    var displayList:NSMutableArray = NSMutableArray()
    var groupList:NSMutableArray = NSMutableArray()
    var dropDownList:NSMutableArray = NSMutableArray()
    
    var dropDownListFilterChecking:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var passLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(DefectListViewController.tableViewTouch))
        tap.cancelsTouchesInView = false
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tap)
        
        alldefectBtn.assignCornerRadius(5)
        garanteeBtn.assignCornerRadius(5)
        filterTypeBtn.assignCornerRadius(5)
        
        self.initialDropDownList()
        self.initialDropDownCheckingList()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 114
        self.reloadData(defectRoomRef, type: "0")

        alldefectBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        alldefectBtn.titleLabel?.numberOfLines = 2
        filterTypeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        filterTypeBtn.titleLabel?.numberOfLines = 2

        self.filterSelected = "ALL"
        self.filterTypeSelected = "ALL"
        self.setNumberOfDefect()
        
        self.setTapEventOnContainer()
    }
    func initialDropDownList(){
        let firstModel:DropDownModel = DropDownModel(text: "เลือกดูทั้งหมด")
        firstModel.identifier = "ALL"
        dropDownList.addObject(firstModel)
        
        let categoryList:NSDictionary = Category.sharedInstance.getCategory()
        
        for data:NSDictionary in categoryList.objectForKey("list") as! [NSDictionary] {
            
            let red:String = (data.objectForKey("color") as! NSDictionary).objectForKey("R") as! String
            let green:String = (data.objectForKey("color") as! NSDictionary).objectForKey("G") as! String
            let blue:String = (data.objectForKey("color") as! NSDictionary).objectForKey("B") as! String
            let color:UIColor = UIColor.RGB(CGFloat((red as NSString).floatValue), G: CGFloat((green as NSString).floatValue), B: CGFloat((blue as NSString).floatValue))
            
            let dropDownModel = DropDownModel(text: data.objectForKey("title") as! String, iconColor: color)
            dropDownModel.identifier = data.objectForKey("id") as! String
            dropDownList.addObject(dropDownModel)
        }
    }
    func initialDropDownCheckingList(){
        self.dropDownListFilterChecking.addObject(DropDownModel(text: "เลือกดูทั้งหมด", identifier: "ALL"))
        self.dropDownListFilterChecking.addObject(DropDownModel(text: "รายการตรวจสอบเรียบร้อย", identifier: "1"))
        self.dropDownListFilterChecking.addObject(DropDownModel(text: "รายการที่รอตรวจสอบ", identifier: "0"))
    }
    override func stateConfigData() {
        self.nzNavigationController?.delegate = self
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    func reloadData(defectRoom:DefectRoom!, type:String!) {
        Queue.mainQueue {
            
            self.defectRoomRef = defectRoom
            
            self.list.removeAllObjects()
            for model:DefectModel in ((defectRoom.listDefect! as NSArray) as! [DefectModel]) {
                
                if model.df_type == type {
                    model.needDisplayText()
                    self.list.addObject(model)
                }
            }
            self.displayList = self.list.mutableCopy() as! NSMutableArray
            self.createGroupListDataByListData()
            self.tableView.reloadData()
            
            self.setNumberOfDefect()
        }
    }
    func createGroupListDataByListData() {
        groupList.removeAllObjects()
        for model:DefectModel in ((displayList as NSArray) as! [DefectModel]) {
            if groupList.containsObject(model.categoryName) == false {
                groupList.addObject(model.categoryName)
            }
        }
    }
    func getDropDownModelFromCategoryName(categoryName:String!)->DropDownModel? {
        
        for model:DropDownModel in ((dropDownList as NSArray) as! [DropDownModel]) {
            if model.identifier == categoryName {
                return model
            }
        }
        return nil
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return groupList.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let categoryName:String = groupList.objectAtIndex(section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        
        
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        let resultArray:[AnyObject] = list.filteredArrayUsingPredicate(resultPredicate)
        
        if self.filterTypeSelected != "ALL" {
            let mutable:NSMutableArray = NSMutableArray(array: resultArray)
            let resultPredicate:NSPredicate = NSPredicate(format: "complete_status contains[c] %@", self.filterTypeSelected!)
            let resultArray:[AnyObject] = mutable.filteredArrayUsingPredicate(resultPredicate)
            return resultArray.count
        }
        
        return resultArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var defectModel:DefectModel!
        
        let categoryName:String!
        let dropDownModel:DropDownModel!
        categoryName = groupList.objectAtIndex(indexPath.section) as! String
        dropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
        let index:Int = (resultArray.count - 1) - indexPath.row
        defectModel = resultArray[index] as! DefectModel

        
        
        let cell:DefectCellChecking = tableView.dequeueReusableCellWithIdentifier(CELL_DEFECT_IDENTIFIER) as! DefectCellChecking
        cell.delegate = self
        ///*===== IMAGE =======*//
        print(defectModel.df_image_path)
        cell.defectImageView.image = UIImage(named: "p1")
        if defectModel.realImage != nil {
            cell.defectImageView.image = defectModel.realImage
        }else{
            Queue.globalQueue({
                let imageOnCache = ImageCaching.sharedInstance.getImageByName(defectModel.df_image_path)
                
                Queue.mainQueue({
                    
                    if imageOnCache != nil {
                        cell.defectImageView.image = imageOnCache!
                        defectModel.realImage = imageOnCache!
                    }else{
                        let url:NSURL = NSURL(string: "\(PathUtil.sharedInstance.getApiPath())/images/\(PROJECT!.pj_datebase_name!)/\(self.defectRoomRef!.df_un_id!)/\(defectModel.df_image_path!).jpg")!

                        cell.defectImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "p1"), options: .AllowInvalidSSLCertificates, completed: { (imageReturn, error, sdImageCacheType, url) in
                            
                            if imageReturn != nil
                            {
                                defectModel.realImage = imageReturn
                                ImageCaching.sharedInstance.setImageByName(defectModel.df_image_path!, image: imageReturn!, isFromServer: true)
                                ImageCaching.sharedInstance.save()
                            }
                            
                        })
                    }
                    
                })
            })
        }
        //////////////////////////
        
        if defectModel.categoryName_displayText == nil {
            cell.titleLb.text = defectModel.categoryName
        }else{
            cell.titleLb.text = defectModel.categoryName_displayText
        }
        
        if defectModel.subCategoryName_displayText == nil {
            if defectModel.subCategoryName == kOTHER_IDENTIFIER {
                cell.middleTextLb.text = "อื่นๆ"
            }else{
                cell.middleTextLb.text = defectModel.subCategoryName
            }
            
        }else{
            cell.middleTextLb.text = defectModel.subCategoryName_displayText
        }
        
        if defectModel.listSubCategory_displayText == nil {
            cell.detailRightLb.text = defectModel.listSubCategory
        }else{
            cell.detailRightLb.text = defectModel.listSubCategory_displayText
        }
        cell.statusIconImageView.backgroundColor = dropDownModel.iconColor
        
        
//        if defectModel.complete_status == "0" {
//            cell.switching.setOn(false, animated: false)
//            cell.titleCheckDate.text = "รอการ   ตรวจสอบ"
//            cell.switching.userInteractionEnabled = true
//        }else{
//            cell.switching.setOn(true, animated: false)
//            let arrayDate:[String] = (defectModel.df_date! as NSString).componentsSeparatedByString("|")
//            cell.titleCheckDate.text = "ตรวจเมื่อ \(arrayDate[0])"
//            
//            if defectModel.canEdit == "0"  {
//                cell.switching.userInteractionEnabled = false
//            }else if defectModel.canEdit == "1" {
//                cell.switching.userInteractionEnabled = true
//            }
//        }
        
        if defectModel.complete_status == "0" {
            cell.nzSwitch.setOn(false, text: "รอการตรวจสอบ")
            cell.nzSwitch.userInteractionEnabled = true
        }else{
            
            let arrayDate:[String] = (defectModel.df_date! as NSString).componentsSeparatedByString("|")
            
            if defectModel.canEdit == "0"  {
                cell.nzSwitch.setOn(true, text: "ตรวจเมื่อ \(arrayDate[0])")
                cell.nzSwitch.userInteractionEnabled = false
            }else if defectModel.canEdit == "1" {
                cell.nzSwitch.userInteractionEnabled = true
                cell.nzSwitch.setOn(true, text: "เรียบร้อย")
            }
        }

        
        
        
        cell.defectRef = defectModel
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section >= 1 {
            return 30
        }
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section >= 1 {
            
            let bgLine:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,30))
            bgLine.backgroundColor = UIColor.whiteColor()
            
            let line:UIView = UIView(frame: CGRectMake(10,15,bgLine.frame.size.width - 10,0.7))
            line.backgroundColor = UIColor.RGB(219, G: 219, B: 219)
            
            bgLine.addSubview(line)
            return bgLine
            
        }
        return nil
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setNumberOfDefect() {
        allDefect = 0
        garanteeDefect = 0
        passCount = 0
        
        if self.defectRoomRef != nil {
            
            var theList:NSMutableArray = (self.defectRoomRef?.listDefect)!
            if self.filterTypeSelected != "ALL" {
                theList = displayList
            }
            
            for defect:DefectModel in (((theList)  as NSArray) as! [DefectModel]) {
                
                if defect.df_type == "0" {
                    allDefect += 1
                    if  defect.complete_status == "1" {
                        passCount += 1
                    }
                }else{
                    garanteeDefect += 1
                }
                
                
            }
        }
        
        
        
        self.alldefectBtn.setTitle("Defect ทั้งหมด (\(allDefect))", forState: UIControlState.Normal)
        self.garanteeBtn.setTitle("Guarantee (\(garanteeDefect))", forState: UIControlState.Normal)
        self.passLb.text = "\(passCount) / \(allDefect)"
        
    }
    func setNumberCheckingOnList(list:NSMutableArray){
        var allDefect = 0
        var passCount = 0
        for defect:DefectModel in ((list  as NSArray) as! [DefectModel]) {
            
            if defect.df_type == "0" {
                allDefect += 1
                if  defect.complete_status == "1" {
                    passCount += 1
                }
            }
        }
        
        if self.filterTypeSelected == "0" {
            self.passLb.text = "0 / \(allDefect)"
        }else{
            self.passLb.text = "\(passCount) / \(allDefect)"
        }
        
    }
    func setNumberOfDefect(number:Int){
        self.alldefectBtn.setTitle("Defect ทั้งหมด (\(number))", forState: UIControlState.Normal)
    }
    func setNumberOfDefect(number:Int, title:String!){
         self.alldefectBtn.setTitle("\(title) (\(number))", forState: UIControlState.Normal)
    }
    @IBAction func garanteeAction(sender: AnyObject) {
        
        let split:NZSplitViewController = NZSplitViewController.sharedInstance()
        let controllers:[UIViewController] = split.viewControllers;
        let nav:UINavigationController = controllers[1] as! UINavigationController
        let subsNav:[UIViewController] = nav.viewControllers
        if subsNav[0] is AddDefectViewController {
            let addDefectViewController:AddDefectViewController = subsNav[0] as! AddDefectViewController
            addDefectViewController.project = PROJECT
            addDefectViewController.needShowGettingStart = false

        }
        let max = (UIScreen.mainScreen().bounds.size.width * 85) / 100;
        split.minimumPrimaryColumnWidth = max
        split.maximumPrimaryColumnWidth = max
        self.nzNavigationController?.pushViewControllerWithOutAnimate(split, completion: { () -> Void in
            
            
                    let garanteeListViewController:GaranteeListViewController = GaranteeListViewController.sharedInstance()
                    garanteeListViewController.fullCellMode = true
                    garanteeListViewController.reloadData(self.defectRoomRef!, type: "1")
                    garanteeListViewController.allDefect = self.allDefect
                    garanteeListViewController.garanteeDefect = self.garanteeDefect
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

    func defectCellCheckingButtonClicked(view: DefectCellChecking, isOn on: Bool) {
        
        
        
        let defectModel:DefectModel!
        var resultArray:[AnyObject]?
        let indexPath:NSIndexPath = self.tableView.indexPathForCell(view)!
        
        let categoryName:String = groupList.objectAtIndex(indexPath.section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        resultArray = displayList.filteredArrayUsingPredicate(resultPredicate)
        let index:Int = (resultArray!.count - 1) - indexPath.row
        defectModel = resultArray![index] as! DefectModel
        
        
        if (on == true && defectModel.complete_status == "1") {
            return
        }
        if (on == false && defectModel.complete_status == "0") {
            return
        }
        
        if on == true {
            defectModel.complete_status = "1"
            defectModel.df_date = NSDateFormatter.dateFormater().stringFromDate(NSDate())
        }else{
            defectModel.complete_status = "0"
        }
        
//        if defectModel.complete_status == "1" {
//            defectModel.complete_status = "0"
//        }else{
//            defectModel.complete_status = "1"
//            defectModel.df_date = NSDateFormatter.dateFormater().stringFromDate(NSDate())
//        }
        
        
        self.defectRoomRef?.doCache()
        self.tableView.reloadData()
        
        if self.filterTypeSelected != "ALL" {
            let resultPredicate:NSPredicate = NSPredicate(format: "complete_status contains[c] %@", self.filterTypeSelected!)
            let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
            displayList.removeAllObjects()
            for model in resultArray {
                displayList.addObject(model)
            }
        }
        self.setNumberCheckingOnList(displayList)
        self.updateTitleFilterButton(resultArray)
        
    }
    func updateTitleFilterButton(resultArray:[AnyObject]?) {
        if self.filterSelected == "ALL" {
            self.setNumberOfDefect()
        }else{
            self.setNumberOfDefect(resultArray!.count, title: Category.convertCategoryNameToString(self.filterSelected!))
        }
        
    }
    func nzNavigation(controller: NZNavigationViewController, didClickMenu popover: NZPopoverView, menu: NZRow) {
        
        if self.defectRoomRef != nil && menu.identifier == "sync" {
            
            let alert = UIAlertController(title: "ตัวเลือก", message:"การซิงค์", preferredStyle: UIAlertControllerStyle.Alert)
            let completedAction:UIAlertAction = UIAlertAction(title: "อัพเดทสถานะการตรวจรับทั้งหมด", style: UIAlertActionStyle.Default, handler: { (action) in
                Queue.serialQueue({
                    Queue.mainQueue({
                        self.sync({ 
                            Queue.serialQueue({
                                Queue.mainQueue({
                                    
                                    self.nzNavigationController?.popViewController({
                                        popover.hide()
                                        self.nzNavigationController?.hideRightInfo(true)
                                    })
                                    
                                })
                            })

                        })
                    })
                })
                
                
            })
            let cancelAction:UIAlertAction = UIAlertAction(title: "ยกเลิก", style: UIAlertActionStyle.Cancel, handler: { (action) in
                
            })
            alert.addAction(completedAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
        }
        
        
    }
    
    func sync(completion: (() -> Void)?) {
        
        SwiftSpinner.show("Uploading ..", animated: true)
        let cache:DefectRoom = DefectRoom.getCache(self.defectRoomRef?.df_room_id)!
        cache.df_sync_status = "1"
        
        Sync.controllerReferer = self
        Sync.syncToServer(cache ,db_name: PROJECT?.pj_datebase_name!, timeStamp: NSDateFormatter.dateFormater().stringFromDate(NSDate()), defect: (cache.listDefect)!)
        { (result) in
            
            if  result == "NETWORK_FAIL" {
                SwiftSpinner.hide()
                AlertUtil.alertNetworkFail(self)
                
            }else if result == "TRUE" {
                
                cache.getListDefectOnServer({ 
                    
                    cache.doCache()
                    self.defectRoomRef = cache
                    self.reloadData(self.defectRoomRef, type: "0")
                    
                    SwiftSpinner.hide()
                    
                    let alert = UIAlertController(title: "บันทึกสำเร็จ", message:nil, preferredStyle: UIAlertControllerStyle.Alert)
                    let completedAction:UIAlertAction = UIAlertAction(title: "ตกลง", style: UIAlertActionStyle.Default, handler: { (action) in
                        
                        if (completion != nil) {
                            completion!()
                        }
                    })
                    alert.addAction(completedAction)
                    self.presentViewController(alert, animated: true, completion: {
                        
                    })
                    
                }, networkFail: { 
                    AlertUtil.alertNetworkFail(self)
                })
                
            }else if result == "FALSE"{
                let alert = UIAlertController(title: "แจ้งเตือน", message: "ซิงค์กับเซริฟเวอร์เรียบร้อยแล้ว", preferredStyle: UIAlertControllerStyle.Alert)
                let action:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) in
                    if (completion != nil) {
                        completion!()
                    }

                })
                alert.addAction(action)
                
                self.presentViewController(alert, animated: true, completion: {
                    SwiftSpinner.hide()
                })
            }else {
                
                cache.getListDefectOnServer({
                    
                    cache.doCache()
                    self.defectRoomRef = cache
                    self.reloadData(self.defectRoomRef, type: "0")
                    
                    SwiftSpinner.hide()
                    let alert = UIAlertController(title: "บันทึกข้อมูลไม่สำเร็จ", message: "กรุณากดบันทึกอีกครั้งหนึ่งและตรวจสอบการเชื่อมต่ออินเทอร์เน็ต", preferredStyle: UIAlertControllerStyle.Alert)
                    let action:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) in
                        
                        if (completion != nil) {
                            completion!()
                        }
                        
                        
                    })
                    alert.addAction(action)
                    
                    self.presentViewController(alert, animated: true, completion: {
                        
                    })
                    
                }, networkFail: { 
                    AlertUtil.alertNetworkFail(self)
                })
                
                
            }
            
        }
        
    }
    func defectCell(cell: DefectCell, didClickImage image: UIImage) {
        let color = cell.statusIconImageView.backgroundColor
        let category = cell.titleLb.text
        let subCategory = cell.middleTextLb.text
        
        var detail = ""
        if cell.isKindOfClass(DefectCellChecking) {
             detail = (cell as! DefectCellChecking).detailRightLb.text!
        }else{
             detail = cell.detailTextLb.text!
        }
        
        
        let model:ImageViewerModel = ImageViewerModel(iconColor:color!,
                                                      category:category,
                                                      subCategory: subCategory,
                                                      detail: detail)
        self.nzNavigationController!.showImageViwer(image, model: model)
        
    }
    func touchBeganCell(cell: DefectCell) {
        
    }
    func plusCountGuaranteeDefectValue() {
        garanteeDefect += 1
        self.setGuaranteeCount(garanteeDefect)
    }
    func setGuaranteeCount(number:Int){
        self.garanteeBtn.setTitle("Guarantee (\(number))", forState: UIControlState.Normal)
    }
    @IBAction func allDefectAction(sender: AnyObject) {
        if dropDownController == nil {
            
            self.generateDropDownWithDataList(dropDownList, identifier: "filterType")
        }
    }
    func nzDropDownViewdidAppear(contorller: NZDropDownViewController) {
        
        let sizeTable = contorller.tableView.contentSize
        var rect = contorller.view.frame
        var newHeight = sizeTable.height
        if newHeight > self.view.frame.size.height {
            newHeight = self.view.frame.size.height
        }
        
        rect.size.height = newHeight
        contorller.view.frame = rect
        contorller.view.setNeedsDisplay()
        
    }
    func generateDropDownWithDataList(list:NSMutableArray!, identifier:String!){
        dropDownController = UIStoryboard(name: "NZDropDown", bundle: nil).instantiateViewControllerWithIdentifier("NZDropDownViewController") as? NZDropDownViewController
        dropDownController!.delegate = self
        dropDownController?.identifier = identifier
        
        for model:DropDownModel in ((list as NSArray) as! [DropDownModel]) {
            dropDownController!.rawObjects.addObject(model)
        }
        
        dropDownController!.displayObjects = dropDownController!.rawObjects.mutableCopy() as! NSMutableArray
        dropDownController?.updatePositionAtView(self.view)
        
        self.addChildViewController(dropDownController!)
        self.view.addSubview(dropDownController!.view)
    }
    
    /////DELEGATE
    func nzDropDownHideSearchPanel(contorller: NZDropDownViewController) -> Bool {
        return true
    }
    func nzDropDownCustomPositon(contorller: NZDropDownViewController) -> CGRect {
        
        if contorller.identifier == "filterTypeChecking" {
            return CGRectMake(
                self.filterTypeBtn.frame.origin.x + 20
                , self.filterTypeBtn.frame.origin.y + 10
                , 200
                , (self.tableView.frame.size.height / 2)+50
            )
        }else{
            return CGRectMake(
                self.alldefectBtn.frame.origin.x + 20
                , self.alldefectBtn.frame.origin.y + 10
                , 340
                , (self.tableView.frame.size.height / 2)+50
            )
        }
        
        
    }
    func nzDropDown(contorller: NZDropDownViewController, shouldDisplayCell model: DropDownModel) -> Bool {
        
        if contorller.identifier == "filterType" {
            let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", model.identifier)
            let resultArray:[AnyObject] = list.filteredArrayUsingPredicate(resultPredicate)
            
            if resultArray.count == 0 && model.identifier != "ALL" {
                return false
            }
        }
        return true
        
    }
    func dropDownViewDidClose(view: NZDropDownViewController) {
        
    }
    func nzDropDown(contorller: NZDropDownViewController, didClickCell model: DropDownModel) {
        self.closeDropDown()
        if contorller.identifier == "filterType" {
            self.filterSelected = model.identifier
        }else{
            self.filterTypeSelected = model.identifier
            self.filterTypeBtn.setTitle(model.text, forState: UIControlState.Normal)
        }
        self.filterWithKey(self.filterSelected)
        
    }
    
    func filterWithKey(key:String!){
        displayList.removeAllObjects()
        
        if key == "ALL"
        {
            
            displayList = list.mutableCopy() as! NSMutableArray
            
            if self.filterTypeSelected != "ALL" {
                let resultPredicate:NSPredicate = NSPredicate(format: "complete_status contains[c] %@", self.filterTypeSelected!)
                let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
                displayList.removeAllObjects()
                for model in resultArray {
                    displayList.addObject(model)
                }
            
            }
            
            self.setNumberOfDefect(displayList.count)
            self.setNumberCheckingOnList(displayList);
        }else{
           
            let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", key)
            let resultArray:[AnyObject] = list.filteredArrayUsingPredicate(resultPredicate)
            for model in resultArray {
                displayList.addObject(model)
            }
            
            if self.filterTypeSelected != "ALL" {
                let resultPredicate:NSPredicate = NSPredicate(format: "complete_status contains[c] %@", self.filterTypeSelected!)
                let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
                displayList.removeAllObjects()
                for model in resultArray {
                    displayList.addObject(model)
                }
                
            }
            
            
            self.setNumberOfDefect(displayList.count, title: Category.convertCategoryNameToString(key!))
            self.setNumberCheckingOnList(displayList);
        }
        self.createGroupListDataByListData()
        self.tableView.reloadData()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.closeDropDown()
    }
    func tableViewTouch(){
        self.closeDropDown()
        
        self.nzNavigationController?.hideMenuPopoverIfViewIsShowing()
    }
    func closeDropDown() {
        if dropDownController != nil {
            dropDownController?.closeView()
            dropDownController = nil
        }
        
    }
    
    @IBAction func filterTypeAction(sender: AnyObject) {
        if dropDownController == nil {
            
            self.generateDropDownWithDataList(dropDownListFilterChecking, identifier: "filterTypeChecking")
        }
    }
    
}
