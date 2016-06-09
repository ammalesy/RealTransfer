//
//  AddDefectViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/9/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddDefectViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var splitController:NZSplitViewController?
    var imagePicker:UIImagePickerController?
    var imagePickerGallery:UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitController = (self.splitViewController as! NZSplitViewController)
        splitController!.nzNavigationController?.hideRightInfo(false)
        
        // Do any additional setup after loading the view.
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
                
                view.addTarget(self, action: Selector("tapImageGallery"), forControlEvents: UIControlEvents.TouchUpInside)
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
