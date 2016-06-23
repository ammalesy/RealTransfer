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
    
    class func syncToServer(defectRoom:DefectRoom!, db_name:String!, timeStamp:String! , defect:NSMutableArray!, handler: (String!) -> Void) {
        
        let images:NSMutableArray = NSMutableArray()
        let param:NSMutableArray = NSMutableArray()
        
        var i:Int = 0
        for sync:DefectModel in ((defect as NSArray) as! [DefectModel]) {
            if sync.df_status == "0" {
                let imagePathName = UIImage.uniqNameBySeq(String(i))
                if let img:UIImage = ImageCaching.sharedInstance.getImageByName(sync.df_image_path) {
                    sync.realImage = img
                    sync.df_image_path = imagePathName
                    images.addObject(ImageSync(image: sync.realImage!, imagePath: imagePathName))
                    ImageCaching.sharedInstance.setImageByName(imagePathName, image: sync.realImage!, isFromServer: false)
                    ImageCaching.sharedInstance.save()
                    param.addObject(sync.toJson())
                }
                i = i + 1
               
            }else{
                if ImageCaching.sharedInstance.isImageDidSyncServer(sync.df_image_path!) == false {
                    if let image:UIImage = ImageCaching.sharedInstance.getImageByName(sync.df_image_path!) {
                        sync.realImage = image
                        images.addObject(ImageSync(image: sync.realImage!, imagePath: sync.df_image_path!))
                    }
                    
                }
            }
        }
        if param.count <= 0 && images.count == 0{
            handler("FALSE")
            return;
        }
        
        let postParam = ["data":param,"db_name":db_name,"timestamp":timeStamp,"df_room_id":defectRoom.df_room_id!]
        
        
        Alamofire.request(.POST, "http://\(DOMAIN_NAME)/Service/Defect/syncDefect.php?ransom=\(NSString.randomStringWithLength(10))",
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
                        
                        ////UPLOAD IMAGES
                        Alamofire.upload(
                            .POST,
                            "http://\(DOMAIN_NAME)/Service/Defect/uploadImage.php?ransom=\(NSString.randomStringWithLength(10))",
                            headers: [
                                "db_name":PROJECT!.pj_datebase_name!,
                                "un_id":defectRoom.df_un_id!
                            ],
                            multipartFormData: { multipartFormData in
                                
                                for image:ImageSync in ((images as NSArray) as! [ImageSync]) {
                                    let imgData = image.image!.lowQualityJPEGNSData
                                    multipartFormData.appendBodyPart(data: imgData, name: "imagefiles[]",
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
    
    /*
     Alamofire.request(.GET, "http://\(DOMAIN_NAME)/Service/User/getCSRole.php", parameters: [:])
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
