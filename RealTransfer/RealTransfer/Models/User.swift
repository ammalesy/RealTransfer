//
//  User.swift
//  RealTransfer
//
//  Created by Apple on 6/16/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Foundation
import SwiftSpinner
import Alamofire

class User: Model,NSCoding {
    
    var pm_name:String?
    var user_id:String?
    var user_permission:String?
    var user_pers_fname:String?
    var user_pers_lname:String?
    var user_sts_active:String?
    var user_username:String?
    var user_work_position:String?
    var user_work_user_id:String?
    var username:String?
    var password:String?
    
    override init() {
 
    }
    required init(coder aDecoder: NSCoder) {
        self.pm_name  = aDecoder.decodeObjectForKey("pm_name") as? String
        self.user_id  = aDecoder.decodeObjectForKey("user_id") as? String
        self.user_permission  = aDecoder.decodeObjectForKey("user_permission") as? String
        self.user_pers_fname  = aDecoder.decodeObjectForKey("user_pers_fname") as? String
        self.user_pers_lname  = aDecoder.decodeObjectForKey("user_pers_lname") as? String
        self.user_sts_active  = aDecoder.decodeObjectForKey("user_sts_active") as? String
        self.user_username  = aDecoder.decodeObjectForKey("user_username") as? String
        self.user_work_position  = aDecoder.decodeObjectForKey("user_work_position") as? String
        self.user_work_user_id  = aDecoder.decodeObjectForKey("user_work_user_id") as? String
        self.username  = aDecoder.decodeObjectForKey("username") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let val = self.pm_name{
            aCoder.encodeObject(val, forKey: "pm_name")
        }
        if let val = self.user_id{
            aCoder.encodeObject(val, forKey: "user_id")
        }
        if let val = self.user_permission{
            aCoder.encodeObject(val, forKey: "user_permission")
        }
        if let val = self.user_pers_fname{
            aCoder.encodeObject(val, forKey: "user_pers_fname")
        }
        if let val = self.user_pers_lname{
            aCoder.encodeObject(val, forKey: "user_pers_lname")
        }
        if let val = self.user_sts_active{
            aCoder.encodeObject(val, forKey: "user_sts_active")
        }
        if let val = self.user_username{
            aCoder.encodeObject(val, forKey: "user_username")
        }
        if let val = self.user_work_position{
            aCoder.encodeObject(val, forKey: "user_work_position")
        }
        if let val = self.user_work_user_id{
            aCoder.encodeObject(val, forKey: "user_work_user_id")
        }
        if let val = self.username{
            aCoder.encodeObject(val, forKey: "username")
        }
    }
    
    func login(handler: (Bool?) -> Void, networkFail: () -> Void){
        
        
        NetworkDetection.manager.isConected { (isConected) in
            
            if isConected == false {
                let user = User().getOnCache()
                let isOnSession = Session.shareInstance.isOnSession()
                
                if user != nil && isOnSession == true {
                    handler(true)
                }else{
                    networkFail()
                }
                
                
            }else{
                SwiftSpinner.show("Waiting..")
                
                var path = "\(PathUtil.sharedInstance.getApiPath())/User/login.php?username=\(self.username!)&password=\(self.password!)"
                
                path = "\(path)&random=\(NSString.randomStringWithLength(10))"
                Alamofire.Manager.sharedInstance.request(.GET, path, parameters: [:])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
//                        let topController = UIViewController.topViewController()
//      
//                        AlertUtil.alert("", message: "\(response.response?.statusCode)", cancleButton: "OK", atController: topController, handler: { (action) in
//                            AlertUtil.alert("", message: "\(response.result.value)", cancleButton: "OK", atController: topController, handler: { (action) in
//                                AlertUtil.alert("", message: "\(response.request)", cancleButton: "OK", atController: topController, handler: { (action) in
//                                    AlertUtil.alert("", message: "\(response.response)", cancleButton: "OK", atController: topController, handler: { (action) in
//                                        AlertUtil.alert("", message: "\(response.data)", cancleButton: "OK", atController: topController, handler: { (action) in
//                                            AlertUtil.alert("", message: "\(response.result)", cancleButton: "OK", atController: topController, handler: { (action) in
//                                                
//                                            })
//                                        })
//                                    })
//                                })
//                            })
//                        })
//                        
//                        print("JSON: \(response.result.value)")
//                        
//                        
//                        
//                        
                        if let JSON:NSDictionary = response.result.value as? NSDictionary {
                            
                            
                            if JSON.objectForKey("status") as! String == "200" {
                                self.pm_name = JSON.objectForKey("pm_name") as? String
                                self.user_id = JSON.objectForKey("user_id") as? String
                                self.user_permission = JSON.objectForKey("user_permission") as? String
                                self.user_pers_fname = JSON.objectForKey("user_pers_fname") as? String
                                self.user_pers_lname = JSON.objectForKey("user_pers_lname") as? String
                                self.user_sts_active = JSON.objectForKey("user_sts_active") as? String
                                self.user_username = JSON.objectForKey("user_username") as? String
                                self.user_work_position = JSON.objectForKey("user_work_position") as? String
                                self.user_work_user_id = JSON.objectForKey("user_work_user_id") as? String
                                self.doCacheUSer()
                                
            
                                handler(true)
                                SwiftSpinner.hide()
                            }else{
                                
                                handler(false)
                                SwiftSpinner.hide()
                                debugPrint(response)
                            }
                            
                        }else{
//                            AlertUtil.alert("", message: "FALSE EXTERNAL", cancleButton: "OK", atController: UIViewController.topViewController())
                            handler(false)
                            SwiftSpinner.hide()
                            debugPrint(response)
                        }
                }
            }
            
        }
        
       
    }
    class func removeCache() {
        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        uDefault.removeObjectForKey("USER")
    }
    func getOnCache()->User?{
    
        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let data  = uDefault.objectForKey("USER") as? NSData {
            
            let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
            
            return user;
        }else{
            return nil
        }
    }
    func doCacheUSer(){
        let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        uDefault.setObject(data, forKey: "USER")
        uDefault.synchronize()
    }

}
