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

    static var buldings:NSMutableArray = NSMutableArray() //<== GLOBAL VAR
    //DATA
    var project:ProjectModel!
    var building_id:String?
    var building_name:String?
    var rooms:NSMutableArray = NSMutableArray()
    
    convenience init(project:ProjectModel!) {
        self.init()
        self.project = project
    }
    func getRooms(handler: (NSMutableArray?) -> Void){
        if self.rooms.count > 0
        {
            handler(self.rooms)
        }
        else
        {
            let returnList:NSMutableArray = NSMutableArray()
            SwiftSpinner.show("Retriving Rooms..", animated: true)
            
            Alamofire.request(.GET, "http://\(DOMAIN_NAME)/Service/Project/getRooms.php?db_name=\(self.project.pj_datebase_name!)&building_id=\(self.building_id!)", parameters: [:])
                .responseJSON { response in
                    
                    if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                        print("JSON: \(JSON)")
                        if JSON.objectForKey("status") as! String == "200" {
                            
                            for room:NSDictionary in ((JSON.objectForKey("roomList") as! NSArray) as! [NSDictionary]) {
                                let rm:Room = Room()
                                rm.un_build_id = room.objectForKey("un_build_id") as? String
                                rm.un_floor_id = room.objectForKey("un_floor_id") as? String
                                rm.un_unit_type_id = room.objectForKey("un_unit_type_id") as? String
                                rm.un_name = room.objectForKey("un_name") as? String
                                rm.un_number = room.objectForKey("un_number") as? String
                                rm.un_direction = room.objectForKey("un_direction") as? String
                                rm.un_view = room.objectForKey("un_view") as? String
                                rm.un_status_room = room.objectForKey("un_status_room") as? String
                                rm.un_sts_active = room.objectForKey("un_sts_active") as? String
                                rm.un_id = room.objectForKey("un_id") as? String
                                returnList.addObject(rm)
                            }
                            self.rooms = returnList;
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
    func getBuildings(handler: (NSMutableArray?) -> Void){
        
        if Building.buldings.count > 0
        {
            handler(Building.buldings)
        }
        else
        {
            let returnList:NSMutableArray = NSMutableArray()
            SwiftSpinner.show("Retriving building..", animated: true)
            
            Alamofire.request(.GET, "http://\(DOMAIN_NAME)/Service/Project/getBuildings.php?db_name=\(project.pj_datebase_name!)", parameters: [:])
                .responseJSON { response in
                    
                    if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                        print("JSON: \(JSON)")
                        if JSON.objectForKey("status") as! String == "200" {
                            
                            for project:NSDictionary in ((JSON.objectForKey("buildingList") as! NSArray) as! [NSDictionary]) {
                                let bd:Building = Building()
                                bd.building_id = project.objectForKey("building_id") as? String
                                bd.building_name = project.objectForKey("building_name") as? String
                                bd.project = self.project
                                returnList.addObject(bd)
                            }
                            Building.buldings = returnList;
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
}
