//
//  UIImageExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/23/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

typealias CIIImage = CIImage

extension UIImage {
    // Scales an image preserving the aspect ratio to a target size, adding a fill overlay after scaling is complete
    public func scaleToSize(targetSize: CGSize, overlayColor: UIColor) -> UIImage {
        var widthScaleRatio: CGFloat = 1.0
        var heightScaleRatio: CGFloat = 1.0
        
        if (self.size.width > targetSize.width) {
            widthScaleRatio = targetSize.width / self.size.width
        }
        if (self.size.height > targetSize.height) {
            heightScaleRatio = targetSize.height / self.size.height
        }
        
        let scaledRatio = max(widthScaleRatio, heightScaleRatio)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        
        let rect = CGRectMake(
            (targetSize.width - self.size.width * scaledRatio) / 2,
            (targetSize.height -  self.size.height * scaledRatio) / 2,
            self.size.width * scaledRatio,
            self.size.height * scaledRatio
        );
        
        self.drawInRect(rect)
        CGContextSetFillColorWithColor(context, overlayColor.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
}