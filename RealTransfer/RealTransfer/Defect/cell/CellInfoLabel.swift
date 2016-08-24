//
//  CellInfoLabel.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class CellInfoLabel: UITableViewCell {

    @IBOutlet weak var leftLabel1: TTTAttributedLabel!
    @IBOutlet weak var leftLabel2: UILabel!
    @IBOutlet weak var leftLabel3: UILabel!
    @IBOutlet weak var leftLabel4: UILabel!
    @IBOutlet weak var leftLabel5: UILabel!
    @IBOutlet weak var leftLabel6: UILabel!
    @IBOutlet weak var leftLabel7: UILabel!
    @IBOutlet weak var leftLabel8: UILabel!
    
    @IBOutlet weak var rightLabel1: TTTAttributedLabel!
    @IBOutlet weak var rightLabel2: UILabel!
    @IBOutlet weak var rightLabel3: UILabel!
    @IBOutlet weak var rightLabel4: UILabel!
    @IBOutlet weak var rightLabel5: UILabel!
    @IBOutlet weak var rightLabel6: UILabel!
    @IBOutlet weak var rightLabel7: UILabel!
    @IBOutlet weak var rightLabel8: UILabel!
    
    @IBOutlet weak var height_leftLabel7: NSLayoutConstraint!
    @IBOutlet weak var height_leftLabel8: NSLayoutConstraint!
    
    @IBOutlet weak var height_rightLabel7: NSLayoutConstraint!
    @IBOutlet weak var height_rightLabel8: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftLabel1.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        rightLabel1.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        
    }
}
