//
//  DefectModel.swift
//  RealTransfer
//
//  Created by Apple on 6/12/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class DefectModel: NSObject {
    
    var categoryName: String!
    var subCategoryName: String!
    var listSubCategory: String!

    
    convenience init(categoryName:String!, subCategoryName:String!, listSubCategory:String!) {
        self.init()
        
        self.categoryName = categoryName
        self.subCategoryName = subCategoryName
        self.listSubCategory = listSubCategory
    }

}
