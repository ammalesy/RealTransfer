//
//  NZRow.swift
//  NZPopover
//
//  Created by AmmalesPSC91 on 6/2/2559 BE.
//  Copyright © 2559 dev.com. All rights reserved.
//

import UIKit

class NZRow: NSObject {
    
    var text:String!
    var identifier:String?
    var imageName:String?
    var color:UIColor?
    var tintColor:UIColor!
    
    
    init(text:String! , imageName:String?,tintColor:UIColor!,identifier:String?){
        self.text = text
        self.imageName = imageName
        self.color = UIColor.whiteColor()
        self.identifier = identifier
        self.tintColor = tintColor
    }

}
