//
//  CSRoleModel.swift
//  RealTransfer
//
//  Created by Apple on 6/18/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class CSRoleModel: Model {
    
    static var csUSers:NSMutableArray = NSMutableArray() //<== GLOBAL VAR
    //DATA
    
    func getCSUsers(handler: (NSMutableArray?) -> Void, networkFail: () -> Void){
        
        if CSRoleModel.csUSers.count > 0
        {
            handler(CSRoleModel.csUSers)
        }
        else
        {
            
            NetworkDetection.manager.isConected({ (isConected) in
                
                if isConected == false {
                
                    networkFail()
                    
                }else{
                    
                    let returnList:NSMutableArray = NSMutableArray()
                    SwiftSpinner.show("Retriving CS..", animated: true)
                    
                    Alamofire.request(.GET, "\(PathUtil.sharedInstance.path)/User/getCSRole.php?ransom=\(NSString.randomStringWithLength(10))", parameters: [:])
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
                    
                }
                
            })
            
            
        }
    }

}
