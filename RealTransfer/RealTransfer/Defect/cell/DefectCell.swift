//
//  DefectCell.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

class DefectCell: UITableViewCell {

    @IBOutlet weak var detailTextLb: UILabel!
    @IBOutlet weak var middleTextLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var defectImageView: UIImageView!
    
    override func awakeFromNib() {
        
        self.statusIconImageView.assignCornerRadius(self.statusIconImageView.frame.size.height / 2)
        
    }
}
