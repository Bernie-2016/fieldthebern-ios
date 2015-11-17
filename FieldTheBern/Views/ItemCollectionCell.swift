//
//  ItemCollectionCell.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionCell: UICollectionViewCell {
    @IBOutlet var itemTitleLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        queue.cancelAllOperations()
    }
    
    //
    // MARK: Setters
    //
    
    var queue = NSOperationQueue()
    func setImageURL(url: NSURL, size: CGSize) {
        let overlayColor = UIColor(white: 0.0, alpha: 0.35)
        let operation = ImageDownloadOperation(url: url, size: size, cacheImmediately: true, overlayColor: overlayColor)

        operation.completionBlock = { [weak self] in
            let image = operation.image
            dispatch_async(dispatch_get_main_queue()) {
                self?.itemImageView.image = image
            }
        }
        
        queue.addOperation(operation)
    }
}