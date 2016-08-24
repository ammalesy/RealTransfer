//
//  DefectCell.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//
import UIKit
import TTTAttributedLabel

@objc protocol DefectCellViewDelegate{

    optional func defectCell(cell:DefectCell, didClickMenu model:NZRow, popover:NZPopoverView)
    optional func defectCellPopoverWillShow(cell:DefectCell)
    optional func defectCellPopoverWillHide(cell:DefectCell)
    optional func touchBeganCell(cell:DefectCell)
    optional func defectCell(cell:DefectCell, didClickImage image:UIImage)
    
    
    optional func defectCellCheckingButtonClicked(view:DefectCellChecking, isOn on:Bool)
    optional func defectCellSwitchCanChanged(view:DefectCellChecking) -> Bool
    optional func defectCell(cell:DefectCell, didShowPopover popover:NZPopoverView)

}

class DefectCell: UITableViewCell,NZPopoverViewDelegate {

    var popover:NZPopoverView!
    
    @IBOutlet weak var detailTextLb: TTTAttributedLabel!
    @IBOutlet weak var middleTextLb: TTTAttributedLabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var defectImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var pencilButton: UIButton!
    var delegate:DefectCellViewDelegate? = nil
    
    override func awakeFromNib() {
        
        self.statusIconImageView.assignCornerRadius(self.statusIconImageView.frame.size.height / 2)
        middleTextLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        detailTextLb.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        self.assignTapOnImageView()
        
    }
    func assignTapOnImageView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(DefectCell.tapImageView))
        tap.cancelsTouchesInView = false
        self.defectImageView.userInteractionEnabled = true
        self.defectImageView.addGestureRecognizer(tap)
    }
    
    func tapImageView(){
        if (self.delegate != nil) {
            
            self.delegate?.defectCell!(self, didClickImage: self.defectImageView.image!)
            
        }
    }
    
    func setHideEditting(hide:Bool){
        pencilButton.hidden = false
        editImageView.hidden = false
        if hide {
            pencilButton.hidden = true
            editImageView.hidden = true
        }
    }
    
    @IBAction func editAction(sender: AnyObject) {
        
        if popover != nil {
            self.hideMenuPopoverIfViewIsShowing()
        }else{
            if (self.delegate != nil) {
                
                self.delegate?.defectCellPopoverWillShow!(self)
                
            }
            popover = NZPopoverView.standardSizeWithArrow()
            popover.delegate = self
            popover.addRow(NZRow(text: "Edit", imageName:nil, tintColor: UIColor.darkGrayColor(),  identifier: "edit"))
            popover.addRow(NZRow(text: "Delete", imageName:nil, tintColor: UIColor(red: 223/255, green: 0/255, blue: 0/255, alpha: 1),  identifier: "delete"))
            
            popover.showNearView(self.editImageView, addToView: self)
            
            if (self.delegate != nil) {
                
                self.delegate?.defectCell!(self, didShowPopover: self.popover)
                
            }
            self.addObServerHidePopupEditting()
        }
        

        
    }
    func hideMenuPopoverIfViewIsShowing(){
        if popover != nil {
            if (self.delegate != nil) {
                
                self.delegate?.defectCellPopoverWillHide!(self)
                
            }
            popover.hide()
            popover = nil
            NSNotificationCenter.defaultCenter().removeObserver("TOUCH_BEGAN_VIEW")
        }
    }
    
    func popoverViewMarginHarizontalView(view: NZPopoverView) -> CGFloat {
        
        return -10
        
    }
    func popoverView(view: NZPopoverView, didClickRow menu: NZRow) {
        
        if (self.delegate != nil) {
            
            self.delegate?.defectCell!(self, didClickMenu: menu, popover: view)
            
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hideMenuPopoverIfViewIsShowing()
        let noti = NSNotification(name: "HIDE_MENU_ON_NAV", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(noti)
        
        if (self.delegate != nil) {
            
            self.delegate?.touchBeganCell!(self)
            
        }

    }
    func addObServerHidePopupEditting(){
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(hideMenuPopoverIfViewIsShowing),
            name: "TOUCH_BEGAN_VIEW",
            object: nil)
        
    }
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver("TOUCH_BEGAN_VIEW")
    
    }
}
