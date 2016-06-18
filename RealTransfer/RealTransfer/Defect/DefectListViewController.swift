//
//  DefectListViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

let CELL_DEFECT_IDENTIFIER = "CellDefect"

class DefectListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NZDropDownViewDelegate {
    
    @IBOutlet weak var countDefectLb: UILabel!
    var list:NSMutableArray = NSMutableArray()
    var displayList:NSMutableArray = NSMutableArray()
    var dropDownList:NSMutableArray = NSMutableArray()
    var groupList:NSMutableArray = NSMutableArray()
    
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
        dropDownList.addObject(DropDownModel(text: "1", iconColor: UIColor.redColor()))
        dropDownList.addObject(DropDownModel(text: "2", iconColor: UIColor.greenColor()))
        dropDownList.addObject(DropDownModel(text: "3", iconColor: UIColor.blueColor()))
        dropDownList.addObject(DropDownModel(text: "4", iconColor: UIColor.orangeColor()))
        
        
        list.addObject(DefectModel(categoryName: "1", subCategoryName: "11", listSubCategory: "111"))
        list.addObject(DefectModel(categoryName: "1", subCategoryName: "22", listSubCategory: "222"))
        list.addObject(DefectModel(categoryName: "2", subCategoryName: "33", listSubCategory: "333"))
        list.addObject(DefectModel(categoryName: "2", subCategoryName: "44", listSubCategory: "444"))
        list.addObject(DefectModel(categoryName: "2", subCategoryName: "55", listSubCategory: "555"))
        list.addObject(DefectModel(categoryName: "3", subCategoryName: "66", listSubCategory: "666"))
        list.addObject(DefectModel(categoryName: "3", subCategoryName: "77", listSubCategory: "777"))
        list.addObject(DefectModel(categoryName: "4", subCategoryName: "88", listSubCategory: "888"))
        list.addObject(DefectModel(categoryName: "4", subCategoryName: "99", listSubCategory: "999"))
        displayList = list.mutableCopy() as! NSMutableArray
        
        self.createGroupListDataByListData()
        
        self.countDefectLb.text = "Defect ทั้งหมด (\(list.count))"
        
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
            if model.text == categoryName {
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
            let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", model.text)
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
        
        
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.text)
        let resultArray:[AnyObject] = list.filteredArrayUsingPredicate(resultPredicate)
        return resultArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let categoryName:String = groupList.objectAtIndex(indexPath.section) as! String
        let dropDownModel:DropDownModel = self.getDropDownModelFromCategoryName(categoryName)!
        
        let resultPredicate:NSPredicate = NSPredicate(format: "categoryName contains[c] %@", dropDownModel.text)
        let resultArray:[AnyObject] = displayList.filteredArrayUsingPredicate(resultPredicate)
        let defectModel:DefectModel = resultArray[indexPath.row] as! DefectModel
        let cell:DefectCell = tableView.dequeueReusableCellWithIdentifier(CELL_DEFECT_IDENTIFIER) as! DefectCell
        
        cell.titleLb.text = defectModel.categoryName
        cell.middleTextLb.text = defectModel.subCategoryName
        cell.detailTextLb.text = defectModel.listSubCategory
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
    
}
