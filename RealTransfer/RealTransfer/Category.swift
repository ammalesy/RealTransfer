//
//  Category.swift
//  RealTransfer
//
//  Created by Apple on 6/18/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

let kCategory = "Category"
let kCategoryVersion = "CategoryVersion"

class Category: Model {
    
    var category:NSDictionary = NSDictionary()
    
    var version:String?
    static let sharedInstance = Category()
    
    override init() {
        super.init()
        
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let data = userDefault.objectForKey(kCategory) {
            self.category = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! NSDictionary
        }
        
    }
    
    convenience init(version:String!) {
        self.init()
        self.version = version
    }
    
    class func syncCategory(handler: () -> Void) {
        
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var version = (userDefault.objectForKey(kCategoryVersion) as? String)
        if (version == nil) {
            version = "0"
            userDefault.setValue("0", forKey: kCategoryVersion)
            userDefault.synchronize()
        }
        
        Category(version: version).update { (categoryJson) in
            if categoryJson != nil {
                let version:String = categoryJson?.objectForKey("Version") as! String
                userDefault.setValue(version, forKey: kCategoryVersion)
                userDefault.setValue(NSKeyedArchiver.archivedDataWithRootObject(categoryJson!), forKey: kCategory)
                userDefault.synchronize()
            }
            
            
            handler()
        }
    }
    func getCategory()->NSDictionary {
        return self.category
    }
    func update(handler: (NSMutableDictionary?) -> Void) {
        SwiftSpinner.show("Update category..", animated: true)
        
        Alamofire.request(.GET, "\(PathUtil.sharedInstance.path)/Category/read.php?version=\(self.version!)&ransom=\(NSString.randomStringWithLength(10))", parameters: [:])
            .responseJSON { response in
                
                if let JSON:NSMutableDictionary = response.result.value as? NSMutableDictionary {
                    print("JSON: \(JSON)")
                    if JSON.objectForKey("status") as! String == "200" {//Update
                        
                        handler(JSON)
                        SwiftSpinner.hide()
                    }else{                                              //Not Update
                        handler(nil)
                        SwiftSpinner.hide()
                    }
                    
                }else{
                    handler(nil)
                    SwiftSpinner.hide()
                }
        }
    }
    
    class func getSubCategoryBycategoryID(categoryID:String!, dataList:NSDictionary) -> [NSDictionary] {
    
        for data:NSDictionary in dataList.objectForKey("list") as! [NSDictionary] {
            
            if (data.objectForKey("id") as! String) == categoryID {
                
                return data.objectForKey("list") as! [NSDictionary]
                
            }
            
        }
        return []
    }
    class func getListSubCategoryBySubCategoryID(subCategoryID:String!, dataList:NSDictionary) -> [NSDictionary] {
        
        for data:NSDictionary in dataList.objectForKey("list") as! [NSDictionary] {
            
            for dataLevel2:NSDictionary in data.objectForKey("list") as! [NSDictionary] {
                if (dataLevel2.objectForKey("id") as! String) == subCategoryID {
                    
                    return dataLevel2.objectForKey("list") as! [NSDictionary]
                    
                }
            }
            
        }
        return []
    }
    
    
    class func convertCategoryNameToString(categoryName:String!)->String? {
        let categoryList:NSDictionary = Category.sharedInstance.getCategory()
        
        //LEVEL1
        for data:NSDictionary in categoryList.objectForKey("list") as! [NSDictionary] {
            
            if (data.objectForKey("id") as! String) == categoryName {
                
                return (data.objectForKey("title") as! String)
                
            }
        }
        
        return nil
        
    }

}
