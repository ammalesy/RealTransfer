//
//  ProjectModel.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Foundation

class ProjectModel: NSObject {

    var image:UIImage?
    var title:String!
    var subTitle:String!
    
    class func dummyData() -> NSMutableArray {
        let array:NSMutableArray = NSMutableArray()
        for var i = 0; i < 10; i++ {
            
            let model:ProjectModel = ProjectModel()
            model.title = "The Capital Ekamai-Thomglor"
            model.subTitle = "เอกมัย-ทองหล่อ"
            model.image = UIImage(named: "p1")
            
            array.addObject(model)
        }
        return array;
    }
    
}
