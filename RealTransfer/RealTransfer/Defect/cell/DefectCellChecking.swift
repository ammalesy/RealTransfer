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
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var detailRightLb: TTTAttributedLabel!
    
    override func awakeFromNib() {
        
        self.statusIconImageView.assignCornerRadius(self.statusIconImageView.frame.size.height / 2)
        self.middleTextLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.detailRightLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.assignTapOnImageView()
    }
    
    @IBAction func checkBoxAction(sender: AnyObject) {
        
        
        if self.delegate != nil {
            self.delegate?.defectCellCheckingButtonClicked!(self)
        }
        
    }

}
