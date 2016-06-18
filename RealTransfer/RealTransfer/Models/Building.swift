//
//  Building.swift
//  RealTransfer
//
//  Created by Apple on 6/18/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class Building: Model {
    
    var image:UIImage?
    
    
    //DATA
    var assign_id:String?
    var assign_project_id:String?
    var assign_sts_active:String?
    var assign_user_id:String?
    var pj_active:String?
    var pj_datebase_name:String?
    var pj_detail:String?
    var pj_id:String?
    var pj_image:String?
    var pj_name:String?
    
    func getProject(handler: (NSMutableArray?) -> Void){
        let returnList:NSMutableArray = NSMutableArray()
        SwiftSpinner.show("Retriving projects..", animated: true)
        
        let user:User = User().getOnCache()!
        
        Alamofire.request(.GET, "http://127.0.0.1/Service/User/getProject.php?user_id=\(user.user_id!)", parameters: [:])
            .responseJSON { response in
                
                if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                    print("JSON: \(JSON)")
                    if JSON.objectForKey("status") as! String == "200" {
                        
                        for project:NSDictionary in ((JSON.objectForKey("projectList") as! NSArray) as! [NSDictionary]) {
                            let pj:ProjectModel = ProjectModel()
                            pj.assign_project_id = project.objectForKey("assign_project_id") as? String
                            pj.assign_sts_active = project.objectForKey("assign_sts_active") as? String
                            pj.assign_user_id = project.objectForKey("assign_user_id") as? String
                            pj.pj_active = project.objectForKey("pj_active") as? String
                            pj.pj_datebase_name = project.objectForKey("pj_datebase_name") as? String
                            pj.pj_detail = project.objectForKey("pj_detail") as? String
                            pj.pj_id = project.objectForKey("pj_id") as? String
                            pj.pj_image = project.objectForKey("pj_image") as? String
                            pj.pj_name = project.objectForKey("pj_name") as? String
                            

                            returnList.addObject(pj)
                        }
                        
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

}
