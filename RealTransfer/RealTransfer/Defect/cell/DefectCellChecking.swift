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
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var detailRightLb: TTTAttributedLabel!
    
    @IBOutlet weak var switching: UISwitch!
    @IBOutlet weak var titleCheckDate: UILabel!
    override func awakeFromNib() {
        
        self.statusIconImageView.assignCornerRadius(self.statusIconImageView.frame.size.height / 2)
        self.middleTextLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.detailRightLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.assignTapOnImageView()
 
        switching.onImage = UIImage(named: "folder")
        switching.offImage = UIImage(named: "folder_icon");
        switching.transform = CGAffineTransformMakeScale(1.20, 1.20);
        
//        let label:UILabel = UILabel(frame: CGRectMake(0,0,30,30))
//        label.text = "ตรวจเมื่อ"
//        label.textColor = UIColor.whiteColor()
//        label.font = UIFont.fontNormal(6)
//        switching.addSubview(label)
    
    }
    
    @IBAction func switchAction(sender: AnyObject) {
        if defectRef?.complete_status == "1" && self.switching.on == true {
            return;
        }
        if defectRef?.complete_status == "0" && self.switching.on == false
        {
            return;
        }
        
        if self.delegate != nil {
            
            self.delegate?.defectCellCheckingButtonClicked!(self)
        }
        
    }
//    @IBAction func checkBoxAction(sender: AnyObject) {
//        
//        
//        if self.delegate != nil {
//            self.delegate?.defectCellCheckingButtonClicked!(self)
//        }
//        
//    }

}
