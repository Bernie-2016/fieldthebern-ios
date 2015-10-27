//
//  TopicsImageCacheOperation.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/26/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TopicsImageCacheOperation: FTBOperation {
    var size: CGSize
    var overlayColor: UIColor
    
    init(size: CGSize, overlayColor: UIColor) {
        self.size = size
        self.overlayColor = overlayColor
        super.init()
    }
    
    //
    // MARK: Lifecycle Methods
    //
    
    override func start() {
        super.start()
        
        do {
            let realm = try Realm()
            let cacheManager = CacheManager.sharedInstance
            
            let finishOperation = NSOperation()
            finishOperation.completionBlock = { [weak self] in
                self?.state = .Finished
            }
            
            for item in realm.objects(FTBItemModel) {
                if cacheManager.objectForKeyExists(item.imageURLStr) {}
                else {
                    if let imageURL = NSURL(string: item.imageURLStr) {
                        let imageDownloadOperation = cacheImageOperationForURL(imageURL)
                        queue.addOperation(imageDownloadOperation)
                        finishOperation.addDependency(imageDownloadOperation)
                    }
                }
            }
            
            queue.addOperation(finishOperation)
            
        }
        catch _ {
            state = .Finished
        }
    }
    
    //
    // MARK: Image Cache Methods
    //
    
    func cacheImageOperationForURL(url: NSURL) -> NSOperation {
        let imageDownloadOperation = ImageDownloadOperation(url: url, size: size, cacheImmediately: false, overlayColor: overlayColor)
        return imageDownloadOperation
    }
}