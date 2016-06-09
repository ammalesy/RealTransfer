//
//  CellTxtSearch.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

class CellTxtSearch: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var textField: AutoCompleteTextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    private func configureTextField(){
        
        
        self.textField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.textField.autoCompleteTextFont = UIFont.fontNormal(14)
        self.textField.autoCompleteCellHeight = 50.0
        self.textField.maximumAutoCompleteCount = 20
        self.textField.hidesWhenSelected = true
        self.textField.hidesWhenEmpty = true
        self.textField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont.fontNormal(14)
        self.textField.autoCompleteAttributes = attributes
        
        
        
        
    }
    override func awakeFromNib() {
        self.configureTextField()
        
        self.textField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                self?.textField.autoCompleteStrings = ["Nui","Ann","EIEI","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg","wrg"]
            }
        }
    }
    
    @IBAction func nextAction(sender: AnyObject) {
        
    }
}
