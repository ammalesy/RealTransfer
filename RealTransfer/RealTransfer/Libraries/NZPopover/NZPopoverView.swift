//
//  NZPopoverView.swift
//  NZPopover
//
//  Created by AmmalesPSC91 on 6/1/2559 BE.
//  Copyright © 2559 dev.com. All rights reserved.
//

import UIKit
import CoreGraphics

protocol NZPopoverViewDelegate{
    func popoverView(view:NZPopoverView, didClickRow menu:NZRow)
}

class NZPopoverView: UIView {
    
    var delegate:NZPopoverViewDelegate! = nil
    
    static let duration:NSTimeInterval = 0.3
    static let width:CGFloat = 150.0
    static let rowHeight:CGFloat = 50.0
    static let marginView:CGFloat = 10.0
    static let marginHeightView:CGFloat = 0.0
    static let borderViewColor:UIColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
    
    
    
    let rows:NSMutableArray = NSMutableArray()

    class func standardSize()->NZPopoverView {
        
        let obj:NZPopoverView = NZPopoverView(frame: CGRectMake(0, 0, width, 0))
        return obj;
    }
    func styleMainView() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = NZPopoverView.borderViewColor.CGColor
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(1, 1)
        self.layer.shadowOpacity = 0.1
    
    }
    func addRow(row:NZRow!){
        rows.addObject(row)
    }
    func clickRow(sender:AnyObject){
        
        if self.delegate != nil {
            self.delegate.popoverView(self, didClickRow: rows.objectAtIndex((sender as! UIButton).tag) as! NZRow)
        }
        
    }
    func addLineToRowView(button:UIButton){
        let line:UIView = UIView(frame: CGRectMake(0,button.frame.size.height - 1,NZPopoverView.width,1))
        line.backgroundColor = NZPopoverView.borderViewColor
        button.addSubview(line)
    }
    func renderRows(){
        
        var y:CGFloat = 0
        var index:Int = 0
        for row:NZRow in (rows as NSArray) as! [NZRow] {
            let rowView:UIButton = UIButton(frame: CGRectMake(0,y,NZPopoverView.width,NZPopoverView.rowHeight))
            rowView.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            rowView.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 20)
            rowView.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0)
            self.addLineToRowView(rowView)
            rowView.tag = index
            rowView.userInteractionEnabled = true
            rowView.setTitle(row.text, forState: UIControlState.Normal)
            rowView.backgroundColor = row.color
            rowView.setImage(UIImage(named: row.imageName!)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            rowView.setTitleColor(row.tintColor, forState: UIControlState.Normal)
            rowView.tintColor = row.tintColor!
        
            self.addSubview(rowView)
            var frame:CGRect = self.frame
            frame.size.height  = frame.size.height + NZPopoverView.rowHeight
            self.frame = frame
            self.setNeedsDisplay()
            
            rowView.addTarget(self, action: Selector("clickRow:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            y = y + NZPopoverView.rowHeight
            index = index + 1
        }
        
        
        
    }
    func showNearView(targetView:UIView!, addToView:UIView!){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.renderRows()
            self.styleMainView()
            var frame:CGRect = self.frame
            frame.origin.x =  targetView.frame.origin.x - frame.size.width - NZPopoverView.marginView
            frame.origin.y = targetView.frame.origin.y - NZPopoverView.marginHeightView
            self.frame = frame
            addToView.addSubview(self)
            targetView.setNeedsDisplay()
            
            self.alpha = 0
            UIView.animateWithDuration(NZPopoverView.duration, animations: { () -> Void in
                self.alpha = 1
            })
        }
    }
    func hide() {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(NZPopoverView.duration, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (flag) -> Void in
                self.removeFromSuperview()
            })
        }
    }
    
    
}

