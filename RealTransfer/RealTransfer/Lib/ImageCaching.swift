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
    
    var logoProject:UIImage = UIImage(named: "logo_large")!
    
    static let sharedInstance = ImageCaching()

    override init(){
        super.init()
        //self.holder = NSMutableDictionary()
        self.refresh()
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageByName(named:String!) -> UIImage? {
        
        let img = UIImage(contentsOfFile: SDImageCache.sharedImageCache().defaultCachePathForKey(named))
        
        return img
        
//        if let images = self.holder {
//            
//            //print(images)
//            
//            if let body:[AnyObject] = images.objectForKey(named) as? [AnyObject] {
//                let img = body[0] as? UIImage
//                if img == nil && (self.holder?.allKeys as! [String]).contains(named) {
//                    if let image:UIImage = UIImage(contentsOfFile: SDImageCache.sharedImageCache().defaultCachePathForKey(named)) {
//                        self.holder!.setObject([image,(body[1] as! String)], forKey: named)
//                        
//                        return image
//                    }else{
//                        return nil
//                    }
//                    
//                }
//                else if img != nil
//                {
//                    return img
//                }
//            }
//        }
//        return nil
    }
    
    func setImageByName(named:String!, image:UIImage?, isFromServer:Bool!) {
        var flagSync:String = "0"
        if isFromServer == true {
            flagSync = "1"
        }
        (self.holder)!.setObject(["","0",flagSync], forKey: named)
        
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if userdefault.objectForKey(kImageNameCache) as? NSData == nil {
            
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(NSMutableDictionary())
            userdefault.setObject(data, forKey: kImageNameCache)
            //userdefault.synchronize()
            
        }
        if let nameSyn:NSData = userdefault.objectForKey(kImageNameCache) as? NSData {
            
            let syncList:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(nameSyn) as! NSMutableDictionary
            syncList.setObject(["","0",flagSync], forKey: named)
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(syncList)
            userdefault.setObject(data, forKey: kImageNameCache)
            //userdefault.synchronize()
            
        }
    }
    func removeImageByName(named:String!) {
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        SDImageCache.sharedImageCache().removeImageForKey(named)
        if let nameSyn:NSData = userdefault.objectForKey(kImageNameCache) as? NSData {
            let list:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(nameSyn) as! NSMutableDictionary
            list.removeObjectForKey(named)
            
        }
        
    }
    func setDidImageSyncByName(named:String!) {
        if let img:UIImage = self.getImageByName(named) {
            (self.holder)!.setObject([img,"1","1"], forKey: named)
            let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            if let nameSyn:NSData = userdefault.objectForKey(kImageNameCache) as? NSData {
                let list:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(nameSyn) as! NSMutableDictionary
                list.setObject(["","1","1"], forKey: named)
                
                let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(list)
                userdefault.setObject(data, forKey: kImageNameCache)
                //userdefault.synchronize()
                
            }
        }else{
            ImageCaching.sharedInstance.setImageByName(named, image: UIImage(), isFromServer: true)
        }
    }
    func isImageDidSyncServer(named:String!) -> Bool {

        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let nameSyn:NSData = userdefault.objectForKey(kImageNameCache) as? NSData {
            let list:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(nameSyn) as! NSMutableDictionary
            
            if let array:[String] = list.objectForKey(named) as? [String] {
                if array[2] == "1" {
                    return true
                }else{
                    return false
                }
            }
        }
        return false
    }
    func save() {
    
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let nameSyn:NSData = userdefault.objectForKey(kImageNameCache) as? NSData {
            
            let syncList:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(nameSyn) as! NSMutableDictionary
            
            let theImabes:NSMutableDictionary = self.holder!
            for key in theImabes.allKeys {
                
//                let body:[AnyObject] = theImabes.objectForKey(key) as! [AnyObject]
//                if (body[1] as! String) == "0" {
//                    
//                    //SDImageCache.sharedImageCache().storeImage((body[0] as? UIImage), forKey: String(key), toDisk: true)
//
//                }
                var arr:[String] = syncList.objectForKey(String(key)) as! [String]
                arr[1] = "1"
                syncList.setObject(arr, forKey: String(key))
            }
            
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(syncList)
            userdefault.setObject(data, forKey: kImageNameCache)
//            userdefault.synchronize()
            
        }else{
            
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(NSMutableDictionary())
            userdefault.setObject(data, forKey: kImageNameCache)
//            userdefault.synchronize()
            
        }
        
        
    }
    func clear() {
        self.holder?.removeAllObjects()
    }
    func refresh() {
        let userdefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let data = (userdefault.objectForKey(kImageNameCache)){
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! NSMutableDictionary
            self.holder?.removeAllObjects()
            
            for key:String in dict.allKeys as! [String] {
                self.holder?.setObject(dict.objectForKey(key)!, forKey: key)
            }
            
//            self.holder = NSMutableDictionary(dictionary: dict)
            
//            if (self.holder as! NSMutableDictionary).allKeys.count > 250 {
//
//                (self.holder as! NSMutableDictionary).removeAllObjects()
//                self.save()
//                
//            }
            
        }
    }
    

}
