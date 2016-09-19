//
//  Session.swift
//  RealTransfer
//
//  Created by Apple on 9/2/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SDWebImage

class Session: Model,NSCoding {
    
    let kSessionCache = "SESSION_CACHE"
    static var shareInstance = Session()
    
    var projectSelected:ProjectModel? = nil
    var buildingSelected:Building? = nil
    var roomSelected:Room? = nil
    var defectRoomSelected:DefectRoom? = nil
    var customerInfo:CustomerInfo? = nil
    
    var beforeDefectList:Array<NSDictionary> = []
    
    override init() {
        
        super.init()
        self.refresh()
    }
    
    func getImageCacheKey(imageName:String!) -> String {
        
        let key = "\(PathUtil.sharedInstance.getApiPath())/images/\(PROJECT!.pj_datebase_name!)/\(self.defectRoomSelected!.df_un_id!)/\(imageName).jpg"

        return key
        
    }
    
    func isOnSession()->Bool{
        if projectSelected != nil &&
            buildingSelected != nil &&
            roomSelected != nil &&
            defectRoomSelected != nil &&
            customerInfo != nil
        {
            
            return true
        }
        return false;
    }
    
    func refresh() {
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let data = (userdefault.objectForKey(kSessionCache)){
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! Session
            self.buildingSelected = session.buildingSelected
            self.projectSelected = session.projectSelected
            self.roomSelected = session.roomSelected
            self.defectRoomSelected = session.defectRoomSelected
            self.customerInfo = session.customerInfo
        }
    }
    func doCache(){
        let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        uDefault.setObject(data, forKey: kSessionCache)
        //uDefault.synchronize()
    }

    
    required init(coder aDecoder: NSCoder) {
        self.projectSelected = aDecoder.decodeObjectForKey("projectSelected") as? ProjectModel
        self.buildingSelected  = aDecoder.decodeObjectForKey("buildingSelected") as? Building
        self.roomSelected  = aDecoder.decodeObjectForKey("roomSelected") as? Room
        self.defectRoomSelected = aDecoder.decodeObjectForKey("defectRoomSelected") as? DefectRoom
        self.customerInfo = aDecoder.decodeObjectForKey("customerInfo") as? CustomerInfo
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let val = self.buildingSelected{
            aCoder.encodeObject(val, forKey: "buildingSelected")
        }
        if let val = self.projectSelected{
            aCoder.encodeObject(val, forKey: "projectSelected")
        }
        if let val = self.roomSelected{
            aCoder.encodeObject(val, forKey: "roomSelected")
        }
        if let val = self.defectRoomSelected{
            aCoder.encodeObject(val, forKey: "defectRoomSelected")
        }
        if let val = self.customerInfo{
            aCoder.encodeObject(val, forKey: "customerInfo")
        }
    }
    func clear(){
        projectSelected = nil
        buildingSelected = nil
        roomSelected = nil
        defectRoomSelected = nil
        customerInfo = nil
        CameraRoll.sharedInstance.clear()
    }
    
    class func destroySession(type:String) {
        Session.shareInstance.clear()
        SDImageCache.sharedImageCache().clearMemory()
        
        let uDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        uDefault.removeObjectForKey(Session().kSessionCache)
        
        NetworkDetection.manager.isConected { (result) in
            if result == false {
                User.removeCache()
            }else{
                if type != "logout" {
                    ProjectViewController.postNotificationFetchProject()
                }
            }
        }
        
        
    }

}
