//
//  ImageViewerModel.swift
//  RealTransfer
//
//  Created by Apple on 7/2/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class ImageViewerModel: NSObject {
    
    var iconColor:UIColor!
    var category:String!
    var subCategory:String!
    var detail:String!
    
    convenience init(iconColor:UIColor, category:String!, subCategory:String!, detail:String!) {
        self.init()
        
        self.iconColor = iconColor
        self.category = category
        self.subCategory = subCategory
        self.detail = detail
    }
    
}
