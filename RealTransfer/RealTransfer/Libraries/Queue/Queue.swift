//
//  Queue.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Foundation

class Queue: NSObject {
    
    class func mainQueue(block:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), block)
    }

}
