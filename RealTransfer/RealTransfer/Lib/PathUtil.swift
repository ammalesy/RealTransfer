//
//  PathUtil.swift
//  RealTransfer
//
//  Created by Apple on 6/24/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

let kPath = "PATH"
//let domainName = "http://ec2-52-10-22-26.us-west-2.compute.amazonaws.com"
let domainName = "https://demo.realsmart.in.th"
//let domainName = "192.168.1.3"
//let domainName = "192.168.1.5"
//let domainNamevar"127.0.0.1"
let defaultPath = "\(domainName)/Service"

class PathUtil: NSObject {
    
    static let sharedInstance = PathUtil()
    var path:String = ""
    let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override init(){
        super.init()
        self.refresh()
    }
    func refresh() {
        
        
        if let pathStr:String = userDefault.objectForKey(kPath) as? String {
         
            self.path = pathStr
            
        }else{
            self.path = defaultPath
            
        }
    }
    func setServerPath(path:String!){
        self.path = path
        userDefault.setObject(path!, forKey: kPath)
        userDefault.synchronize()
        self.refresh()
        
    }

}
