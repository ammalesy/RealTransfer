//
//  Queue.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Foundation

let serialQueue_t:dispatch_queue_t = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL)

class Queue: NSObject {
    
    class func mainQueue(block:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    class func globalQueue(block:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block)
    }
    
    class func serialQueue(block:dispatch_block_t){
        dispatch_async(serialQueue_t, block)
    }

}
