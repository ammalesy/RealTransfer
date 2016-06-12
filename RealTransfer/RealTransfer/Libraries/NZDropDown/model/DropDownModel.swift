//
//  DropDownModel.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/9/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

class DropDownModel: NSObject {
    
    var text:String!
    var iconColor:UIColor?
    var identifier:String = ""
    
    
    convenience init(text:String!) {
        self.init()
        
        self.text = text
    }
    convenience init(text:String!,iconColor:UIColor!) {
        self.init()
        
        self.text = text
        self.iconColor = iconColor
    }

}
