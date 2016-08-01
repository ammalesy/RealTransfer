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
    
    class func syncToServer(defectRoom:DefectRoom!,
                            db_name:String!,
                            timeStamp:String! ,
                            defect:NSMutableArray!,
                            handler: (String!) -> Void)
    {
        
        NetworkDetection.manager.isConected { (isConedted) in
            
            if isConedted == false {
            
                handler("NETWORK_FAIL")
                
            }else{
                let images:NSMutableArray = NSMutableArray()
                let param:NSMutableArray = NSMutableArray()
                
                var i:Int = 0
                for sync:DefectModel in ((defect as NSArray) as! [DefectModel]) {
                    
                    if sync.df_status == "0" {
                        let imagePathName = UIImage.uniqNameBySeq(String(i))
                        if let img:UIImage = ImageCaching.sharedInstance.getImageByName(sync.df_image_path) {
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
                            if let image:UIImage = ImageCaching.sharedInstance.getImageByName(sync.df_image_path!) {
                                sync.realImage = image
                                images.addObject(ImageSync(image: sync.realImage!, imagePath: sync.df_image_path!))
                            }
                            
                        }
                    }
                }
                
                
                
                let path = "\(PathUtil.sharedInstance.path)/Defect/syncDefect.php?ransom=\(NSString.randomStringWithLength(10))"
                var needUpdateFlagOnly = "0"
                
                if param.count <= 0 && images.count == 0 && defectRoom.df_sync_status! == "0"{
                    handler("FALSE")
                    return;
                }else if param.count <= 0 && images.count == 0 && defectRoom.df_sync_status! == "1" {
                    needUpdateFlagOnly = "1"
                }
                
                
                let postParam = ["data":param,
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
                        
                        if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                            if JSON.objectForKey("status") as! String == "200" {
                                
                                defectRoom.df_check_date = timeStamp
                                
                                if images.count > 0 {
                                    
                                    self.uploadImages(images, defectRoom: defectRoom!, handler: { (flag) in
                                        handler(flag)
                                    })
                                    
                                }else{
                                    SwiftSpinner.hide()
                                    handler("TRUE")
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
    
    class func uploadImages(images:NSMutableArray, defectRoom:DefectRoom!, handler: (String!) -> Void){
        ////UPLOAD IMAGES
        Alamofire.upload(
            .POST,
            "\(PathUtil.sharedInstance.path)/Defect/uploadImage.php?ransom=\(NSString.randomStringWithLength(10))",
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
                        
                        if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                            if JSON.objectForKey("status") as! String == "200" {
                                SwiftSpinner.hide()
                                debugPrint(response)
                                
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
    
    /*
     Alamofire.request(.GET, "\(DOMAIN_NAME)/User/getCSRole.php", parameters: [:])
     .responseJSON { response in
     
     if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
     print("JSON: \(JSON)")
     if JSON.objectForKey("status") as! String == "200" {
     
     for user:NSDictionary in ((JSON.objectForKey("userList") as! NSArray) as! [NSDictionary]) {
     
     let userModel:User = User()
     userModel.user_id = user.objectForKey("user_id") as? String
     userModel.user_pers_fname = user.objectForKey("user_pers_fname") as? String
     userModel.user_pers_lname = user.objectForKey("user_pers_lname") as? String
     userModel.user_permission = user.objectForKey("user_permission") as? String
     
     
     returnList.addObject(userModel)
     }
     CSRoleModel.csUSers = returnList;
     handler(returnList)
     SwiftSpinner.hide()
     }else{
     handler(nil)
     SwiftSpinner.hide()
     }
     
     }else{
     handler(nil)
     SwiftSpinner.hide()
     }
     }
     */
    
}
