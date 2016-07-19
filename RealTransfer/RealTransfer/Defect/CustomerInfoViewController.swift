//
//  CustomerInfoViewController.swift
//  RealTransfer
//
//  Created by Apple on 6/12/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit

class CustomerInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var listData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panelView.layer.shadowColor = UIColor.blackColor().CGColor
        self.panelView.layer.shadowOpacity = 0.3
        self.panelView.layer.shadowOffset = CGSizeMake(1, 1)
        self.panelView.layer.shadowRadius = 2
        startBtn.assignCornerRadius(5)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let customer:CustomerInfo = CustomerInfo.sharedInstance
        
        listData.addObject(RowModel(head: "Building : ", detail: customer.building))
        listData.addObject(RowModel(head: "Room : ", detail: customer.room))
        
        var name = "N/A"
        if customer.pers_fname != "N/A" && customer.pers_lname != "N/A" {
            name = "\(customer.pers_prefix)\(customer.pers_fname) \(customer.pers_lname)"
        }
        
        listData.addObject(RowModel(head: "Name : ", detail: name))
        listData.addObject(RowModel(head: "Email : ", detail: customer.pers_email))
        listData.addObject(RowModel(head: "Phone No : ", detail: customer.pers_tel))
        listData.addObject(RowModel(head: "Room Type : ", detail: customer.roomType))
        listData.addObject(RowModel(head: "Unit Type : ", detail: customer.unitType))
        listData.addObject(RowModel(head: "Last Update : ", detail: customer.checkDate))
        listData.addObject(RowModel(head: "Check Date : ", detail: NSDateFormatter.dateDisplayFormat().stringFromDate(NSDate())))
        listData.addObject(RowModel(head: "Defect No.: ", detail: customer.defectNo))
        listData.addObject(RowModel(head: "QC Checker : ", detail: customer.qcChecker))
        listData.addObject(RowModel(head: "CS : ", detail: customer.cs))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listData.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model:RowModel = listData.objectAtIndex(indexPath.row) as! RowModel
        let cell:CellLabelStatic = tableView.dequeueReusableCellWithIdentifier(CELL_LABEL_STATIC_IDENTIFIER) as! CellLabelStatic
        cell.leftLabel.text = model.head
        cell.rightLabel.text = model.detail
        return cell
        
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor.clearColor()
        
    }
    func hideView(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.view.alpha = 0
            
        }) { (result) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }

    @IBAction func submitAction(sender: AnyObject) {
        
        self.hideView()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
