//
//  AddDefectDetailViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/11/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddDefectDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NZDropDownViewDelegate {

    var image:UIImage?
    var imagePicker:UIImagePickerController?
    var splitController:NZSplitViewController?
    var dropDownController:NZDropDownViewController?
    
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
        list.addObject(DropDownModel(text: "1", iconColor: UIColor.redColor()))
        list.addObject(DropDownModel(text: "2", iconColor: UIColor.redColor()))
        list.addObject(DropDownModel(text: "3", iconColor: UIColor.redColor()))
        list.addObject(DropDownModel(text: "4", iconColor: UIColor.redColor()))
        list.addObject(DropDownModel(text: "5", iconColor: UIColor.redColor()))
        list.addObject(DropDownModel(text: "6", iconColor: UIColor.redColor()))
        list.addObject(DropDownModel(text: "7", iconColor: UIColor.redColor()))
        self.generateDropDownWithDataList(list, identifier: "type")
    }
    @IBAction func openSubTypeDropDown(sender: AnyObject) {
        
        let list:NSMutableArray = NSMutableArray()
        list.addObject(DropDownModel(text: "11"))
        list.addObject(DropDownModel(text: "22"))
        list.addObject(DropDownModel(text: "33"))
        list.addObject(DropDownModel(text: "44"))
        list.addObject(DropDownModel(text: "55"))
        list.addObject(DropDownModel(text: "66"))
        list.addObject(DropDownModel(text: "อื่นๆ"))
        self.generateDropDownWithDataList(list, identifier: "subType")
    }
    @IBAction func openListSubTypeDropDown(sender: AnyObject) {
        let list:NSMutableArray = NSMutableArray()
        list.addObject(DropDownModel(text: "111"))
        list.addObject(DropDownModel(text: "222"))
        list.addObject(DropDownModel(text: "333"))
        list.addObject(DropDownModel(text: "444"))
        list.addObject(DropDownModel(text: "555"))
        list.addObject(DropDownModel(text: "665"))
        self.generateDropDownWithDataList(list, identifier: "listSubType")
    }
    
    @IBAction func cancle(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func save(sender: AnyObject) {
        
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
        }
        else if contorller.identifier == "subType"
        {
            self.subtypeBtn.setTitle(model.text, forState: UIControlState.Normal)
            
            if model.text == "อื่นๆ" {
                self.listSubTypeModeEnable(true)
            }else{
                self.listSubTypeModeEnable(false)
            }
            
        }
        else if contorller.identifier == "listSubType"
        {
            self.listSubTypeBtn.setTitle(model.text, forState: UIControlState.Normal)
        }
        
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
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
