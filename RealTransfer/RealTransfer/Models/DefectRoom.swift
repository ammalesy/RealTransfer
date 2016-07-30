//
//  DefectRoom.swift
//  RealTransfer
//
//  Created by Apple on 6/18/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

let kLIST_DEFECT_ROOM = "ListDefectRoom"

class DefectRoom: Model,NSCoding {
    
    var df_room_id:String?
    var df_un_id:String?
    var df_check_date:String?
    var df_user_id:String?
    var df_no:String?
    var df_user_id_cs:String?
    var df_sync_status:String?
    
    var listDefect:NSMutableArray?
    
    //REF
    var room:Room?
    var user:User?
    var userCS:User?
    var project:ProjectModel?
    
    class func getCache(df_room_id:String!) -> DefectRoom? {
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let listData = (userDefault.objectForKey(kLIST_DEFECT_ROOM) as? NSData)
        if listData == nil {
            return nil
        }
        let array = NSKeyedUnarchiver.unarchiveObjectWithData(listData!) as! NSMutableArray
        for model:DefectRoom in ((array as NSArray) as! [DefectRoom]) {
            if model.df_room_id == df_room_id {
                return model
            }
        }
        
        return nil
    }
    func isHaveGuaranteeObjectNeverSync() -> Bool {
        for defect:DefectModel in ((self.listDefect! as NSArray) as! [DefectModel]) {
           
            if defect.df_type == "1" && defect.df_status == "0" {
                return true
            }
            
        }
        return false
    }
    func doCache() {
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let listData = (userDefault.objectForKey(kLIST_DEFECT_ROOM) as? NSData)
        if listData == nil {
            let array:NSMutableArray = NSMutableArray()
            array.addObject(self)
            userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(array), forKey: kLIST_DEFECT_ROOM)
            userDefault.synchronize()
        }else{
            var addNew:Bool = true
            let array = NSKeyedUnarchiver.unarchiveObjectWithData(listData!) as! NSMutableArray
            for model:DefectRoom in ((array as NSArray) as! [DefectRoom]) {
                if model.df_room_id == self.df_room_id {
                    array.removeObject(model)
                    array.addObject(self)
                    addNew = false
                    break;
                }
            }
            if addNew {
                array.addObject(self)
            }
            
            
            userDefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(array), forKey: kLIST_DEFECT_ROOM)
            userDefault.synchronize()
        }
        
        
    }
    
    override init() {
        listDefect = NSMutableArray()
    }
    required init(coder aDecoder: NSCoder) {
        self.df_room_id  = aDecoder.decodeObjectForKey("df_room_id") as? String
        self.df_un_id  = aDecoder.decodeObjectForKey("df_un_id") as? String
        self.df_check_date  = aDecoder.decodeObjectForKey("df_check_date") as? String
        self.df_user_id  = aDecoder.decodeObjectForKey("df_user_id") as? String
        self.df_user_id_cs  = aDecoder.decodeObjectForKey("df_user_id_cs") as? String
        self.df_no  = aDecoder.decodeObjectForKey("df_no") as? String
        self.df_sync_status  = aDecoder.decodeObjectForKey("df_sync_status") as? String
        self.listDefect  = (aDecoder.decodeObjectForKey("listDefect") as? NSMutableArray)!
  
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let val = self.df_room_id{
            aCoder.encodeObject(val, forKey: "df_room_id")
        }
        if let val = self.df_un_id{
            aCoder.encodeObject(val, forKey: "df_un_id")
        }
        if let val = self.df_check_date{
            aCoder.encodeObject(val, forKey: "df_check_date")
        }
        if let val = self.df_user_id{
            aCoder.encodeObject(val, forKey: "df_user_id")
        }
        if let val = self.df_user_id_cs{
            aCoder.encodeObject(val, forKey: "df_user_id_cs")
        }
        if let val = self.df_no{
            aCoder.encodeObject(val, forKey: "df_no")
        }
        if let val = self.df_sync_status{
            aCoder.encodeObject(val, forKey: "df_sync_status")
        }
        if let val = self.listDefect{
            aCoder.encodeObject(val, forKey: "listDefect")
        }
    }
    
    convenience init(room:Room!, user:User!, userCS:User!, project:ProjectModel!) {
        self.init()
        
        self.room = room
        self.user = user
        self.project = project
        self.userCS = userCS
        
    }
    func getListDefect(handler: (success:Bool) -> Void) {
        
        
        if DefectRoom.getCache(self.df_room_id) != nil {
            
            let defectRoom:DefectRoom = DefectRoom.getCache(self.df_room_id)!
            
            defectRoom.needSync({ (isNeedSync) in
                
                if (isNeedSync == true) {
                    
                    Queue.mainQueue({
                        //PUSH
                        let timeStamp = NSDateFormatter.dateFormater().stringFromDate(NSDate())
                        Sync.syncToServer(defectRoom, db_name: PROJECT!.pj_datebase_name!, timeStamp: timeStamp, defect: (defectRoom.listDefect)!)
                        { (result) in
                            
                            Queue.mainQueue({
                                if  result == "NETWORK_FAIL" {
                                    SwiftSpinner.hide()
                                    handler(success: false)
                                    
                                    
                                }else if result == "TRUE" {
                                    self.df_check_date = timeStamp
                                    self.getListDefectOnServer({
                                        
                                        self.doCache()
                                        SwiftSpinner.hide()
                                        handler(success: true)
                                        
                                        }, networkFail: {
                                            SwiftSpinner.hide()
                                            handler(success: false)
                                    })
                                }
                                
                            })
                            
                        }
                    })
                    
                }else{
                    self.listDefect?.removeAllObjects()
                    self.listDefect? = defectRoom.listDefect!
                    SwiftSpinner.hide()
                    handler(success: true)
                }
                
            }, networkFail: { 
                
                SwiftSpinner.hide()
                handler(success: false)
            })
            
        }else{
            self.getListDefectOnServer({
                
                self.doCache()
                handler(success: true)
                
            }, networkFail: {
                
                SwiftSpinner.hide()
                handler(success: false)
                
            })
        }
    }
    func needSync(handler: (Bool!) -> Void, networkFail: () -> Void){
        
        NetworkDetection.manager.isConected { (isConected) in
            
            if isConected == false {
                networkFail()
            }else{
            
                let url = "\(DOMAIN_NAME)/Defect/isSync.php?ransom=\(NSString.randomStringWithLength(10))"
                Alamofire.request(.POST, url, parameters: ["db_name":PROJECT!.pj_datebase_name!,
                    "df_room_id":self.df_room_id!,
                    "time_stamp":self.df_check_date!])
                    .responseJSON { response in
                        
                        if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                            print("JSON: \(JSON)")
                            let status:String = JSON.objectForKey("status") as! String
                            if status == "200" {
                                
                                handler(true)
                                
                            }else{
                                
                                handler(false)
                                
                            }
                            
                        }else{
                            
                            handler(false)
                            
                        }
                        
                }
            }
            
        }
        
        
    
    }
    func getListDefectOnServer(handler: () -> Void, networkFail: () -> Void) {
        
        NetworkDetection.manager.isConected { (isConected) in
            
            if isConected == false {
            
                networkFail()
                
            }else{
            
                SwiftSpinner.show("Retrive defect data..", animated: true)
                
                Alamofire.request(.GET, "\(DOMAIN_NAME)/Defect/getListDefect.php?db_name=\(PROJECT!.pj_datebase_name!)&df_room_id=\(self.df_room_id!)&ransom=\(NSString.randomStringWithLength(10))", parameters: [:])
                    .responseJSON { response in
                        
                        if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                            print("JSON: \(JSON)")
                            let status:String = JSON.objectForKey("status") as! String
                            if status == "200" {
                                let defectList:[NSDictionary] = JSON.objectForKey("defectList") as! [NSDictionary]
                                self.listDefect?.removeAllObjects()
                                for dict:NSDictionary in defectList {
                                    
                                    let defect:DefectModel = DefectModel()
                                    defect.categoryName = dict.objectForKey("df_category") as? String
                                    defect.df_date = dict.objectForKey("df_date") as? String
                                    defect.listSubCategory = dict.objectForKey("df_detail") as? String
                                    defect.df_id = dict.objectForKey("df_id") as? String
                                    defect.df_image_path = dict.objectForKey("df_image_path") as? String
                                    defect.df_room_id_ref = dict.objectForKey("df_room_id_ref") as? String
                                    defect.df_status = dict.objectForKey("df_status") as? String
                                    defect.subCategoryName = dict.objectForKey("df_sub_category") as? String
                                    defect.df_type = dict.objectForKey("df_type") as? String
                                    defect.complete_status = dict.objectForKey("complete_status") as? String
                                    
                                    if defect.complete_status == "0" {
                                        defect.canEdit = "1"
                                    }else{
                                        defect.canEdit = "0"
                                    }
                                    
                                    self.listDefect?.addObject(defect)
                                }
                                
                            }
                            
                        }
                        handler()
                        SwiftSpinner.hide()
                }
            }
            
        }
        
        
    }
    func checkDuplicate(needUpdateCS:Bool!, handler: (DefectRoom?, isDuplicate:Bool?) -> Void, networkFail: () -> Void) {
        
        
        NetworkDetection.manager.isConected { (isConected) in
            
            if isConected == false {
            
                networkFail()
                
            }else{
                
                SwiftSpinner.show("Verify data..", animated: true)
                
                var csIDNeedUpdate = ""
                if (needUpdateCS == true) {
                    csIDNeedUpdate = "&csIDNeedUpdate=\(self.userCS!.user_id!)"
                }
                
                let path = "\(DOMAIN_NAME)/Defect/isInitial.php?db_name=\(self.project!.pj_datebase_name!)&un_id=\(self.room!.un_id!)&ransom=\(NSString.randomStringWithLength(10))\(csIDNeedUpdate)"
                Alamofire.request(.GET, path, parameters: [:])
                    .responseJSON { response in
                        
                        if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                            print("JSON: \(JSON)")
                            let status:String = JSON.objectForKey("status") as! String
                            
                            if status == "201"{ //DUPLICATE
                                
                                let defectRoom:DefectRoom = DefectRoom()
                                let unitDefect:NSDictionary = JSON.objectForKey("unit_defect") as! NSDictionary
                                defectRoom.df_check_date = unitDefect.objectForKey("df_check_date") as? String
                                defectRoom.df_room_id = unitDefect.objectForKey("df_room_id") as? String
                                defectRoom.df_sync_status = unitDefect.objectForKey("df_sync_status") as? String
                                defectRoom.df_un_id = unitDefect.objectForKey("df_un_id") as? String
                                defectRoom.df_user_id = unitDefect.objectForKey("df_user_id") as? String
                                defectRoom.df_no = unitDefect.objectForKey("df_no") as? String
                                
                                let cs:String = (unitDefect.objectForKey("df_user_id_cs") as? String)!
                                let lastCs = ((cs as NSString).componentsSeparatedByString(",") as [String]).last
                                
                                defectRoom.df_user_id_cs = lastCs
                                defectRoom.project = self.project
                                
                                handler(defectRoom, isDuplicate: true)
                                
                                
                            }else{
                                
                                handler(nil, isDuplicate: false)
                                
                            }
                            
                            
                        }else{
                            handler(nil, isDuplicate: false)
                            
                        }
                }
                
            }
            
        }
        
        
        
    }
    
    func add(handler: (Bool?, message:String? , status:String?) -> Void, networkFail: () -> Void) {
        
        NetworkDetection.manager.isConected { (isConected) in
            
            if isConected == false {
                
                networkFail()
            
            }else{
                
                SwiftSpinner.show("Initialing..", animated: true)
                let path = "\(DOMAIN_NAME)/Defect/initialRoomDefect.php"
                let param = ["un_id":self.room!.un_id!,
                    "db_name":PROJECT!.pj_datebase_name!,
                    "user_id":self.user!.user_id!,
                    "user_id_cs":self.userCS!.user_id!,
                    "df_check_date":NSDateFormatter.dateFormater().stringFromDate(NSDate())]
                Alamofire.request(.POST, path, parameters: param)
                    .responseJSON { response in
                        
                        if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                            print("JSON: \(JSON)")
                            
                            let status:String = JSON.objectForKey("status") as! String
                            let message:String = JSON.objectForKey("message") as! String
                            
                            if JSON.objectForKey("status") as! String == "200" {
                                
                                if let unitDefect:NSDictionary = JSON.objectForKey("data") as? NSDictionary {
                                    
                                    let id:NSNumber = NSNumber(integer: (unitDefect.objectForKey("df_room_id") as? Int)!)
                                    
                                    self.df_check_date = unitDefect.objectForKey("df_check_date") as? String
                                    self.df_room_id = id.stringValue
                                    self.df_sync_status = unitDefect.objectForKey("df_sync_status") as? String
                                    self.df_un_id = unitDefect.objectForKey("df_un_id") as? String
                                    self.df_user_id = unitDefect.objectForKey("df_user_id") as? String
                                    self.df_user_id_cs = unitDefect.objectForKey("df_user_id_cs") as? String
                                    self.df_no = unitDefect.objectForKey("df_no") as? String
                                    self.project = PROJECT
                                }
                                
                                
                                handler(true,message: message,status: status)
                                SwiftSpinner.hide()
                            }else{
                                handler(false,message: message,status: status)
                                SwiftSpinner.hide()
                            }
                            
                        }else{
                            handler(false,message: "JSON ERROR",status: "305")
                            SwiftSpinner.hide()
                        }
                }
            }
            
        }
    }

}
