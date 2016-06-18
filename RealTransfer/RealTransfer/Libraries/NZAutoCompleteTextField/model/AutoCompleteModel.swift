//
//  AutoCompleteModel.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/9/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

class AutoCompleteModel: NSObject {
    
    var text:String!
    
    var identifier:String?
    var userInfo:AnyObject?
    
    
    convenience init(text:String!) {
        self.init()
        
        self.text = text
    }

}
