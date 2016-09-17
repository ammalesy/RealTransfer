//
//  Pin.swift
//  RealTransfer
//
//  Created by Apple on 9/1/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class Pin: Model {
    
    var pinId:String = ""
    var pinValue:String = ""
    
    convenience init(pinId:String, pinValue:String) {
        self.init()
        self.pinId = pinId
        self.pinValue = pinValue
    }
    
    func validatePin(handler: (Bool) -> Void, networkFail: () -> Void) {
        
        NetworkDetection.manager.isConected({ (isConected) in
            
            if isConected == false {
                
                networkFail()
                
            }else{
                SwiftSpinner.show("Validating..", animated: true)
                
                let path = "\(PathUtil.sharedInstance.getApiPath())/Pin/validatePin.php?ransom=\(NSString.randomStringWithLength(10))&pin_value=\(self.pinValue)&db_name=\((PROJECT?.pj_datebase_name!)!)"
                Alamofire.request(.GET, path, parameters: [:])
                    .responseJSON { response in
                        
                        if let JSON:NSDictionary = response.result.value as? NSDictionary {
                            print("JSON: \(JSON)")
                            if JSON.objectForKey("status") as! String == "200" {
                                
                                handler(true)
                                SwiftSpinner.hide()
                            }else{
                                handler(false)
                                SwiftSpinner.hide()
                            }
                            
                        }else{
                            handler(false)
                            SwiftSpinner.hide()
                        }
                }
                
            }
            
        })
    }
    
}


