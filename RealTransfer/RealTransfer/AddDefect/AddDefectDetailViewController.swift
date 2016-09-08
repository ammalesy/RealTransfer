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
import SDWebImage
import KMPlaceholderTextView

let kOTHER_IDENTIFIER = "99999999"

public enum DefectViewState : Int {
    
    case New
    case Edit

}

class AddDefectDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NZDropDownViewDelegate {

    var textsForDisplayEditing:[String]?
    var state:DefectViewState?
    
    var image:UIImage?
    var imagePicker:UIImagePickerController?
    var splitController:NZSplitViewController?
    var dropDownController:NZDropDownViewController?
    var categoryList:NSDictionary?
    var defectRoom:DefectRoom?
    var defectModel:DefectModel?
    @IBOutlet weak var saveBtn: UIButton!
    
    var categorySelected:String?
    var subCategorySelected:String?
    var listSubCategorySelected:String?
    
    @IBOutlet weak var heightListSubType: NSLayoutConstraint!
    @IBOutlet weak var listSubtypeTextView: KMPlaceholderTextView!
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isModeGanrantee() {
            let controller:GaranteeListViewController =  self.getGuaranteeDefectListController()
            controller.needFullCellMode(false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddDefectDetailViewController.keyboardWasShown(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddDefectDetailViewController.keyboardWasHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        self.imageView.image = self.image!
        splitController = (self.splitViewController as! NZSplitViewController)
        
        self.listSubTypeModeEnable(false)
        
        categoryList = Category.sharedInstance.getCategory()
        
        self.initialData()
        self.verifyButtonColor()
        self.verifyButtonEnable()
        self.setTapEventOnContainer()
    }

    func initialData(){
        if self.state == DefectViewState.Edit {
            
            if self.defectModel != nil {
                self.categorySelected = self.defectModel?.categoryName!
                self.subCategorySelected = self.defectModel?.subCategoryName!
                self.listSubCategorySelected = self.defectModel?.listSubCategory!
                
                if (self.textsForDisplayEditing != nil) {
                    self.typeBtn.setTitle(self.textsForDisplayEditing![0], forState: UIControlState.Normal)
                    self.subtypeBtn.setTitle(self.textsForDisplayEditing![1], forState: UIControlState.Normal)
                    if self.subCategorySelected == kOTHER_IDENTIFIER {
                        
                        self.listSubTypeModeEnable(true)
                        self.listSubtypeTextView.text = self.textsForDisplayEditing![2]
                    }else{
                        
                        self.listSubTypeModeEnable(false)
                        self.listSubTypeBtn.setTitle(self.textsForDisplayEditing![2], forState: UIControlState.Normal)
                    }
                    
                }
            }
            self.verifyButtonColor()
            self.verifyButtonEnable()
        }
    }

    @IBAction func takePicture(sender: AnyObject) {
        self.openImagePickerViewByType(UIImagePickerControllerSourceType.Camera)
    }
    @IBAction func openGallery(sender: AnyObject) {
        self.openImagePickerViewByType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    func openImagePickerViewByType(type:UIImagePickerControllerSourceType!){
        
        if type == UIImagePickerControllerSourceType.PhotoLibrary {
            imagePicker = GalleryImagePickerController()
        }else{
            imagePicker = UIImagePickerController()
        }
        
        
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
        
        SDImageCache.sharedImageCache().clearMemory()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            CameraRoll.sharedInstance.saveImage(image)
            
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
        self.popViewController()
    }
    @IBAction func save(sender: AnyObject) {
        if self.subCategorySelected == kOTHER_IDENTIFIER
        {
            self.listSubCategorySelected = self.listSubtypeTextView.text
        }
        
        let timeStamp  =  NSDateFormatter.dateFormater().stringFromDate(NSDate())
        if self.state == DefectViewState.New {
            let defect:DefectModel = DefectModel()
            defect.categoryName = self.categorySelected
            defect.df_date = timeStamp
            defect.listSubCategory = self.listSubCategorySelected
            defect.df_id = "waiting"
            let imgName = UIImage.uniqNameBySeq("0")
            defect.df_image_path = imgName
            
            let image = UIImage(data: (UIImage(data: (self.imageView.image?.lowerQualityJPEGNSData)!)?.mediumQualityJPEGNSData)!)
            defect.realImage = UIImage.resizeImage(image!, newWidth: 60)
            ImageCaching.sharedInstance.setImageByName(imgName, image: image, isFromServer: false)
            SDImageCache.sharedImageCache().storeImage(image, forKey: Session.shareInstance.getImageCacheKey(imgName), toDisk: true)
            ImageCaching.sharedInstance.save()
            defect.df_room_id_ref = self.defectRoom?.df_room_id
            defect.df_status = "0"
            defect.subCategoryName = self.subCategorySelected
            
            if self.isModeGanrantee() {
                self.increaseGuaranteeValue()
                defect.df_type = "1"
                
            }else{
                defect.df_type = "0"
            }
            
            self.saveAndKeepToDisk(defect)
        }else{
            //EDIT
            
            
            
            self.defectModel!.categoryName = self.categorySelected
            self.defectModel!.subCategoryName = self.subCategorySelected
            self.defectModel!.df_date = timeStamp
            if self.defectModel!.subCategoryName == kOTHER_IDENTIFIER
            {
                self.defectModel!.listSubCategory = self.listSubtypeTextView.text
            }else{
                self.defectModel!.listSubCategory = self.listSubCategorySelected
            }
            
            let imgName = UIImage.uniqNameBySeq("0")
            self.defectModel!.df_image_path = imgName
            
            let image = UIImage(data: (UIImage(data: (self.imageView.image?.lowerQualityJPEGNSData)!)?.mediumQualityJPEGNSData)!)
            self.defectModel!.realImage = UIImage.resizeImage(image!, newWidth: 60)
            ImageCaching.sharedInstance.setImageByName(imgName, image: image, isFromServer: false)
            SDImageCache.sharedImageCache().storeImage(image, forKey: Session.shareInstance.getImageCacheKey(imgName), toDisk: true)
            ImageCaching.sharedInstance.save()
            
            if self.isModeGanrantee() {
                self.defectModel!.df_type = "1"
            }else{
                self.defectModel!.df_type = "0"
            }
            
            self.saveAndKeepToDisk(self.defectModel!)
            print(self.defectRoom?.listDefect)
        }
    }
    func saveAndKeepToDisk(defect:DefectModel!){
        
        
        if self.categorySelected != nil && self.subCategorySelected != nil && self.listSubCategorySelected != nil
        {
            
            if self.state == DefectViewState.New {
                let listDefect:NSMutableArray = (self.defectRoom?.listDefect)!
                listDefect.addObject(defect)
            }
            
            let roomID = self.defectRoom!.df_room_id!
            self.defectRoom?.doCache()
            self.defectRoom = DefectRoom.getCache(roomID)
            
            self.reloadDefectList()
            
            self.popViewController()
        }
    }
    
    func popViewController(){
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    func reloadDefectList()
    {
        let defectModel:DefectModel = self.defectRoom!.listDefect?.lastObject as! DefectModel
        var key:String! = defectModel.categoryName
        
        let arr:[UIViewController] = self.splitController!.viewControllers
        let defectListController = arr[0]
        
        if (defectListController as! DefectListViewController).className() == "DefectListViewController" {
            
            let controller:DefectListViewController = (defectListController as! DefectListViewController)
            if controller.isShowAll {
                key = "ALL"
            }
            Queue.mainQueue({ 
                controller.reloadData(self.defectRoom!)
                
                Queue.mainQueue({ 
                    controller.filterWithKey(key)
                })
            })
            
            
            
        }else if (defectListController as! DefectListViewController).className() == "GaranteeListViewController" {

            let controller:GaranteeListViewController = (defectListController as! GaranteeListViewController)
            if controller.isShowAll {
                key = "ALL"
            }
            Queue.mainQueue({ 
                controller.reloadData(self.defectRoom!, type: "1")
                Queue.mainQueue({ 
                    controller.filterWithKey(key)
                    self.getDefectListCheckingController().defectRoomRef = self.defectRoom
                    self.getDefectListCheckingController().setNumberOfDefect()
                })
            })
            
            
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
            self.clearSubCategoryValue()
            
        }
        else if contorller.identifier == "subType"
        {
            self.subtypeBtn.setTitle(model.text, forState: UIControlState.Normal)
            self.subCategorySelected = model.identifier
            
            self.clearListSubCategoryValue()
            
            if model.identifier == kOTHER_IDENTIFIER
            {
                self.listSubTypeModeEnable(true)
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
        self.verifyButtonEnable()
        self.closeDropDown()
    }
    func clearSubCategoryValue(){
        self.subtypeBtn.setTitle("", forState: UIControlState.Normal)
        self.subCategorySelected = nil
        self.clearListSubCategoryValue()
    }
    func clearListSubCategoryValue(){
        self.listSubTypeBtn.setTitle("", forState: UIControlState.Normal)
        self.listSubtypeTextView.text = ""
        self.listSubCategorySelected = nil
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
    func verifyButtonEnable() {
        if self.categorySelected == nil || self.subCategorySelected == nil || self.listSubCategorySelected == nil {
            if self.categorySelected != nil && self.subCategorySelected == kOTHER_IDENTIFIER {
                self.saveBtn.enabled = true
            }else{
                self.saveBtn.enabled = false
            }
        }else{
            self.saveBtn.enabled = true
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
    
    class func instance(image:UIImage!, defectRoom:DefectRoom!, state:DefectViewState!) -> AddDefectDetailViewController{
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailController:AddDefectDetailViewController = sb.instantiateViewControllerWithIdentifier("AddDefectDetailViewController") as! AddDefectDetailViewController
        detailController.image = image
        detailController.defectRoom = defectRoom
        detailController.state = state
        
        return detailController
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func isModeGanrantee() -> Bool{
        let defectListController = self.splitController!.viewControllers.first!
        
        if (defectListController as! DefectListViewController).className() == "GaranteeListViewController" {
            
            return true
        }
        
        return false
    }
    func getDefectListCheckingController()->DefectListCheckingViewController {
        let controllers:NSMutableArray = self.splitController!.nzNavigationController!.viewControllers
        return controllers[1] as! DefectListCheckingViewController
    }
    func getGuaranteeDefectListController()->GaranteeListViewController {
        let controllers:NSMutableArray = self.splitController!.nzNavigationController!.viewControllers
        let split:NZSplitViewController = controllers[2] as! NZSplitViewController
        
        
        return split.viewControllers.first as! GaranteeListViewController
    }
    func increaseGuaranteeValue(){
        self.getDefectListCheckingController().plusCountGuaranteeDefectValue()
        self.getGuaranteeDefectListController().plusCountGuaranteeDefectValue()
    }
    
    
//    override func shouldAutorotate() -> Bool {
//        return true
//    }
//    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.Portrait
//    }

}
