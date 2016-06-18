//
//  RowModel.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

class RowModel: NSObject {

    var head:String!
    var detail:String?
    var style:String!
    var colorNextbutton:UIColor?
    var identifier:String?
    
    var enable:Bool = true
    
    convenience init(head:String!, detail:String!) {
        self.init()
        self.head = head
        self.detail = detail
        
    }
    
}
