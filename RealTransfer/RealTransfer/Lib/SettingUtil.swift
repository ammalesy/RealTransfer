//
//  SettingUtil.swift
//  RealTransfer
//
//  Created by Apple on 11/7/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import Foundation

let kDisplayGuarantee = "kDisplayGuarantee"
let kDisplayDrawingMode = "kDisplayDrawingMode"

class SettingUtil: NSObject {
    
    static let sharedInstance = SettingUtil()
    
    var isDisplayGuarantee:Bool = true
    var isDisplayDrawingMode:Bool = true
    
    let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override init(){
        super.init()
        self.refresh()
    }
    func refresh() {
        
        if let flag = userDefault.objectForKey(kDisplayGuarantee) as? Bool {
            self.isDisplayGuarantee = flag
        }
        if let flag = userDefault.objectForKey(kDisplayDrawingMode) as? Bool {
            self.isDisplayDrawingMode = flag
        }
    }
    
    func set_isDisplayGuarantee(flag:Bool!){
        self.isDisplayGuarantee = flag
        userDefault.setObject(flag!, forKey: kDisplayGuarantee)
        userDefault.synchronize()
        self.refresh()
    }
    func set_isDisplayDrawingMode(flag:Bool!){
        self.isDisplayDrawingMode = flag
        userDefault.setObject(flag!, forKey: kDisplayDrawingMode)
        userDefault.synchronize()
        self.refresh()
    }
}
