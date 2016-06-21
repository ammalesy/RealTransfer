//
//  ImageCaching.swift
//  RealTransfer
//
//  Created by Apple on 6/20/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import SDWebImage

let kImageNameCache = "IMAGE_CACHE"

class ImageCaching: CachingManager {
    
    static let sharedInstance = ImageCaching()
    
    override init(){
        super.init()
        self.holder = NSMutableDictionary()
        self.refresh()
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageByName(named:String!) -> UIImage? {
        
        if let images = self.holder {
            
            print(images)
            
            if let body:[AnyObject] = (images as! NSMutableDictionary).objectForKey(named) as? [AnyObject] {
                let img = body[0] as? UIImage
                if img == nil && (self.holder?.allKeys as! [String]).contains(named) {
                    if("before_sync_021062559022501" == named){
                    
                    }
                    if let image:UIImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(named) {
                        (self.holder as! NSMutableDictionary).setObject([image,(body[1] as! String)], forKey: named)
                        
                        return image
                    }else{
                        return nil
                    }
                    
                }
                else if img != nil
                {
                    return img
                }
            }
        }
        return nil
    }
    
    func setImageByName(named:String!, image:UIImage!) {
        
        (self.holder as! NSMutableDictionary).setObject([image,"0"], forKey: named)
        
    }
    func save() {
    
            let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            let syncList:NSMutableDictionary = NSMutableDictionary()
            let theImabes:NSMutableDictionary = self.holder as! NSMutableDictionary
            for key in theImabes.allKeys {
                Queue.serialQueue({ 
                    let body:[AnyObject] = theImabes.objectForKey(key) as! [AnyObject]
                    if (body[1] as! String) == "0" {
                        
                        SDImageCache.sharedImageCache().storeImage((body[0] as? UIImage), forKey: String(key), toDisk: true)
                        syncList.setObject(["","1"], forKey: String(key))
                        
                        //if let data = UIImageJPEGRepresentation((body[0] as? UIImage)!, 1.0) {
                        //let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("\(String(key)).jpg")
                        //                        if data.writeToFile(filename, atomically: true) {
                        //
                        //                            syncList.setObject(["","1"], forKey: String(key))
                        //
                        //                        }
                        //}
                    }else{
                        syncList.setObject(["","1"], forKey: String(key))
                    }
                })
            }
        
        Queue.serialQueue { 
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(syncList)
            userdefault.setObject(data, forKey: kImageNameCache)
            userdefault.synchronize()
            
            SDImageCache.sharedImageCache().clearMemory()
        }
    }
    
    func refresh() {
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let data = (userdefault.objectForKey(kImageNameCache)){
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! NSMutableDictionary
            print(dict)
            self.holder = NSMutableDictionary(dictionary: dict)
            
//            if (self.holder as! NSMutableDictionary).allKeys.count > 250 {
//                
//                (self.holder as! NSMutableDictionary).removeAllObjects()
//                self.save()
//                
//            }
            
        }
    }
    

}
