//
//  DefectModel.swift
//  RealTransfer
//
//  Created by Apple on 6/12/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class DefectModel: NSObject,NSCoding {
    
    var df_id:String?
    var categoryName: String!
    var subCategoryName: String!
    var listSubCategory: String!
    var df_room_id_ref:String?
    var df_date:String?
    var df_image_path:String?
    var df_status:String?
    
    var realImage:UIImage?
    
    var categoryName_displayText: String!
    var subCategoryName_displayText: String!
    var listSubCategory_displayText: String!

    override init() {
        
    }
    func toJson() -> AnyObject!{
        
        let json:NSMutableDictionary = NSMutableDictionary()
        json.setObject(self.df_id!, forKey: "df_id")
        json.setObject(self.categoryName, forKey: "categoryName")
        json.setObject(self.subCategoryName, forKey: "subCategoryName")
        json.setObject(self.listSubCategory, forKey: "listSubCategory")
        json.setObject(self.df_room_id_ref!, forKey: "df_room_id_ref")
        json.setObject(self.df_date!, forKey: "df_date")
        json.setObject(self.df_image_path!, forKey: "df_image_path")
        json.setObject(self.df_status!, forKey: "df_status")
        return json
        
    }
    required init(coder aDecoder: NSCoder) {
        self.df_id  = aDecoder.decodeObjectForKey("df_id") as? String
        self.categoryName  = aDecoder.decodeObjectForKey("categoryName") as? String
        self.subCategoryName  = aDecoder.decodeObjectForKey("subCategoryName") as? String
        self.listSubCategory  = aDecoder.decodeObjectForKey("listSubCategory") as? String
        self.df_room_id_ref  = aDecoder.decodeObjectForKey("df_room_id_ref") as? String
        self.df_date  = aDecoder.decodeObjectForKey("df_date") as? String
        self.df_image_path  = aDecoder.decodeObjectForKey("df_image_path") as? String
        self.df_status  = aDecoder.decodeObjectForKey("df_status") as? String
        self.realImage  = aDecoder.decodeObjectForKey("realImage") as? UIImage
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let val = self.df_id{
            aCoder.encodeObject(val, forKey: "df_id")
        }
        if let val = self.categoryName{
            aCoder.encodeObject(val, forKey: "categoryName")
        }
        if let val = self.subCategoryName{
            aCoder.encodeObject(val, forKey: "subCategoryName")
        }
        if let val = self.listSubCategory{
            aCoder.encodeObject(val, forKey: "listSubCategory")
        }
        if let val = self.df_room_id_ref{
            aCoder.encodeObject(val, forKey: "df_room_id_ref")
        }
        if let val = self.df_date{
            aCoder.encodeObject(val, forKey: "df_date")
        }
        if let val = self.df_image_path{
            aCoder.encodeObject(val, forKey: "df_image_path")
        }
        if let val = self.df_status{
            aCoder.encodeObject(val, forKey: "df_status")
        }
        if let val = self.realImage{
            aCoder.encodeObject(val, forKey: "realImage")
        }
    }
    convenience init(categoryName:String!, subCategoryName:String!, listSubCategory:String!) {
        self.init()
        
        self.categoryName = categoryName
        self.subCategoryName = subCategoryName
        self.listSubCategory = listSubCategory
    }
    
    func needDisplayText(){
        
        let categoryList:NSDictionary = Category.getCategory()
        
        //LEVEL1
        for data:NSDictionary in categoryList.objectForKey("list") as! [NSDictionary] {
            
            if (data.objectForKey("id") as! String) == self.categoryName {
                
                categoryName_displayText = (data.objectForKey("title") as! String)
                
                // LEVEL2
                for dataLevel2:NSDictionary in data.objectForKey("list") as! [NSDictionary] {
                    
                    if (dataLevel2.objectForKey("id") as! String) == self.subCategoryName {
                        subCategoryName_displayText = (dataLevel2.objectForKey("title") as! String)
                        
                        // LEVEL3
                        for dataLevel3:NSDictionary in dataLevel2.objectForKey("list") as! [NSDictionary] {
                            
                            if (dataLevel3.objectForKey("id") as! String) == self.listSubCategory {
                                listSubCategory_displayText = (dataLevel3.objectForKey("title") as! String)
                                
                                break;
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    
    }

}
