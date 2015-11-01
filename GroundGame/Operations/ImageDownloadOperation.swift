//
//  ImageDownloadOperation.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadOperation: FTBOperation {
    var image: UIImage?
    
    var url: NSURL
    var size: CGSize
    var cacheImmediately: Bool
    var overlayColor: UIColor
    
    init(url: NSURL, size: CGSize, cacheImmediately: Bool, overlayColor: UIColor) {
        self.url = url
        self.size = size
        self.cacheImmediately = cacheImmediately
        self.overlayColor = overlayColor
        super.init()
    }
    
    //
    // MARK: Lifecycle Methods
    //
    
    override func start() {
        super.start()
        
        if let path = url.path, data = CacheManager.sharedInstance.objectForKey(path) {
            self.image = UIImage(data: data)
            state = .Finished
            return
        }
        else {
            startImageDownload()
        }
    }
    
    func startImageDownload() {
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        
        let size = self.size
        let cacheImmediately = self.cacheImmediately
        let overlayColor = self.overlayColor
        
        dataTask = session.dataTaskWithRequest(request) { [weak self] (data, response, error) -> Void in
            defer {
                self?.state = .Finished
            }
            
            guard let data = data else { return }
            var image = UIImage(data: data)
            guard size.height > 0 && size.width > 0 else { return }
            
            image = image?.scaleToSize(size, overlayColor: overlayColor)
            self?.image = image
            
            guard let cacheImage = image, path = self?.url.path, cacheData = UIImageJPEGRepresentation(cacheImage, 1.0) else { return }
            CacheManager.sharedInstance.setObject(cacheData, forKey: path, cacheImmediately: cacheImmediately)
        }
        
        dataTask?.resume()
    }
    
    //
    // MARK: Resource Methods
    //
    
    override func cleanup() {
        super.cleanup()
        image = nil
    }

}