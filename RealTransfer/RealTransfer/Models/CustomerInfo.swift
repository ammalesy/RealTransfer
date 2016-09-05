//
//  CustomerInfo.swift
//  RealTransfer
//
//  Created by Apple on 6/26/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Foundation

class CustomerInfo: Model, NSCoding {
    
    var qt_unit_number_id:String = "N/A"
    var pers_prefix:String = ""
    var pers_fname:String = "N/A"
    var pers_lname:String = "N/A"
    var pers_sex:String = "N/A"
    var pers_card_id:String = "N/A"
    var pers_mobile:String = "N/A"
    var pers_tel:String = "N/A"
    var pers_email:String = "N/A"
    
    
    var full_name_2:String = ""
    var full_name_3:String = ""
    var full_name_4:String = ""
    
    
    //REF
    var building:String = "N/A"
    var room:String = "N/A"
    var roomType:String = "N/A"
    var unitType:String = "N/A"
    var checkDate:String = "N/A"
    var defectNo:String = "N/A"
    var qcChecker:String = "N/A"
    var cs:String = "N/A"
    
    var canShow:Bool = false
    
    static let sharedInstance = CustomerInfo()
    
    override init(){
        super.init()

    }
    class func assignInstance(customerInfo:CustomerInfo){
        
        CustomerInfo.sharedInstance.qt_unit_number_id  = customerInfo.qt_unit_number_id
        CustomerInfo.sharedInstance.pers_prefix  = customerInfo.pers_prefix
        CustomerInfo.sharedInstance.pers_fname  = customerInfo.pers_fname
        CustomerInfo.sharedInstance.pers_lname  = customerInfo.pers_lname
        CustomerInfo.sharedInstance.pers_sex  = customerInfo.pers_sex
        CustomerInfo.sharedInstance.pers_card_id  = customerInfo.pers_card_id
        CustomerInfo.sharedInstance.pers_mobile  = customerInfo.pers_mobile
        CustomerInfo.sharedInstance.pers_tel  = customerInfo.pers_tel
        CustomerInfo.sharedInstance.pers_email  = customerInfo.pers_email
        
        CustomerInfo.sharedInstance.full_name_2  = customerInfo.full_name_2
        CustomerInfo.sharedInstance.full_name_3  = customerInfo.full_name_3
        CustomerInfo.sharedInstance.full_name_4  = customerInfo.full_name_4
        
        CustomerInfo.sharedInstance.building  = customerInfo.building
        CustomerInfo.sharedInstance.room  = customerInfo.room
        CustomerInfo.sharedInstance.roomType  = customerInfo.roomType
        CustomerInfo.sharedInstance.unitType  = customerInfo.unitType
        CustomerInfo.sharedInstance.checkDate  = customerInfo.checkDate
        CustomerInfo.sharedInstance.defectNo  = customerInfo.defectNo
        CustomerInfo.sharedInstance.qcChecker  = customerInfo.qcChecker
        CustomerInfo.sharedInstance.cs  = customerInfo.cs
    
    }
    required init(coder aDecoder: NSCoder) {
        self.qt_unit_number_id  = (aDecoder.decodeObjectForKey("qt_unit_number_id") as? String)!
        self.pers_prefix  = (aDecoder.decodeObjectForKey("pers_prefix") as? String)!
        self.pers_fname  = (aDecoder.decodeObjectForKey("pers_fname") as? String)!
        self.pers_lname  = (aDecoder.decodeObjectForKey("pers_lname") as? String)!
        self.pers_sex  = (aDecoder.decodeObjectForKey("pers_sex") as? String)!
        self.pers_card_id  = (aDecoder.decodeObjectForKey("pers_card_id") as? String)!
        self.pers_mobile  = (aDecoder.decodeObjectForKey("pers_mobile") as? String)!
        self.pers_tel  = (aDecoder.decodeObjectForKey("pers_tel") as? String)!
        self.pers_email  = (aDecoder.decodeObjectForKey("pers_email") as? String)!
        
        self.full_name_2  = (aDecoder.decodeObjectForKey("full_name_2") as? String)!
        self.full_name_3  = (aDecoder.decodeObjectForKey("full_name_3") as? String)!
        self.full_name_4  = (aDecoder.decodeObjectForKey("full_name_4") as? String)!
        
        self.building  = (aDecoder.decodeObjectForKey("building") as? String)!
        self.room  = (aDecoder.decodeObjectForKey("room") as? String)!
        self.roomType  = (aDecoder.decodeObjectForKey("roomType") as? String)!
        self.unitType  = (aDecoder.decodeObjectForKey("unitType") as? String)!
        self.checkDate  = (aDecoder.decodeObjectForKey("checkDate") as? String)!
        self.defectNo  = (aDecoder.decodeObjectForKey("defectNo") as? String)!
        self.qcChecker  = (aDecoder.decodeObjectForKey("qcChecker") as? String)!
        self.cs  = (aDecoder.decodeObjectForKey("cs") as? String)!
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.qt_unit_number_id, forKey: "qt_unit_number_id")
        aCoder.encodeObject(self.pers_prefix, forKey: "pers_prefix")
        aCoder.encodeObject(self.pers_fname, forKey: "pers_fname")
        aCoder.encodeObject(self.pers_lname, forKey: "pers_lname")
        aCoder.encodeObject(self.pers_sex, forKey: "pers_sex")
        aCoder.encodeObject(self.pers_card_id, forKey: "pers_card_id")
        aCoder.encodeObject(self.pers_mobile, forKey: "pers_mobile")
        aCoder.encodeObject(self.pers_tel, forKey: "pers_tel")
        aCoder.encodeObject(self.pers_email, forKey: "pers_email")
        
        aCoder.encodeObject(self.full_name_2, forKey: "full_name_2")
        aCoder.encodeObject(self.full_name_3, forKey: "full_name_3")
        aCoder.encodeObject(self.full_name_4, forKey: "full_name_4")
        
        aCoder.encodeObject(self.building, forKey: "building")
        aCoder.encodeObject(self.room, forKey: "room")
        aCoder.encodeObject(self.roomType, forKey: "roomType")
        aCoder.encodeObject(self.unitType, forKey: "unitType")
        aCoder.encodeObject(self.checkDate, forKey: "checkDate")
        aCoder.encodeObject(self.defectNo, forKey: "defectNo")
        aCoder.encodeObject(self.qcChecker, forKey: "qcChecker")
        aCoder.encodeObject(self.cs, forKey: "cs")

    }

    
    func clear() {

        qt_unit_number_id = "N/A"
        pers_prefix = ""
        pers_fname = "N/A"
        pers_lname = "N/A"
        pers_sex = "N/A"
        pers_card_id = "N/A"
        pers_mobile = "N/A"
        pers_tel = "N/A"
        pers_email = "N/A"
        
        
        //REF
        building = "N/A"
        room = "N/A"
        roomType = "N/A"
        unitType = "N/A"
        checkDate = "N/A"
        defectNo = "N/A"
        qcChecker = "N/A"
        cs = "N/A"
        
        canShow = false
        
        full_name_2 = ""
        full_name_3 = ""
        full_name_4 = ""
    }
    
    
}
