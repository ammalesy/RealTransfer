//
//  CustomerInfo.swift
//  RealTransfer
//
//  Created by Apple on 6/26/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Foundation

class CustomerInfo: Model {
    
    var qt_unit_number_id:String = "N/A"
    var pers_prefix:String = ""
    var pers_fname:String = "N/A"
    var pers_lname:String = "N/A"
    var pers_sex:String = "N/A"
    var pers_card_id:String = "N/A"
    var pers_mobile:String = "N/A"
    var pers_tel:String = "N/A"
    var pers_email:String = "N/A"
    
    
    var full_name_2:String = ""
    var full_name_3:String = ""
    var full_name_4:String = ""
    
    
    //REF
    var building:String = "N/A"
    var room:String = "N/A"
    var roomType:String = "N/A"
    var unitType:String = "N/A"
    var checkDate:String = "N/A"
    var defectNo:String = "N/A"
    var qcChecker:String = "N/A"
    var cs:String = "N/A"
    
    var canShow:Bool = false
    
    static let sharedInstance = CustomerInfo()
    
    override init(){
        super.init()

    }
    
    func clear() {

        qt_unit_number_id = "N/A"
        pers_prefix = ""
        pers_fname = "N/A"
        pers_lname = "N/A"
        pers_sex = "N/A"
        pers_card_id = "N/A"
        pers_mobile = "N/A"
        pers_tel = "N/A"
        pers_email = "N/A"
        
        
        //REF
        building = "N/A"
        room = "N/A"
        roomType = "N/A"
        unitType = "N/A"
        checkDate = "N/A"
        defectNo = "N/A"
        qcChecker = "N/A"
        cs = "N/A"
        
        canShow = false
    }
    
    
}
