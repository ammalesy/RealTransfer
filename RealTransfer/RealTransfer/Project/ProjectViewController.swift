//
//  ProjectViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftSpinner
import SDWebImage

let NUMBER_OF_COLLUMN = 3
var PROJECT:ProjectModel?

class ProjectViewController: NZViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var projects:NSMutableArray = NSMutableArray()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setTapEventOnContainer()
        
        NetworkDetection.manager.isConected { (result) in
            
            if result == false {
                
                let project = Session.shareInstance.projectSelected
                let isOnSession = Session.shareInstance.isOnSession()
                
                if project != nil && isOnSession == true {
                    self.FroceToDetailPage(project!)
                }
            
            }else{
                
                self.fetchData()
            
            }
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ProjectViewController.fetchData),
            name: "FETCH_PROJECT",
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver("FETCH_PROJECT")
    }
    class func postNotificationFetchProject(){
        let noti = NSNotification(name: "FETCH_PROJECT", object: nil);
        NSNotificationCenter.defaultCenter().postNotification(noti)
    }
    
    func fetchData() {
        ProjectModel().getProject({ (list) in
            
            var theList = list
            if list == nil {
                theList = NSMutableArray()
            }
            
            self.projects = theList!
            
            self.collectionView.reloadData()
            
            let user:User = User().getOnCache()!
            
            self.nzNavigationController?.titleLb.text = "Dashboard"
            self.nzNavigationController?.subTitleLb.text = "\(user.user_work_position!) : \(user.user_pers_fname!) \(user.user_pers_lname!)"
            
            Queue.mainQueue {
                self.nzNavigationController?.hideRightInfo(true)
            }
            
            
        }, networkFail: {
                
            AlertUtil.alertNetworkFail(self)
                
        }, froceToDetailIfCached: { (projectModel) in
                
            self.FroceToDetailPage(projectModel)
                
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func configLayout() {

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        self.nzNavigationController?.hideRightInfo(true)
        
        
        
    }
    override func stateConfigData() {
       
        
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        if projects.count > NUMBER_OF_COLLUMN {
            let section:Int = Int(ceilf(Float(projects.count) / Float(NUMBER_OF_COLLUMN)))
            return section
        }else{
            if projects.count == 0 {
                return 0
            }else{
                return 1
            }
            
        }
        
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if projects.count < NUMBER_OF_COLLUMN {
            return projects.count
        }else{
            let val = (section + 1) * NUMBER_OF_COLLUMN
            if val > projects.count {
                let rowNum = val - projects.count
                return rowNum
            }
        }
        return NUMBER_OF_COLLUMN
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let model:ProjectModel = projects.objectAtIndex(indexPath.row) as! ProjectModel
        let cell:ProjectCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ProjectCollectionViewCell
        cell.selected = true
        cell.title.text = model.pj_name!
        cell.subTitle.text = model.pj_detail!
        
        let url:NSURL = NSURL(string: "\(PathUtil.sharedInstance.getWebPath())/\(model.pj_image!)")!
        cell.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "p1"), options: SDWebImageOptions.AllowInvalidSSLCertificates)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let rect:CGRect = UIScreen.mainScreen().bounds
        
        var minusFac:CGFloat = 0
        if rect.size.width > rect.size.height {
            minusFac = rect.size.width
        }else{
            minusFac = rect.size.height
        }
        
        let spacing:CGFloat = 165 + (minusFac - 1024) / 2
        return UIEdgeInsetsMake(20, spacing, 0, spacing)
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.nzNavigationController?.hideMenuPopoverIfViewIsShowing()
        let model:ProjectModel = projects.objectAtIndex(indexPath.row) as! ProjectModel
        self.didSelectItem(model)
        
    }
    func didSelectItem(model:ProjectModel!){
        Queue.mainQueue({ () -> Void in
            
            
            if(BuildingCaching.sharedInstance.isNeedUpdate()){
                
                SwiftSpinner.show("Retriving projects..", animated: true)
                let path = "\(PathUtil.sharedInstance.getApiPath())/Project/getAllBuildingAndRoom.php?db_name=\(model.pj_datebase_name!)&random=\(NSString.randomStringWithLength(10))"
                Alamofire.request(.GET, path, parameters: [:])
                    .responseJSON { response in
                        
                        if let JSON:NSDictionary = response.result.value as? NSDictionary {
                            print("JSON: \(JSON.objectForKey("buildingList"))")
                            if JSON.objectForKey("status") as! String == "200" {
                            
                                let buildings:[NSDictionary] = JSON.objectForKey("buildingList") as! [NSDictionary]
                                
                                BuildingCaching.sharedInstance.setBuildings(buildings)
                                BuildingCaching.sharedInstance.save()
                                
                                SwiftSpinner.hide()
                                self.showGettingStartByModel(model)
                                
                            }else{
                                SwiftSpinner.hide()
                                self.showGettingStartByModel(model)
                                
                            }
                            
                        }else{
                            SwiftSpinner.hide()
                            self.showGettingStartByModel(model)
                            
                        }
                }
                
            }else{
                
                self.showGettingStartByModel(model)
                
            }
        })
    }
    
    func showGettingStartByModel(model:ProjectModel){
        let split:NZSplitViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NZSplitViewController") as! NZSplitViewController
        let controllers:[UIViewController] = split.viewControllers;
        let nav:UINavigationController = controllers[1] as! UINavigationController
        let subsNav:[UIViewController] = nav.viewControllers
        if subsNav[0] is AddDefectViewController {
            let addDefectViewController:AddDefectViewController = subsNav[0] as! AddDefectViewController
            addDefectViewController.project = model
            PROJECT = model
            Session.shareInstance.projectSelected = PROJECT
            Session.shareInstance.doCache()
        }
        
        split.minimumPrimaryColumnWidth = 400
        split.maximumPrimaryColumnWidth = 400
        self.nzNavigationController?.pushViewController(split, completion: { () -> Void in
            
        })
    }
    func FroceToDetailPage(model:ProjectModel){
        Queue.mainQueue { 
            let split:NZSplitViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NZSplitViewController") as! NZSplitViewController
            let controllers:[UIViewController] = split.viewControllers;
            let nav:UINavigationController = controllers[1] as! UINavigationController
            let subsNav:[UIViewController] = nav.viewControllers
            if subsNav[0] is AddDefectViewController {
                let addDefectViewController:AddDefectViewController = subsNav[0] as! AddDefectViewController
                addDefectViewController.project = model
                addDefectViewController.needShowGettingStart = false
                PROJECT = model
                Session.shareInstance.projectSelected = PROJECT
                Session.shareInstance.doCache()
            }
            
            split.minimumPrimaryColumnWidth = 400
            split.maximumPrimaryColumnWidth = 400
            self.nzNavigationController?.pushViewController(split, completion: { () -> Void in
                
                
                let defectRoom = Session.shareInstance.defectRoomSelected!

                
                if let instance = Session.shareInstance.customerInfo {
                    CustomerInfo.assignInstance(instance)
                    
                    let roomSelected = Session.shareInstance.roomSelected!
                    self.nzNavigationController!.assignRightInfovalue(instance, roomNo: roomSelected.un_name!)
                }
                Queue.mainQueue({ 
                    CustomerInfo.sharedInstance.canShow = true
                })
                
                if defectRoom.df_sync_status == "0" {
                    
                    let defectListController:DefectListViewController = split.viewControllers.first as! DefectListViewController
                    defectListController.reloadData(defectRoom)
                    
                    
                    let nav:UINavigationController = split.viewControllers.last as! UINavigationController
                    let addDefectViewController:AddDefectViewController = nav.viewControllers[0] as! AddDefectViewController
                    addDefectViewController.defectRoom = defectRoom
                    
                }else{
                    
                    
                    let controller:DefectListCheckingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DefectListCheckingViewController") as! DefectListCheckingViewController
                    controller.defectRoomRef = defectRoom
                    
                    self.nzNavigationController!.pushViewControllerWithOutAnimate(controller, completion: {
                        
                        
                        
                    })

                
                }
                
            })
        }
        
        
    }
    

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        SDImageCache.sharedImageCache().clearMemory()
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
