//
//  AddDefectViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/9/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import MobileCoreServices
import SwiftSpinner

class AddDefectViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NZNavigationViewControllerDelegate {

    var splitController:NZSplitViewController?
    var imagePicker:UIImagePickerController?
    var imagePickerGallery:UIImagePickerController?
    var defectRoom:DefectRoom?
    var project:ProjectModel!
    
    var needShowGettingStart:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitController = (self.splitViewController as! NZSplitViewController)

        splitController!.nzNavigationController?.delegate = self
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        Queue.mainQueue { () -> Void in
            
            if self.needShowGettingStart {
                self.showGettingStartView()
            }
            
            
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func showGettingStartView(){
        let controller:GettingStartViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GettingStartViewController") as! GettingStartViewController
        controller.view.alpha = 0
        controller.project = self.project
        UIView.animateWithDuration(1, animations: { 
            controller.view.alpha = 1
            controller.view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            controller.view.frame = (self.splitController!.nzNavigationController?.view.frame)!
            controller.view.layoutIfNeeded()
            controller.nzNavigationController = self.splitController!.nzNavigationController
            controller.nzSplitViewController = self.splitController
            
            self.splitController!.nzNavigationController?.addChildViewController(controller)
            self.splitController!.nzNavigationController?.view.addSubview(controller.view)
            controller.didMoveToParentViewController(self.splitController!.nzNavigationController)
        }) { (result) in
                
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addAction(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                imagePicker = UIImagePickerController()
                
                imagePicker!.delegate = self
                imagePicker!.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker!.mediaTypes = [kUTTypeImage as NSString as String]
                imagePicker!.allowsEditing = false
                
                
                let view:UIButton = UIButton(frame: CGRectMake(
                    imagePicker!.view.frame.size.width - 80,
                    imagePicker!.view.frame.size.height - 150,50,50)
                )
                
                view.addTarget(self, action: #selector(AddDefectViewController.tapImageGallery), forControlEvents: UIControlEvents.TouchUpInside)
                view.setImage(UIImage(named: "p1"), forState: UIControlState.Normal)
                view.userInteractionEnabled = true
                imagePicker!.cameraOverlayView = view
                imagePicker!.cameraOverlayView?.userInteractionEnabled = true
                imagePicker?.showsCameraControls = true
                
                splitController?.nzNavigationController!.presentViewController(imagePicker!, animated: true,
                    completion: nil)
        }
        
    }
    func tapImageGallery(){
        
        if imagePicker != nil {
            imagePickerGallery = UIImagePickerController()
            
            imagePickerGallery!.delegate = self
            imagePickerGallery!.sourceType =
                UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerGallery!.mediaTypes = [kUTTypeImage as NSString as String]
            imagePickerGallery!.allowsEditing = false
        
                
                Queue.mainQueue({ () -> Void in
                    self.imagePicker!.presentViewController(self.imagePickerGallery!, animated: true, completion: { () -> Void in
                        
                    })
                })
        }
        
        
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            self.defectRoom = DefectRoom.getCache(self.defectRoom?.df_room_id!)
            let detailController:AddDefectDetailViewController = AddDefectDetailViewController.instance(image, defectRoom: self.defectRoom, state: DefectViewState.New)
            self.navigationController?.pushViewController(detailController, animated: true)
            
            
        }
        
        Queue.mainQueue { () -> Void in
            if self.imagePickerGallery != nil {
                self.imagePickerGallery?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
        }
        
        
        Queue.mainQueue { () -> Void in
            if self.imagePicker != nil {
                self.imagePicker?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
        }
        
    }
    func nzNavigation(controller: NZNavigationViewController, didClickMenu popover: NZPopoverView, menu: NZRow) {
        
        if self.defectRoom != nil && menu.identifier == "sync" {
            
            let alert = UIAlertController(title: "ตัวเลือก", message:"กรุณาเลือกประเภทการซิงค์", preferredStyle: UIAlertControllerStyle.Alert)
            let noneCompleteAction:UIAlertAction = UIAlertAction(title: "ยังคงเหลือการตรวจสอบ", style: UIAlertActionStyle.Default, handler: { (action) in
                
                self.sync(false)
                
            })
            let completedAction:UIAlertAction = UIAlertAction(title: "ตรวจสอบทั้งหมดแล้ว", style: UIAlertActionStyle.Default, handler: { (action) in
                Queue.serialQueue({
                    Queue.mainQueue({ 
                         self.sync(true)
                    })
                })
                
                Queue.serialQueue({
                    Queue.mainQueue({
                        
                        if self.isModeGanrantee() {
                            self.splitController?.nzNavigationController?.popViewControllerWithOutAnimate({
                                self.splitController?.nzNavigationController?.popViewController({
                                    
                                })
                            })
                        }else{
                            self.splitController?.nzNavigationController?.popViewController({
                                
                            })
                        }
                        
                    })
                })
                
            })
            let cancelAction:UIAlertAction = UIAlertAction(title: "ยกเลิก", style: UIAlertActionStyle.Cancel, handler: { (action) in
                
            })
            
            if isModeGanrantee() == false {
                alert.addAction(noneCompleteAction)
            }
            
            alert.addAction(completedAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: {
                
            })
            
            popover.hide()
            
        }
    }
    func sync(isFinally:Bool!) {
        
        SwiftSpinner.show("Uploading ..", animated: true)
        let cache:DefectRoom = DefectRoom.getCache(self.defectRoom?.df_room_id)!
        
        if isFinally == true {
            cache.df_sync_status = "1"
        }else{
            cache.df_sync_status = "0"
        }
        
        Sync.controllerReferer = self
        Sync.syncToServer(cache ,db_name: PROJECT?.pj_datebase_name!, timeStamp: NSDateFormatter.dateFormater().stringFromDate(NSDate()), defect: (cache.listDefect)!)
        { (result) in
            
            if result == "TRUE" {
                
                cache.getListDefectOnServer({ 
                    
                    cache.doCache()
                    self.defectRoom = cache
                    self.refresh()
                    
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
                    self.defectRoom = cache
                    self.refresh()
                    
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
    
    func refresh() {

        let defectListController = self.splitController!.viewControllers.first!
        
        if (defectListController as! DefectListViewController).className() == "DefectListViewController" {
            
            (defectListController as! DefectListViewController).reloadData(self.defectRoom!)
            
        }else if (defectListController as! DefectListViewController).className() == "GaranteeListViewController" {
            
            (defectListController as! GaranteeListViewController).reloadData(self.defectRoom!, type: "1")
        }
        
        let nav:UINavigationController = self.splitController?.viewControllers.last as! UINavigationController
        let addDefectViewController:AddDefectViewController = nav.viewControllers[0] as! AddDefectViewController
        addDefectViewController.defectRoom = self.defectRoom
    }
    
    
    func isModeGanrantee() -> Bool{
        let defectListController = self.splitController!.viewControllers.first!
        
        if (defectListController as! DefectListViewController).className() == "GaranteeListViewController" {
            
            return true
        }
        
        return false
    }

}
