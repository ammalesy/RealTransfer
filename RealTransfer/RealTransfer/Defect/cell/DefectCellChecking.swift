//
//  DefectCellChecking.swift
//  RealTransfer
//
//  Created by Apple on 6/29/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class DefectCellChecking: DefectCell {
    
    var defectRef:DefectModel?
    
    @IBOutlet weak var nzSwitch: NZSwitch!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var detailRightLb: TTTAttributedLabel!
    
    override func awakeFromNib() {
        
        self.statusIconImageView.assignCornerRadius(self.statusIconImageView.frame.size.height / 2)
        self.middleTextLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.detailRightLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.assignTapOnImageView()
        
        self.nzSwitch.delegate = self
 
    }
//    
//    
//    
//    @IBAction func switchAction(sender: AnyObject) {
//        if defectRef?.complete_status == "1" && self.switching.on == true {
//            return;
//        }
//        if defectRef?.complete_status == "0" && self.switching.on == false
//        {
//            return;
//        }
//        
//        if self.delegate != nil {
//            
//            self.delegate?.defectCellCheckingButtonClicked!(self)
//        }
//        
//    }
////    @IBAction func checkBoxAction(sender: AnyObject) {
////        
////        
////        if self.delegate != nil {
////            self.delegate?.defectCellCheckingButtonClicked!(self)
////        }
////        
////    }

}

extension DefectCellChecking : NZSwitchDelegate {

    func nzSwitch(view: NZSwitch, isOn on: Bool) {
        
        if self.delegate != nil {
            
            self.delegate?.defectCellCheckingButtonClicked!(self, isOn: self.nzSwitch.isOn)
        }
        
    }
    
}
