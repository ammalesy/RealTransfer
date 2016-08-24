//
//  PathUtil.swift
//  RealTransfer
//
//  Created by Apple on 6/24/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

let kPath = "PATH"

let kProtocol = "kProtocol"
let kDomainName = "kDomainName"
let kWebDir = "kWebDir"
let kApiDir = "kApiDir"

//let domainName = "http://ec2-52-10-22-26.us-west-2.compute.amazonaws.com"
//let domainName = "https://demo.realsmart.in.th"

class PathUtil: NSObject {
    
    static let sharedInstance = PathUtil()
    
    var urlProtocol:String = "https://"
    var domainName:String = "xx.xx.xx.xx"
    var webDir:String = "/xx"
    var apiDir:String = "/xx/xx"
    let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override init(){
        super.init()
        self.refresh()
    }
    func refresh() {
        
        let urlProtocolStr:String? = userDefault.objectForKey(kProtocol) as? String
        let domainNameStr:String? = userDefault.objectForKey(kDomainName) as? String
        let webDirStr:String? = userDefault.objectForKey(kWebDir) as? String
        let apiDirStr:String? = userDefault.objectForKey(kApiDir) as? String
        
        if urlProtocolStr != nil &&  domainNameStr != nil && webDirStr != nil && apiDirStr != nil {
            
            self.urlProtocol = urlProtocolStr!
            self.domainName = domainNameStr!
            self.webDir = webDirStr!
            self.apiDir = apiDirStr!
            
        }
    }
    func getApiPath()->String{
        return "\(self.urlProtocol)\(self.domainName)\(self.apiDir)"
    }
    func getWebPath()->String{
        return "\(self.urlProtocol)\(self.domainName)\(self.webDir)"
    }
    func set_urlProtocol(protocolUrl:String!){
        self.urlProtocol = protocolUrl
        userDefault.setObject(protocolUrl!, forKey: kProtocol)
        userDefault.synchronize()
        self.refresh()
    }
    func set_DomainName(domainName:String!){
        self.domainName = domainName
        userDefault.setObject(domainName!, forKey: kDomainName)
        userDefault.synchronize()
        self.refresh()
    }
    func set_WebDir(webDir:String!){
        self.webDir = webDir
        userDefault.setObject(webDir!, forKey: kWebDir)
        userDefault.synchronize()
        self.refresh()
    }
    func set_ApiDir(apiDir:String!){
        self.apiDir = apiDir
        userDefault.setObject(apiDir!, forKey: kApiDir)
        userDefault.synchronize()
        self.refresh()
    }
    

}
