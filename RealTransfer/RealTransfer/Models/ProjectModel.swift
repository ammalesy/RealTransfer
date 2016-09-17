//
//  ProjectModel.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftSpinner

class ProjectModel: NSObject, NSCoding {
    
//    static let kProjectCache = "PROJECT_CACHE_DATA"

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
    
    
//    class func getOnCache()->ProjectModel?{
//        
//        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        return NSKeyedUnarchiver.unarchiveObjectWithData(uDefault.objectForKey(ProjectModel.kProjectCache) as! NSData) as? ProjectModel;
//        
//    }
//    func doCache(){
//        let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
//        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        uDefault.setObject(data, forKey: ProjectModel.kProjectCache)
//        uDefault.synchronize()
//    }
    
    override init() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.assign_id  = aDecoder.decodeObjectForKey("assign_id") as? String
        self.assign_project_id  = aDecoder.decodeObjectForKey("assign_project_id") as? String
        self.assign_sts_active  = aDecoder.decodeObjectForKey("assign_sts_active") as? String
        self.assign_user_id  = aDecoder.decodeObjectForKey("assign_user_id") as? String
        self.pj_active  = aDecoder.decodeObjectForKey("pj_active") as? String
        self.pj_datebase_name  = aDecoder.decodeObjectForKey("pj_datebase_name") as? String
        self.pj_detail  = aDecoder.decodeObjectForKey("pj_detail") as? String
        self.pj_id  = aDecoder.decodeObjectForKey("pj_id") as? String
        self.pj_image  = aDecoder.decodeObjectForKey("pj_image") as? String
        self.pj_name  = aDecoder.decodeObjectForKey("pj_name") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let val = self.assign_id{
            aCoder.encodeObject(val, forKey: "assign_id")
        }
        if let val = self.assign_project_id{
            aCoder.encodeObject(val, forKey: "assign_project_id")
        }
        if let val = self.assign_sts_active{
            aCoder.encodeObject(val, forKey: "assign_sts_active")
        }
        if let val = self.assign_user_id{
            aCoder.encodeObject(val, forKey: "assign_user_id")
        }
        if let val = self.pj_active{
            aCoder.encodeObject(val, forKey: "pj_active")
        }
        if let val = self.pj_datebase_name{
            aCoder.encodeObject(val, forKey: "pj_datebase_name")
        }
        if let val = self.pj_detail{
            aCoder.encodeObject(val, forKey: "pj_detail")
        }
        if let val = self.pj_id{
            aCoder.encodeObject(val, forKey: "pj_id")
        }
        if let val = self.pj_image{
            aCoder.encodeObject(val, forKey: "pj_image")
        }
        if let val = self.pj_name{
            aCoder.encodeObject(val, forKey: "pj_name")
        }
    }
    
    
    func getProject(handler: (NSMutableArray?) -> Void, networkFail: () -> Void, froceToDetailIfCached: (ProjectModel!) -> Void){
        let returnList:NSMutableArray = NSMutableArray()
        SwiftSpinner.show("Retriving projects..", animated: true)
        
        
        NetworkDetection.manager.isConected { (isConected) in
            
            if isConected == false {
                
                let project = Session.shareInstance.projectSelected
                let isOnSession = Session.shareInstance.isOnSession()
                
                if project != nil && isOnSession == true {
                    froceToDetailIfCached(project)
                }else{
                    networkFail()
                    SwiftSpinner.hide()
                }

            }else{
                
                let user:User = User().getOnCache()!
                
                Alamofire.request(.GET, "\(PathUtil.sharedInstance.getApiPath())/User/getProject.php?user_id=\(user.user_id!)&ransom=\(NSString.randomStringWithLength(10))", parameters: [:])
                    .responseJSON { response in
                        
                        if let JSON:NSDictionary = response.result.value as? NSDictionary {
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
                                SwiftSpinner.hide()
                                handler(returnList)
                                
                            }else{
                                SwiftSpinner.hide()
                                handler(nil)
                                
                            }
                            
                        }else{
                            SwiftSpinner.hide()
                            handler(nil)
                            
                        }
                }
            
            }
            
        }
        
        
    }
    
}
