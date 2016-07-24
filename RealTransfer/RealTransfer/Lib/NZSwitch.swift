//
//  NZSwitch.swift
//  NZSwitch
//
//  Created by Apple on 7/24/16.
//  Copyright © 2016 Nuizoro. All rights reserved.
//

import UIKit

@objc protocol NZSwitchDelegate {
    
    func nzSwitch(view:NZSwitch, isOn on:Bool)
    
}
class NZLabel: UILabel {

    override func drawTextInRect(rect: CGRect) {
        let inset = UIEdgeInsetsMake(0, 10, 0, 3)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, inset))
    }
}
class NZSwitch: UIView {
    
    @IBOutlet weak var leftLabel: NZLabel!
    @IBOutlet weak var rightLabel: NZLabel!
    @IBOutlet weak var controlView: UIView!
    var isOn:Bool = false
    
    var delegate:NZSwitchDelegate! = nil

    override func awakeFromNib() {
        
        let gesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NZSwitch.onPand(_:)))
        self.controlView.addGestureRecognizer(gesture)
        
        self.assignCornerRadius(5)
        self.controlView.backgroundColor = UIColor.whiteColor()
        self.controlView.layer.shadowColor = UIColor.blackColor().CGColor
        self.controlView.layer.shadowOpacity = 0.1
        self.controlView.layer.shadowOffset = CGSizeMake(1, 1)
        self.controlView.layer.shouldRasterize = true
        
        
        self.layer.borderColor = UIColor.RGB(185, G: 185, B: 185).CGColor
        self.layer.borderWidth = 1
        

        
    }
    
    func setOn(isOn:Bool, text:String){
        Queue.mainQueue { 
            self.isOn = isOn
            var controlFrame:CGRect = self.controlView.frame
            
            if isOn == false {
                
                controlFrame.origin.x = 0
                
            }else{
                
                controlFrame.origin.x = self.frame.size.width / 2
            }
            
            self.controlView.frame = controlFrame
            self.controlView.setNeedsDisplay()
            self.controlView.layoutIfNeeded()
            self.setNeedsDisplay()
            self.layoutIfNeeded()
            
            self.setText(text)
        }
        
        
    }
    func setText(text:String){
        
        if isOn {
            self.leftLabel.text = text
            self.leftLabel.backgroundColor = UIColor.RGB(102, G: 200, B: 0)
            self.rightLabel.backgroundColor = UIColor.RGB(102, G: 200, B: 0)
            self.layer.borderColor = UIColor.RGB(102, G: 200, B: 0).CGColor
        }else{
            self.rightLabel.text = text
            self.leftLabel.backgroundColor = UIColor.RGB(185, G: 185, B: 185)
            self.rightLabel.backgroundColor = UIColor.RGB(185, G: 185, B: 185)
            self.layer.borderColor = UIColor.RGB(185, G: 185, B: 185).CGColor
        }
        
    }
    
    func onPand(gestureRecognizer:UIPanGestureRecognizer){
        

        let translation = gestureRecognizer.translationInView(self)
        var newCenter:CGPoint = CGPointMake(gestureRecognizer.view!.center.x + translation.x,0);

        let limitCenterxFirst = (self.frame.size.width / 4)
        let limitCenterxLast = (self.frame.size.width / 4) * 3
        
        if newCenter.x < limitCenterxFirst {
            newCenter.x = limitCenterxFirst
        }
        
        if newCenter.x > limitCenterxLast {
            newCenter.x = limitCenterxLast
        }
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
        
            
            let controlFrame = self.controlView.frame
            if controlFrame.origin.x >= 0 && controlFrame.origin.x < (leftLabel.frame.size.width / 2) {
                newCenter.x = limitCenterxFirst
                
                if isOn != false {
                    isOn = false
                    self.delegate.nzSwitch(self, isOn: self.isOn)
                }
                
                
            }else{
                newCenter.x = limitCenterxLast
                if isOn != true {
                    isOn = true
                    self.delegate.nzSwitch(self, isOn: self.isOn)
                }
            }
        
        }

        gestureRecognizer.view!.center = CGPointMake(newCenter.x, gestureRecognizer.view!.center.y)
        gestureRecognizer.setTranslation(CGPointMake(0,0), inView: self)
        
        
    
    }

}
