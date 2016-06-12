//
//  NZDropDownIconColorCell.swift
//  RealTransfer
//
//  Created by Apple on 6/11/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class NZDropDownIconColorCell: NZDropDowCell {
    
    
    @IBOutlet weak var iconView: UIView!
    override func awakeFromNib() {
        
        self.iconView.assignCornerRadius(self.iconView.frame.size.width / 2)
        
    }

}
