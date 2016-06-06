//
//  ProjectViewController.swift
//  RealTransfer
//
//  Created by AmmalesPSC91 on 6/6/2559 BE.
//  Copyright © 2559 nuizoro. All rights reserved.
//

import UIKit

let NUMBER_OF_COLLUMN = 3

class ProjectViewController: NZViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var projects:NSMutableArray = NSMutableArray()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func configLayout() {
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    override func stateInitialData() {
        
        projects = ProjectModel.dummyData()
        

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return Int(ceilf(Float(projects.count) / Float(NUMBER_OF_COLLUMN)))
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let val = (section + 1) * NUMBER_OF_COLLUMN
        if val > projects.count {
            let rowNum = val - projects.count
            return rowNum
        }
        return NUMBER_OF_COLLUMN
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let model:ProjectModel = projects.objectAtIndex(indexPath.row) as! ProjectModel
        let cell:ProjectCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ProjectCollectionViewCell
    
        cell.title.text = model.title!
        cell.subTitle.text = model.subTitle!
        cell.imageView.image = model.image!
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let rect:CGRect = UIScreen.mainScreen().bounds
        let spacing:CGFloat = 165 + (rect.size.width - 1024) / 2
        return UIEdgeInsetsMake(20, spacing, 0, spacing)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
