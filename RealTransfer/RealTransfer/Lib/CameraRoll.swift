//
//  CameraRoll.swift
//  RealTransfer
//
//  Created by Apple on 7/23/16.
//  Copyright © 2016 nuizoro. All rights reserved.
//

import UIKit
import Photos

class CameraRoll {
    
//    static var albumName = "Real Transfer"
    static let sharedInstance = CameraRoll()
    
    var assetCollection: PHAssetCollection!
    var didCollectionCreateSuccess: ()->Void = {}
    var currentImage:UIImage?
    
    init() {
        
        //self.fetchAlbum(CameraRoll.albumName)
        
    }
    
    func fetchAlbum(named:String!){
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", named)
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
            
            if let firstObject: AnyObject = collection.firstObject {
                return firstObject as! PHAssetCollection
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            self.didCollectionCreateSuccess()
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(named)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
                self.didCollectionCreateSuccess()
            }
        }
    }
    
    func saveImage(image: UIImage, albumName:String!) {
       
        
        
        if assetCollection == nil {
            self.didCollectionCreateSuccess = {
                
                self.saveRawImage(image)
                
            }
            self.fetchAlbum(albumName)
            
            return;
        }
        self.saveRawImage(image)
    }
    private func saveRawImage(image:UIImage){
    
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
            
            let fastEnumeration = NSArray(array: [assetPlaceholder!] as [PHObjectPlaceholder])
            albumChangeRequest!.addAssets(fastEnumeration)
            
        }) { (falg, error) in
            
        }
        
    }
    func getLastImage(completion: (image:UIImage?)->Void){
        
        
        if assetCollection == nil {
            self.didCollectionCreateSuccess = {
                self.getLastRowImage(completion)
            }
        }else{
            self.getLastRowImage(completion)
        }
    }
    func getLastRowImage(completion: (image:UIImage?)->Void){
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        
        let fetchResult:PHFetchResult = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: fetchOptions)//PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        let imgOption = PHImageRequestOptions()
        imgOption.version = .Current
        
        if fetchResult.count == 0{
            Queue.mainQueue({
                completion(image: nil)
            })
        }else{
            let lastAsset:PHAsset = (fetchResult.lastObject as? PHAsset)!
            PHImageManager.defaultManager().requestImageForAsset(lastAsset, targetSize: CGSizeMake(100, 100), contentMode: PHImageContentMode.AspectFit, options: imgOption) { (image, info) in
                
                Queue.mainQueue({
                    completion(image: image!)
                })
            }
        }
        
        
    }
    
}
