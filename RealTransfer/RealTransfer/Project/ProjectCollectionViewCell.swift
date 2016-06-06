//
//  ProjectCollectionViewCell.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import Foundation

class ProjectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        
        title.font = UIFont.fontSemiBold(18)
        subTitle.font = UIFont.fontNormal(16)
        
    }
}
