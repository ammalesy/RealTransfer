//
//  AlertUtil.swift
//  RealTransfer
//
//  Created by Apple on 6/23/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class AlertUtil: NSObject {
    
    class func alert(title:String!, message:String!, cancleButton:String!, atController:UIViewController!) {
    
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let action:UIAlertAction = UIAlertAction(title: cancleButton, style: UIAlertActionStyle.Cancel, handler: { (action) in
            
        })
        alert.addAction(action)
        
        atController.presentViewController(alert, animated: true, completion: {
            
        })
        
    }
    class func alert(title:String!, message:String!, cancleButton:String!, atController:UIViewController!, handler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let action:UIAlertAction = UIAlertAction(title: cancleButton, style: UIAlertActionStyle.Cancel, handler: handler)
        alert.addAction(action)
        
        atController.presentViewController(alert, animated: true, completion: {
            
        })
        
    }
    
    //

}
