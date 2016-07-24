//
//  NZPopoverView.swift
//  NZPopover
//
//  Created by AmmalesPSC91 on 6/1/2559 BE.
//  Copyright © 2559 dev.com. All rights reserved.
//

import UIKit
import CoreGraphics

@objc protocol NZPopoverViewDelegate{
    func popoverView(view:NZPopoverView, didClickRow menu:NZRow)
    optional func popoverViewMarginHarizontalView(view:NZPopoverView) -> CGFloat
}

class NZPopoverView: UIView {
    

    
    var delegate:NZPopoverViewDelegate! = nil
    static var arrowTag = 999
    
    static let duration:NSTimeInterval = 0.3
    static let width:CGFloat = 150.0
    static let rowHeight:CGFloat = 50.0
    static let marginView:CGFloat = 10.0
    static let marginHeightView:CGFloat = 0.0
    static let borderViewColor:UIColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
    
    var needArrow:Bool = false
    var arrowView:TriangeView?
    
    let rows:NSMutableArray = NSMutableArray()

    class func standardSize()->NZPopoverView {
        
        let obj:NZPopoverView = NZPopoverView(frame: CGRectMake(0, 0, width, 0))
        return obj;
    }
    class func standardSizeWithArrow()->NZPopoverView {
        
        let obj:NZPopoverView = NZPopoverView(frame: CGRectMake(0, 0, width, 0))
        obj.needArrow = true
        
        
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
            rowView.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0)
            self.addLineToRowView(rowView)
            rowView.tag = index
            rowView.userInteractionEnabled = true
            rowView.setTitle(row.text, forState: UIControlState.Normal)
          
            rowView.backgroundColor = row.color
            if row.imageName != nil {
                 rowView.setImage(UIImage(named: row.imageName!)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            }
           
            
            rowView.setTitleColor(row.tintColor, forState: UIControlState.Normal)
            rowView.tintColor = row.tintColor!
        
            self.addSubview(rowView)
            var frame:CGRect = self.frame
            frame.size.height  = frame.size.height + NZPopoverView.rowHeight
            self.frame = frame
            self.setNeedsDisplay()
            
            rowView.addTarget(self, action: #selector(NZPopoverView.clickRow(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
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
            var moreX:CGFloat = 0;
            if self.delegate != nil {
                moreX = self.delegate.popoverViewMarginHarizontalView!(self)
            }
            frame.origin.x += moreX
            
            frame.origin.y = targetView.frame.origin.y - NZPopoverView.marginHeightView
            self.frame = frame
            addToView.addSubview(self)
            targetView.setNeedsDisplay()
            
            if self.needArrow {
            
                self.arrowView = TriangeView(frame: CGRectMake((self.frame.origin.x + self.frame.size.width)-1,self.frame.origin.y+1,20,20))
                self.arrowView!.backgroundColor = UIColor.clearColor()
                self.arrowView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
                self.arrowView!.layer.shadowColor = UIColor.blackColor().CGColor
                self.arrowView!.layer.shadowOffset = CGSizeMake(1, -5)
                self.arrowView!.layer.shadowOpacity = 0.2
                
                //            arrowView.tag = arrowTag
                addToView.addSubview(self.arrowView!)
                addToView.bringSubviewToFront(self.arrowView!)
                
            }
            
            
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
                
                if self.needArrow {
                    self.arrowView?.alpha = 0
                }
                
            }, completion: { (flag) -> Void in
                self.removeFromSuperview()
                
                if self.needArrow {
                    self.arrowView?.removeFromSuperview()
                }

            })
        }
    }
    
    
}

class TriangeView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMinY(rect))
        CGContextClosePath(ctx)
        
        
        
        //CGContextSetShadowWithColor(ctx, CGSizeMake(10, 1), 0.5, UIColor.blackColor().CGColor)
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillPath(ctx);
    }
}

