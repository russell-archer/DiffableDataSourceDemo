//
//  MediaHelper.swift
//  DiffableDataSourceDemo
//
//  Created by Russell Archer on 24/12/2019.
//  Copyright © 2019 Russell Archer. All rights reserved.
//

import UIKit
import Photos

class DataHelper {
    
    /// Use Photokit to fetch all photos in the users library.
    ///
    /// - Parameter completion: Closure that is called when the array of UIImage is ready
    func loadAllImages(completion: @escaping ([UIImage]) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }

            let fetchOptions = PHFetchOptions()
            fetchOptions.includeAssetSourceTypes = .typeUserLibrary
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]

            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            let mgr = PHImageManager.default()
            var images = [UIImage]()
            let size = CGSize(width: 150, height: 150)

            allPhotos.enumerateObjects(options: []) { (asset, i, ptr) in
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = false  // Request images asynchronously
                
                mgr.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (result, info) in
                    
                    // Note that for an asynchronous request, Photos may call your result handler block more than once.
                    // Photos first calls the block to provide a low-quality image suitable for displaying temporarily while
                    // it prepares a high-quality image. (If low-quality image data is immediately available, the first call
                    // may occur before the method returns.) When the high-quality image is ready, Photos calls your result
                    // handler again to provide it. If the image manager has already cached the requested image at full quality,
                    // Photos calls your result handler only once. The PHImageResultIsDegradedKey key in the result handler’s
                    // info parameter indicates when Photos is providing a temporary low-quality image
                    
                    guard result != nil else { return }
                    if let imgInfo = info, let lowQuality = imgInfo["PHImageResultIsDegradedKey"] as? Bool {
                        if lowQuality { return }  // We're only interested in the final, high-quality images
                    }
                    
                    images.append(result!)
                    
                    // Have we collected all the available images?
                    if images.count == allPhotos.count {
                        completion(images)
                    }
                }
            }
        }
    }
}
