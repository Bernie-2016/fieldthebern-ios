//
//  ImageContentCell.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

class ImageContentCell: ContentCell {
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var actionButton: UIButton!
    
    var queue = NSOperationQueue()
    var actionDestinationURL: NSURL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        queue.cancelAllOperations()
        contentImageView.image = nil
    }
    
    // 
    // MARK: Setters
    //
    
    func setImageURL(url: NSURL, size: CGSize) {
        let operation = ImageDownloadOperation(url: url, size: size, cacheImmediately: true, overlayColor: UIColor.clearColor())
        operation.completionBlock = { [weak self] in
            let image = operation.image
            dispatch_async(dispatch_get_main_queue()) {
                self?.contentImageView.image = image
            }
        }
        
        queue.addOperation(operation)
    }
    
    func setActionDestinationURLString(urlString: String) {
        if let url = NSURL(string: urlString), _ = url.path {
            actionDestinationURL = url
            actionButton.alpha = 1.0
        }
        else {
            actionDestinationURL = nil
            actionButton.alpha = 0.0
        }
    }
    
    //
    // MARK: Action Methods
    //
    
    @IBAction func actionPushed() {
        if let url = actionDestinationURL {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}