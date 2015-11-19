//
//  TriangleView.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/19/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        
        let minX = CGRectGetMinX(rect)
        let minY = CGRectGetMinY(rect)
        let maxX = CGRectGetMaxX(rect)
        let maxY = CGRectGetMaxY(rect)
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, minX, minY)
        CGContextAddLineToPoint(ctx, maxX, minY)
        CGContextAddLineToPoint(ctx, (maxX/2.0), maxY)
        CGContextClosePath(ctx)
        
        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1)
        CGContextFillPath(ctx)
        
        let topLeft = CGPoint(x: minX, y: minY + 1)
        let topRight = CGPoint(x: maxX, y: minY + 1)
        let bottom = CGPoint(x: (maxX/2.0), y: maxY)

        let lineWidth = CGFloat(0.5)
        Color.TanGray.setStroke()

        let leftBorderPath = UIBezierPath()
        leftBorderPath.lineWidth = lineWidth
        leftBorderPath.moveToPoint(topLeft)
        leftBorderPath.addLineToPoint(bottom)
        leftBorderPath.stroke()
        
        let rightBorderPath = UIBezierPath()
        rightBorderPath.lineWidth = lineWidth
        rightBorderPath.moveToPoint(topRight)
        rightBorderPath.addLineToPoint(bottom)
        rightBorderPath.stroke()
    }
}
