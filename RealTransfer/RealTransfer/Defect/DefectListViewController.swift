//
//  DefectListViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/8/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

let CELL_DEFECT_IDENTIFIER = "CellDefect"

class DefectListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var countDefectLb: UILabel!
    var passList:NSMutableArray = NSMutableArray()
    var failList:NSMutableArray = NSMutableArray()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 114
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 10//passList.count
        }
        return 10//failList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:DefectCell = tableView.dequeueReusableCellWithIdentifier(CELL_DEFECT_IDENTIFIER) as! DefectCell
        
        if indexPath.section == 0 {
            cell.statusIconImageView.backgroundColor = UIColor.RGB(130, G: 187, B: 36)
        }else{
            cell.statusIconImageView.backgroundColor = UIColor.RGB(252, G: 160, B: 41)
        }
        
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 30
        }
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            
            let bgLine:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,30))
            bgLine.backgroundColor = UIColor.whiteColor()
            
            let line:UIView = UIView(frame: CGRectMake(0,15,bgLine.frame.size.width,1))
            line.backgroundColor = UIColor.lightGrayColor()
            
            bgLine.addSubview(line)
            return bgLine
            
        }
        return nil
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
