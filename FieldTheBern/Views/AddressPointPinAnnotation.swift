//
//  AddressPointPinAnnotation.swift
//  FieldTheBern
//
//  Created by Nicolas Dedual on 11/19/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddressPointPinAnnotation: MKPinAnnotationView {

    class var reuseIdentifier:String {
        return "mapPin"
    }
    
    private var calloutView:AddressPointAnnotationView?
    private var hitOutside:Bool = true
    
    var preventDeselection:Bool {
        return !hitOutside
    }
    
    
    convenience init(annotation:MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: AddressPointPinAnnotation.reuseIdentifier)
        
        canShowCallout = false;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let calloutViewAdded = calloutView?.superview != nil
        
        if (selected || !selected && hitOutside) {
            super.setSelected(selected, animated: animated)
        }
        
        self.superview?.bringSubviewToFront(self)
        
        if (calloutView == nil) {
            calloutView = (NSBundle.mainBundle().loadNibNamed("AddressPointAnnotationView", owner: self, options: nil))[0] as? AddressPointAnnotationView
            calloutView!.addressLabel.text = annotation!.title!
            calloutView!.bestCanvassResponseLabel.text = annotation!.subtitle!
            calloutView!.lastVisitedAtLabel.text = "Last visited 4 days ago"
            calloutView!.frame = CGRect(origin: CGPoint(x: calloutView!.frame.origin.x - calloutView!.frame.width/2, y: calloutView!.frame.origin.y - calloutView!.frame.height), size: calloutView!.frame.size)
        }
        
        if (self.selected && !calloutViewAdded) {
            addSubview(calloutView!)
        }
        
        if (!selected) {
            calloutView?.removeFromSuperview()
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, withEvent: event)
        
        if let callout = calloutView {
            if (hitView == nil && self.selected) {
                hitView = callout.hitTest(point, withEvent: event)
            }
        }
        
        hitOutside = hitView == nil
        
        return hitView;
    }
}