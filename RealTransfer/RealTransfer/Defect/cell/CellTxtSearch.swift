//
//  CellTxtSearch.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/7/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
protocol CellTxtSearchDelegate{
    func cellTxtSearchDidClickNext(cell:CellTxtSearch)
    func cellTxtSearchBeginEditting(cell:CellTxtSearch, textField:UITextField)
    func cellTxtSearchTextChange(cell:CellTxtSearch, string:String)
}

class CellTxtSearch: UITableViewCell,UITextFieldDelegate {
    
    var delegate:CellTxtSearchDelegate! = nil

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    private func configureTextField(){
        
        
//        self.textField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
//        self.textField.autoCompleteTextFont = UIFont.fontNormal(14)
//        self.textField.autoCompleteCellHeight = 50.0
//        self.textField.maximumAutoCompleteCount = 20
//        self.textField.hidesWhenSelected = true
//        self.textField.hidesWhenEmpty = true
//        self.textField.enableAttributedText = true
//        var attributes = [String:AnyObject]()
//        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
//        attributes[NSFontAttributeName] = UIFont.fontNormal(14)
//        self.textField.autoCompleteAttributes = attributes
        
        self.textField.delegate = self
        
        
    }
    override func awakeFromNib() {
        self.configureTextField()
        self.nextBtn.assignCornerRadius(5)
        
//        self.textField.onTextChange = {[weak self] text in
//            if !text.isEmpty{
//                self?.textField.autoCompleteStrings = [
//                    "100",
//                    "200",
//                    "300",
//                    "400",
//                    "500",
//                    "600",
//                    "700",
//                    "800",
//                    "900"
//                ]
//            }
//        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.delegate != nil {
            self.delegate.cellTxtSearchBeginEditting(self, textField: textField)
        }
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let realString:String = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if self.delegate != nil {
            self.delegate.cellTxtSearchTextChange(self, string: realString)
        }
        
        return true
        
    }
    @IBAction func nextAction(sender: AnyObject) {
        
        if self.delegate != nil {
            self.delegate.cellTxtSearchDidClickNext(self)
        }
        
    }
}
