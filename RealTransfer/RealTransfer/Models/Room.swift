//
//  Room.swift
//  RealTransfer
//
//  Created by Apple on 6/18/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class Room: Model,NSCoding {
    
    var un_id:String?
    var un_build_id:String?
    var un_floor_id:String?
    var un_unit_type_id:String?
    var un_name:String?
    var un_number:String?
    var un_direction:String?
    var un_view:String?
    var un_status_room:String?
    var un_sts_active:String?
    
    override init() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.un_id  = aDecoder.decodeObjectForKey("un_id") as? String
        self.un_build_id  = aDecoder.decodeObjectForKey("un_build_id") as? String
        self.un_floor_id  = aDecoder.decodeObjectForKey("un_floor_id") as? String
        self.un_unit_type_id  = aDecoder.decodeObjectForKey("un_unit_type_id") as? String
        self.un_name  = aDecoder.decodeObjectForKey("un_name") as? String
        self.un_number  = aDecoder.decodeObjectForKey("un_number") as? String
        self.un_direction  = aDecoder.decodeObjectForKey("un_direction") as? String
        self.un_view  = aDecoder.decodeObjectForKey("un_view") as? String
        self.un_status_room  = aDecoder.decodeObjectForKey("un_status_room") as? String
        self.un_sts_active  = aDecoder.decodeObjectForKey("un_sts_active") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let val = self.un_id{
            aCoder.encodeObject(val, forKey: "un_id")
        }
        if let val = self.un_build_id{
            aCoder.encodeObject(val, forKey: "un_build_id")
        }
        if let val = self.un_floor_id{
            aCoder.encodeObject(val, forKey: "un_floor_id")
        }
        if let val = self.un_unit_type_id{
            aCoder.encodeObject(val, forKey: "un_unit_type_id")
        }
        if let val = self.un_name{
            aCoder.encodeObject(val, forKey: "un_name")
        }
        if let val = self.un_number{
            aCoder.encodeObject(val, forKey: "un_number")
        }
        if let val = self.un_direction{
            aCoder.encodeObject(val, forKey: "un_direction")
        }
        if let val = self.un_view{
            aCoder.encodeObject(val, forKey: "un_view")
        }
        if let val = self.un_status_room{
            aCoder.encodeObject(val, forKey: "un_status_room")
        }
        if let val = self.un_sts_active{
            aCoder.encodeObject(val, forKey: "un_sts_active")
        }
    }

}
