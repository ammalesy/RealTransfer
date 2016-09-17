//
//  Sync.swift
//  RealTransfer
//
//  Created by Apple on 6/19/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SDWebImage

class ImageSync : Model {
    var image:UIImage?
    var imagePath:String?
    
    convenience init(image:UIImage!, imagePath:String!) {
        self.init()
        self.image = image
        self.imagePath = imagePath
    }
}

class Sync: Model {

    static var controllerReferer:UIViewController?
    
    class func shouldKeepLog(defects:NSMutableArray!) -> Bool {
        
        for defect in ((defects as NSArray) as! [DefectModel]) {
            
            if defect.df_id == "waiting" {
                return true
            }
            
        }
        for defect in ((defects as NSArray) as! [DefectModel]) {
            
            for defectDict in Session.shareInstance.beforeDefectList {
                
                if (defectDict["df_id"] as! String) == defect.df_id {
                    
                    if defect.complete_status != (defectDict["before_complete_status"] as! String) {
                        return true
                    }
                    break;
                }
            }
        }
        
        return false
    }
    
    class func syncToServer(defectRoom:DefectRoom!,
                            db_name:String!,
                            timeStamp:String! ,
                            defect:NSMutableArray!,
                            handler: (String!) -> Void)
    {
        NetworkDetection.manager.isConected { (isConedted) in
            SDImageCache.sharedImageCache().clearMemory()
            if isConedted == false {
            
                handler("NETWORK_FAIL")
                
            }else{
                let images:NSMutableArray = NSMutableArray()
                let param:NSMutableArray = NSMutableArray()
                
                var i:Int = 0
                for sync:DefectModel in ((defect as NSArray) as! [DefectModel]) {
                    SDImageCache.sharedImageCache().clearMemory()
                    
                    if sync.df_status == "0" {
                        let imagePathName = UIImage.uniqNameBySeq(String(i))
                        if let img:UIImage = ImageCaching.sharedInstance.getImageByName(Session.shareInstance.getImageCacheKey(sync.df_image_path)) {// {
                            sync.realImage = img
                            sync.df_image_path = imagePathName
                            sync.complete_status = "0"
                            sync.mode = "INSERT"
                            images.addObject(ImageSync(image: sync.realImage!, imagePath: imagePathName))
                            ImageCaching.sharedInstance.setImageByName(imagePathName, image: sync.realImage!, isFromServer: false)
                            ImageCaching.sharedInstance.save()
                            param.addObject(sync.toJson())
                        }
                        i = i + 1
                        
                    } else{
                        
                        sync.mode = "UPDATE"
                        param.addObject(sync.toJson())
                        
                        if ImageCaching.sharedInstance.isImageDidSyncServer(sync.df_image_path!) == false {
                            if let image:UIImage = ImageCaching.sharedInstance.getImageByName(Session.shareInstance.getImageCacheKey(sync.df_image_path!)) {
                                sync.realImage = image
                                images.addObject(ImageSync(image: sync.realImage!, imagePath: sync.df_image_path!))
                            }
                            
                        }
                    }
                }
                
                
                
                let path = "\(PathUtil.sharedInstance.getApiPath())/Defect/syncDefect.php?ransom=\(NSString.randomStringWithLength(10))"
                var needUpdateFlagOnly = "0"
                
                if param.count <= 0 && images.count == 0 && defectRoom.df_sync_status! == "0"{
                    handler("FALSE")
                    return;
                }else if param.count <= 0 && images.count == 0 && defectRoom.df_sync_status! == "1" {
                    needUpdateFlagOnly = "1"
                }
                
                let qcChecker = User().getOnCache()!
                let postParam = ["data":param,
                    "df_user_id":qcChecker.user_id!,
                    "db_name":db_name,
                    "timestamp":timeStamp,
                    "df_room_id":defectRoom.df_room_id!,
                    "df_sync_status":defectRoom.df_sync_status!,
                    "needUpdateFlagOnly":needUpdateFlagOnly]
                
                Alamofire.request(.POST, path,
                    parameters: postParam,
                    encoding: ParameterEncoding.JSON)
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON:NSDictionary = response.result.value as? NSDictionary {
                            if JSON.objectForKey("status") as! String == "200" {
                                
                                defectRoom.df_check_date = timeStamp
                                
                                if images.count > 0 {
                                    SwiftSpinner.show("Please wait syncing..")
                                    self.uploadImages(images, defectRoom: defectRoom!, handler: { (flag) in
                                        if(flag == "TRUE"){
                                            
                                            if(self.shouldKeepLog(defect)){
                                                
                                                Sync.keepLog(postParam, completion: {
                                                    SwiftSpinner.hide()
                                                    handler(flag)
                                                })
                                                
                                            }else{
                                                SwiftSpinner.hide()
                                                handler(flag)
                                            }
                                            
                                           
                                        }else{
                                            SwiftSpinner.hide()
                                            handler(flag)
                                        }
                                    })
                                    
                                }else{
                                    SwiftSpinner.show("Please wait syncing..")
                                    if(self.shouldKeepLog(defect)){
                                        Sync.keepLog(postParam, completion: {
                                            handler("TRUE")
                                            SwiftSpinner.hide()
                                        })
                                    }else{
                                        handler("TRUE")
                                        SwiftSpinner.hide()
                                    }
                                    
                                }
                                
                            }else{
                                SwiftSpinner.hide()
                                handler("FALSE")
                            }
                        }else{
                            SwiftSpinner.hide()
                            handler("FALSE")
                        }
                        
                }
            }
            
        }
    }
    
    class func keepLog(postParam:[String: AnyObject]!, completion:()->Void){
        let path = "\(PathUtil.sharedInstance.getApiPath())/Defect/keepLog.php?ransom=\(NSString.randomStringWithLength(10))"
        Alamofire.request(.POST, path,
            parameters: postParam,
            encoding: ParameterEncoding.JSON)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                completion()
                
        }
    }
    class func uploadImages(images:NSMutableArray, defectRoom:DefectRoom!, handler: (String!) -> Void){
        ////UPLOAD IMAGES
        
//        SwiftSpinner.hide()
//        handler("UPLOAD_IMAGE_FAIL")
//
//        return;
        
        Alamofire.upload(
            .POST,
            "\(PathUtil.sharedInstance.getApiPath())/Defect/uploadImage.php?ransom=\(NSString.randomStringWithLength(10))",
            headers: [
                "db_name":PROJECT!.pj_datebase_name!,
                "un_id":defectRoom.df_un_id!
            ],
            multipartFormData: { multipartFormData in
                
                let keyName = "imagefiles[]"
                
                for image:ImageSync in ((images as NSArray) as! [ImageSync]) {
                    let imgData = image.image!.lowQualityJPEGNSData
                    multipartFormData.appendBodyPart(data: imgData, name: keyName,
                        fileName: image.imagePath!, mimeType: "image/jpg")
                    
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        if let JSON:NSDictionary = response.result.value as? NSDictionary {
                            if JSON.objectForKey("status") as! String == "200" {
                                SwiftSpinner.hide()
//                                debugPrint(response)
                                
                                //DID SYNC FLAG
                                for image:ImageSync in ((images as NSArray) as! [ImageSync]) {
                                    
                                    ImageCaching.sharedInstance.setDidImageSyncByName(image.imagePath!)
                                    
                                }
                                //////
                                handler("TRUE")
                            }else{
                                SwiftSpinner.hide()
                                handler("UPLOAD_IMAGE_FAIL")
                            }
                        }else{
                            SwiftSpinner.hide()
                            handler("UPLOAD_IMAGE_FAIL")
                        }
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                    SwiftSpinner.hide()
                    handler("UPLOAD_IMAGE_FAIL")
                }
            }
        )
        /////////////////
    }
    
}
