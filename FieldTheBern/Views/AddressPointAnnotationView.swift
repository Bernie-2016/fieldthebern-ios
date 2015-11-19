//
//  AddressPointAnnotationView.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/18/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddressPointAnnotationView: UIView {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bestCanvassResponseLabel: UILabel!
    @IBOutlet weak var lastVisitedAtLabel: UILabel!
    

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hitTest( point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let viewPoint = superview?.convertPoint(point, toView: self) ?? point
        
        let isInsideView = pointInside(viewPoint, withEvent: event)
        
        let view = super.hitTest(viewPoint, withEvent: event)
        
        return view
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return CGRectContainsPoint(bounds, point)
    }

}
