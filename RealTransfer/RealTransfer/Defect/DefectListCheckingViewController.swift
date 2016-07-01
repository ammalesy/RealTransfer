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

class DefectListCheckingViewController: NZViewController,UITableViewDataSource,UITableViewDelegate,DefectCellViewDelegate,NZNavigationViewControllerDelegate {

    var passCount:Int = 0
    var allDefect:Int = 0
    var garanteeDefect:Int = 0
    
    @IBOutlet weak var alldefectBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var garanteeBtn: UIButton!
    
    var defectRoomRef:DefectRoom?
    var list:NSMutableArray = NSMutableArray()
    var displayList:NSMutableArray = NSMutableArray()
    var groupList:NSMutableArray = NSMutableArray()
    var dropDownList:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var passLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        alldefectBtn.assignCornerRadius(5)
        garanteeBtn.assignCornerRadius(5)
        
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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 114
        self.reloadData(defectRoomRef, type: "0")
        
        self.setNumberOfDefect()
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
        return resultArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let categoryName:String = groupList.objectAtIndex(indexPath.section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
        let index:Int = (resultArray.count - 1) - indexPath.row
        let defectModel:DefectModel = resultArray[index] as! DefectModel
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
                        let url:NSURL = NSURL(string: "http://\(DOMAIN_NAME)/images/\(PROJECT!.pj_datebase_name!)/\(self.defectRoomRef!.df_un_id!)/\(defectModel.df_image_path!).jpg")! //
                        cell.defectImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "p1"), completed: { (imageReturn, error, sdImageCacheType, url) in
                            if imageReturn != nil
                            {
                                defectModel.realImage = imageReturn
                                ImageCaching.sharedInstance.setImageByName(defectModel.df_image_path!, image: imageReturn!, isFromServer: true)
                                ImageCaching.sharedInstance.save()
                            }
                        })
                        //                cell.defectImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "p1"), options: SDWebImageOptions.RefreshCached)
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
        
        
        if defectModel.complete_status == "0" {
            cell.iconImgView.image = UIImage(named: "un_check_sync")
        }else{
            cell.iconImgView.image = UIImage(named: "checked_sync")
        }
        
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
            
            let line:UIView = UIView(frame: CGRectMake(10,15,bgLine.frame.size.width - 10,1))
            line.backgroundColor = UIColor.lightGrayColor()
            
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
            for defect:DefectModel in (((self.defectRoomRef?.listDefect)!  as NSArray) as! [DefectModel]) {
                
                if defect.df_type == "0" {
                    allDefect += 1
                }else{
                    garanteeDefect += 1
                }
                
                if  defect.complete_status == "1" {
                    passCount += 1
                }
            }
        }
        
        
        
        self.alldefectBtn.setTitle("Defect ทั้งหมด (\(allDefect))", forState: UIControlState.Normal)
        self.garanteeBtn.setTitle("Guarantee (\(garanteeDefect))", forState: UIControlState.Normal)
        self.passLb.text = "\(passCount) / \(self.defectRoomRef!.listDefect!.count)"
        
    }
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
    
    func defectCellCheckingButtonClicked(view: DefectCellChecking) {
        let indexPath:NSIndexPath = self.tableView.indexPathForCell(view)!
        let categoryName:String = groupList.objectAtIndex(indexPath.section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
        let index:Int = (resultArray.count - 1) - indexPath.row
        let defectModel:DefectModel = resultArray[index] as! DefectModel
        
        if defectModel.complete_status == "1" {
            defectModel.complete_status = "0"
        }else{
            defectModel.complete_status = "1"
        }
        
        self.defectRoomRef?.doCache()
        self.tableView.reloadData()
        
    }
    
    func nzNavigation(controller: NZNavigationViewController, didClickMenu popover: NZPopoverView, menu: NZRow) {
        
        if self.defectRoomRef != nil && menu.identifier == "sync" {
            
            let alert = UIAlertController(title: "ตัวเลือก", message:"การซิงค์", preferredStyle: UIAlertControllerStyle.Alert)
            let completedAction:UIAlertAction = UIAlertAction(title: "อัพเดทสถานะการตรวจรับทั้งหมด", style: UIAlertActionStyle.Default, handler: { (action) in
                Queue.serialQueue({
                    Queue.mainQueue({
                        self.sync()
                    })
                })
                
                Queue.serialQueue({
                    Queue.mainQueue({
                        
                        self.nzNavigationController?.popViewController({
                            popover.hide()
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
    
    func sync() {
        
        SwiftSpinner.show("Uploading ..", animated: true)
        let cache:DefectRoom = DefectRoom.getCache(self.defectRoomRef?.df_room_id)!
        cache.df_sync_status = "1"
        
        Sync.controllerReferer = self
        Sync.syncToServer(cache ,db_name: PROJECT?.pj_datebase_name!, timeStamp: NSDateFormatter.dateFormater().stringFromDate(NSDate()), defect: (cache.listDefect)!)
        { (result) in
            
            if result == "TRUE" {
                
                cache.getListDefectOnServer({
                    
                    cache.doCache()
                    self.defectRoomRef = cache
                    self.reloadData(self.defectRoomRef, type: "0")
                    
                    SwiftSpinner.hide()
                    
                })
                
            }else if result == "FALSE"{
                let alert = UIAlertController(title: "แจ้งเตือน", message: "รายการล่าสุดแล้ว", preferredStyle: UIAlertControllerStyle.Alert)
                let action:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) in
                    
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
                    let alert = UIAlertController(title: "แจ้งเตือน", message: "Image upload fail!", preferredStyle: UIAlertControllerStyle.Alert)
                    let action:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) in
                        
                        
                        
                    })
                    alert.addAction(action)
                    
                    self.presentViewController(alert, animated: true, completion: {
                        
                    })
                    
                })
                
                
            }
            
        }
        
    }
    
}
