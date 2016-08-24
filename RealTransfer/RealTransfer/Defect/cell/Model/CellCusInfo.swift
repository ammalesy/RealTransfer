//
//  CellCusInfo.swift
//  RealTransfer
//
//  Created by Apple on 8/24/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class CellCusInfo: UITableViewCell {

    @IBOutlet weak var leftLabel: TTTAttributedLabel!
    @IBOutlet weak var rightLabel: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftLabel.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        rightLabel.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
    }


}
