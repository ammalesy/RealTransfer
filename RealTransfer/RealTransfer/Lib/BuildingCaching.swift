//
//  BuildingCaching.swift
//  RealTransfer
//
//  Created by Apple on 6/21/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

let kBuildingCache = "BUILDINGS_CACHE"

class BuildingCaching: NSObject {
    
    static let sharedInstance = BuildingCaching()
    var holder = NSMutableArray()
    
    override init(){
        super.init()
        
        self.refresh()
    }
    func isNeedUpdate() -> Bool {
        
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let cache = (userdefault.objectForKey(kBuildingCache))
        if cache != nil{
            
            return false
        }
        return true
        
    }
    func getBuildingDataByID(id:String!) -> NSDictionary? {
        
        for building:NSDictionary in ((self.holder as NSArray) as! [NSDictionary]) {
            
            if building.objectForKey("building_id") as! String == id {
                return building
            }
            
        }
        return nil
    }
    func setBuildings(buildings:[NSDictionary]!) {
        
        self.holder = NSMutableArray(array: buildings)
        
    }
    func save() {
        
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userdefault.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.holder), forKey: kBuildingCache)
        userdefault.synchronize()
        
    }
    
    func refresh() {
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let data = (userdefault.objectForKey(kBuildingCache)){
            let array = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! NSMutableArray
            //print(array)
            self.holder = NSMutableArray(array: array)
        }
    }
}
