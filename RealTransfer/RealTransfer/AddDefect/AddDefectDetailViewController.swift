//
//  AddDefectDetailViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/11/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

let kOTHER_IDENTIFIER = "99999999"

class AddDefectDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NZDropDownViewDelegate {

    var image:UIImage?
    var imagePicker:UIImagePickerController?
    var splitController:NZSplitViewController?
    var dropDownController:NZDropDownViewController?
    var categoryList:NSDictionary?
    var defectRoom:DefectRoom?
    @IBOutlet weak var saveBtn: UIButton!
    
    var categorySelected:String?
    var subCategorySelected:String?
    var listSubCategorySelected:String?
    
    @IBOutlet weak var heightListSubType: NSLayoutConstraint!
    @IBOutlet weak var listSubtypeTextView: UITextView!
    @IBOutlet weak var listSubTypeBtn: UIButton!
    @IBOutlet weak var subtypeBtn: UIButton!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var listSubTypeCaptionLabel: UILabel!
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.heightListSubType.constant = 70
            self.listSubTypeCaptionLabel.updateConstraints()
            
            var rect:CGRect = self.view.frame
            let moreMinusPositionY = (self.view.frame.size.height) - (self.listSubtypeTextView.frame.origin.y) - (self.listSubtypeTextView.frame.size.height)
            rect.origin.y -= ((keyboardFrame.size.height+20) - moreMinusPositionY)
            self.view.frame = rect
            self.view.setNeedsDisplay()
        })
    }
    func keyboardWasHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.heightListSubType.constant = 50
            self.listSubTypeCaptionLabel.updateConstraints()
            
            var rect:CGRect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
            self.view.setNeedsDisplay()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddDefectDetailViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddDefectDetailViewController.keyboardWasHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        self.imageView.image = self.image!
        splitController = (self.splitViewController as! NZSplitViewController)
        splitController!.nzNavigationController?.hideRightInfo(false)
        self.listSubTypeModeEnable(false)
        
        categoryList = Category.getCategory()

    }

    @IBAction func takePicture(sender: AnyObject) {
        self.openImagePickerViewByType(UIImagePickerControllerSourceType.Camera)
    }
    @IBAction func openGallery(sender: AnyObject) {
        self.openImagePickerViewByType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    func openImagePickerViewByType(type:UIImagePickerControllerSourceType!){
        
        
        imagePicker = UIImagePickerController()
        
        imagePicker!.delegate = self
        imagePicker!.sourceType = type
        imagePicker!.mediaTypes = [kUTTypeImage as NSString as String]
        imagePicker!.allowsEditing = false
        
        
        splitController?.nzNavigationController!.presentViewController(imagePicker!, animated: true,
                                                                       completion: nil)
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            self.imageView.image = image
            
            self.imagePicker?.dismissViewControllerAnimated(true, completion: { 
                
            })
        }
    }
    @IBAction func openTypeDropDown(sender: AnyObject) {
        
        let list:NSMutableArray = NSMutableArray()
        
        for data:NSDictionary in categoryList!.objectForKey("list") as! [NSDictionary] {
            let red:String = (data.objectForKey("color") as! NSDictionary).objectForKey("R") as! String
            let green:String = (data.objectForKey("color") as! NSDictionary).objectForKey("G") as! String
            let blue:String = (data.objectForKey("color") as! NSDictionary).objectForKey("B") as! String
            let color:UIColor = UIColor.RGB(CGFloat((red as NSString).floatValue), G: CGFloat((green as NSString).floatValue), B: CGFloat((blue as NSString).floatValue))
            let identifier:String = data.objectForKey("id") as! String
            let dropDownModel = DropDownModel(text: data.objectForKey("title") as! String, iconColor: color, identifier:identifier)
            list.addObject(dropDownModel)
        }
        self.generateDropDownWithDataList(list, identifier: "type")
    }
    @IBAction func openSubTypeDropDown(sender: AnyObject) {
        
        if self.categorySelected == nil {
            return;
        }
        let list:NSMutableArray = NSMutableArray()
        let subCate:[NSDictionary] = Category.getSubCategoryBycategoryID(self.categorySelected, dataList: self.categoryList!)
        for data:NSDictionary in subCate {
            
            let identifier = data.objectForKey("id") as! String
            let text = data.objectForKey("title") as! String
            list.addObject(DropDownModel(text: text, identifier: identifier))
            
        }
        list.addObject(DropDownModel(text: "อื่นๆ",identifier: kOTHER_IDENTIFIER))
        self.generateDropDownWithDataList(list, identifier: "subType")
    }
    @IBAction func openListSubTypeDropDown(sender: AnyObject) {
        
        if self.categorySelected == nil || self.subCategorySelected == nil {
            return;
        }
        
        let list:NSMutableArray = NSMutableArray()
        let listSubCate:[NSDictionary] = Category.getListSubCategoryBySubCategoryID(self.subCategorySelected, dataList: self.categoryList!)
        for data:NSDictionary in listSubCate {
            
            let identifier = data.objectForKey("id") as! String
            let text = data.objectForKey("title") as! String
            list.addObject(DropDownModel(text: text, identifier: identifier))
            
        }
        self.generateDropDownWithDataList(list, identifier: "listSubType")
    }
    
    @IBAction func cancle(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func save(sender: AnyObject) {
        if self.subCategorySelected == kOTHER_IDENTIFIER
        {
            self.listSubCategorySelected = self.listSubtypeTextView.text
        }
        
         if self.categorySelected != nil && self.subCategorySelected != nil && self.listSubCategorySelected != nil
         {
            
            let listDefect:NSMutableArray = (self.defectRoom?.listDefect)!
            
            let defect:DefectModel = DefectModel()
            defect.categoryName = self.categorySelected
            defect.df_date = NSDateFormatter.dateFormater().stringFromDate(NSDate())
            defect.listSubCategory = self.listSubCategorySelected
            defect.df_id = "waiting"
            defect.df_image_path = "waiting"
            defect.realImage = self.imageView.image
            defect.df_room_id_ref = self.defectRoom?.df_room_id
            defect.df_status = "0"
            defect.subCategoryName = self.subCategorySelected
            listDefect.addObject(defect)
            
            self.defectRoom?.doCache()
            
            let defectListController:DefectListViewController = self.splitController!.viewControllers.first as! DefectListViewController
            defectListController.reloadData(self.defectRoom)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func generateDropDownWithDataList(list:NSMutableArray!, identifier:String!){
        
        if dropDownController == nil {
            dropDownController = UIStoryboard(name: "NZDropDown", bundle: nil).instantiateViewControllerWithIdentifier("NZDropDownViewController") as? NZDropDownViewController
            dropDownController!.delegate = self
            dropDownController?.identifier = identifier
            dropDownController?.disableSearch = true
            
            for model:DropDownModel in ((list as NSArray) as! [DropDownModel]) {
                dropDownController!.rawObjects.addObject(model)
            }
            
            dropDownController!.displayObjects = dropDownController!.rawObjects.mutableCopy() as! NSMutableArray
            dropDownController?.updatePositionAtView(self.view)
            
            self.addChildViewController(dropDownController!)
            self.view.addSubview(dropDownController!.view)
        }
        
        
    }
    func nzDropDownCustomPositon(contorller: NZDropDownViewController) -> CGRect {
        
        if contorller.identifier == "listSubType" {
            return CGRectZero
        }
        
        return CGRectMake(
              self.view.frame.size.width  - 330
            , (self.view.frame.size.height / 2) - (150 / 2)
            , 300
            , 300
        )
    }
    func dropDownViewDidClose(view: NZDropDownViewController) {
        
    }
    func nzDropDown(contorller: NZDropDownViewController, didClickCell model: DropDownModel) {
        
        if contorller.identifier == "type"
        {
            self.typeBtn.setTitle(model.text, forState: UIControlState.Normal)
            self.categorySelected = model.identifier
            self.subCategorySelected = nil
            self.listSubCategorySelected = nil
        }
        else if contorller.identifier == "subType"
        {
            self.subtypeBtn.setTitle(model.text, forState: UIControlState.Normal)
            self.subCategorySelected = model.identifier
            
            if model.identifier == kOTHER_IDENTIFIER
            {
                self.listSubTypeModeEnable(true)
                self.listSubCategorySelected = nil
            }
            else
            {
                self.listSubTypeModeEnable(false)
            }
            
        }
        else if contorller.identifier == "listSubType"
        {
            self.listSubTypeBtn.setTitle(model.text, forState: UIControlState.Normal)
            self.listSubCategorySelected = model.identifier
        }
        self.verifyButtonColor()
        self.closeDropDown()
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
    
    func listSubTypeModeEnable(flag:Bool) {
        
        if flag == true {
            self.listSubtypeTextView.hidden = false
            self.listSubTypeBtn.hidden = true
        }else{
            self.listSubtypeTextView.hidden = true
            self.listSubTypeBtn.hidden = false
        }
        
        
    }
    
    func verifyButtonColor() {
        if self.categorySelected != nil && self.subCategorySelected != nil
        {
            if self.listSubCategorySelected == nil && self.subCategorySelected == kOTHER_IDENTIFIER {
                self.saveBtn.setTitleColor(UIColor.RGB(127, G: 191, B: 49), forState: UIControlState.Normal)
            }else{
                if self.listSubCategorySelected != nil {
                    self.saveBtn.setTitleColor(UIColor.RGB(127, G: 191, B: 49), forState: UIControlState.Normal)
                }else{
                    self.saveBtn.setTitleColor(UIColor.RGB(199, G: 200, B: 201), forState: UIControlState.Normal)
                }
            }
        }
        else
        {
            self.saveBtn.setTitleColor(UIColor.RGB(199, G: 200, B: 201), forState: UIControlState.Normal)
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
