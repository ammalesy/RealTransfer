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
    
    static let albumName = "Real Transfer"
    static let sharedInstance = CameraRoll()
    
    var assetCollection: PHAssetCollection!
    var didCollectionCreateSuccess: ()->Void = {}
    var currentImage:UIImage?
    
    init() {
        
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", CameraRoll.albumName)
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
            
            if let firstObject: AnyObject = collection.firstObject {
                return firstObject as! PHAssetCollection
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(CameraRoll.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
                self.didCollectionCreateSuccess()
            }
        }
    }
    
    func saveImage(image: UIImage) {
       
        if assetCollection == nil {
            self.didCollectionCreateSuccess = {
            
                self.saveRawImage(image)
                
            }
            return   // If there was an error upstream, skip the save.
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
    func getLastImage(completion: (image:UIImage)->Void){
    
        let fetchOptions:PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        
        let fetchResult:PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        let imgOption = PHImageRequestOptions()
        imgOption.version = .Current
        
        let lastAsset:PHAsset = (fetchResult.lastObject as? PHAsset)!
        PHImageManager.defaultManager().requestImageForAsset(lastAsset, targetSize: CGSizeMake(100, 100), contentMode: PHImageContentMode.AspectFit, options: imgOption) { (image, info) in
            
            Queue.mainQueue({ 
                completion(image: image!)
            })
            
            
        }
        
    }
    
}
