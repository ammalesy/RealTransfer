//
//  DefectListViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SDWebImage

let CELL_DEFECT_IDENTIFIER = "CellDefect"

class DefectListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NZDropDownViewDelegate,DefectCellViewDelegate {
    
    @IBOutlet weak var countDefectLb: UILabel!
    var list:NSMutableArray = NSMutableArray()
    var displayList:NSMutableArray = NSMutableArray()
    var dropDownList:NSMutableArray = NSMutableArray()
    var groupList:NSMutableArray = NSMutableArray()
    
    var defectRoomRef:DefectRoom?
    
    
    var dropDownController:NZDropDownViewController?

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 114
        
        
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
        self.setNumberOfDefect()
    }
    func setNumberOfDefect(){
        self.countDefectLb.text = "Defect ทั้งหมด (\(list.count))"
    }
    
    func reloadData(defectRoom:DefectRoom!) {
        self.reloadData(defectRoom, type: "0");
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
    
    @IBAction func openDropDown(sender: AnyObject) {
        
        if dropDownController == nil {
            
            self.generateDropDownWithDataList(dropDownList, identifier: "filterType")
        }
        
        
        
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
    func nzDropDownHideSearchPanel(contorller: NZDropDownViewController) -> Bool {
        return true
    }
    func nzDropDownCustomPositon(contorller: NZDropDownViewController) -> CGRect {

        return CGRectMake(
            self.view.frame.size.width  - 270
            , self.filterButton.frame.origin.y + 10
            , 230
            , self.tableView.frame.size.height / 2
        )
    }
    func dropDownViewDidClose(view: NZDropDownViewController) {
        
    }
    func nzDropDown(contorller: NZDropDownViewController, didClickCell model: DropDownModel) {
        
        self.closeDropDown()
        displayList.removeAllObjects()
        
        if model.identifier == "ALL"
        {
        
            displayList = list.mutableCopy() as! NSMutableArray
        }else{
            let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", model.identifier)
            let resultArray:[AnyObject] = list.filteredArrayUsingPredicate(resultPredicate)
            
            for model in resultArray {
                displayList.addObject(model)
            }
        }
        
        
        
        self.createGroupListDataByListData()
        self.tableView.reloadData()
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.closeDropDown()
    }
    func closeDropDown() {
        if dropDownController != nil {
            dropDownController?.closeView()
            dropDownController = nil
        }
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let categoryName:String = groupList.objectAtIndex(indexPath.section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
        let index:Int = (resultArray.count - 1) - indexPath.row
        let defectModel:DefectModel = resultArray[index] as! DefectModel
        let cell:DefectCell = tableView.dequeueReusableCellWithIdentifier(CELL_DEFECT_IDENTIFIER) as! DefectCell
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
        
        if defectModel.df_status == "1" {
            cell.setHideEditting(true)
        }else{
            cell.setHideEditting(false)
        }
        
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
            cell.detailTextLb.text = defectModel.listSubCategory
        }else{
            cell.detailTextLb.text = defectModel.listSubCategory_displayText
        }
        cell.statusIconImageView.backgroundColor = dropDownModel.iconColor
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if dropDownController != nil {
            dropDownController?.closeView()
            dropDownController = nil
        }else{
        
            // SELECTION
        }
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
            
            let line:UIView = UIView(frame: CGRectMake(0,15,bgLine.frame.size.width,1))
            line.backgroundColor = UIColor.lightGrayColor()
            
            bgLine.addSubview(line)
            return bgLine
            
        }
        return nil
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func defectCellPopoverWillShow(cell: DefectCell) {
        self.tableView.scrollEnabled = false
    }
    func defectCellPopoverWillHide(cell: DefectCell) {
        self.tableView.scrollEnabled = true
    }
    
    func defectCell(cell: DefectCell, didClickMenu model: NZRow, popover: NZPopoverView) {
        
        let indexPath:NSIndexPath = self.tableView.indexPathForCell(cell)!
        let categoryName:String = groupList.objectAtIndex(indexPath.section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.identifier)
        let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
        let index:Int = (resultArray.count - 1) - indexPath.row
        let defectModel:DefectModel = resultArray[index] as! DefectModel
        
        if model.identifier == "delete" {
            ImageCaching.sharedInstance.removeImageByName(defectModel.df_image_path)
            self.defectRoomRef?.listDefect?.removeObject(defectModel)
            self.defectRoomRef?.doCache()
            self.reloadData(self.defectRoomRef!)
            
            let splitArr = self.splitViewController?.viewControllers
            let nav = splitArr![1] as! UINavigationController
            let navArr = nav.viewControllers
            let addController:AddDefectViewController = navArr[0] as! AddDefectViewController
            addController.defectRoom = DefectRoom.getCache(self.defectRoomRef!.df_room_id!)
            
        }else{
      
            let controllers:[UIViewController] = (self.splitViewController?.viewControllers)!
            let nav:UINavigationController = controllers[1] as! UINavigationController
            nav.popToRootViewControllerAnimated(true)
            
            let detailController:AddDefectDetailViewController = AddDefectDetailViewController.instance(cell.defectImageView.image!, defectRoom: self.defectRoomRef, state: DefectViewState.Edit)
            detailController.defectModel = defectModel
            detailController.textsForDisplayEditing = [cell.titleLb.text!,cell.middleTextLb.text!,cell.detailTextLb.text!]
            nav.pushViewController(detailController, animated: true)
        }
        
        
        
        cell.hideMenuPopoverIfViewIsShowing()
        
    }
    
}
