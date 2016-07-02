//
//  ImageViewerController.swift
//  RealTransfer
//
//  Created by Apple on 7/2/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ImageViewerController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var iconCategory: UIImageView!
    
    @IBOutlet weak var categoryLb: TTTAttributedLabel!
    @IBOutlet weak var subCategoryLb: TTTAttributedLabel!
    
    @IBOutlet weak var detailCaptionLb: TTTAttributedLabel!
    @IBOutlet weak var detailTxtView: TTTAttributedLabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailCaptionLb.text = "รายการที่ต้องแก้ไข"
        categoryLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        subCategoryLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        detailCaptionLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        detailTxtView.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.iconCategory.assignCornerRadius(self.iconCategory.frame.size.height / 2)
    }
    
    @IBAction func exitAction(sender: AnyObject) {
        self.hideView()
    }
    func hideView(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.view.alpha = 0
            
        }) { (result) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}
