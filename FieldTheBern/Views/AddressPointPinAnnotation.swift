//
//  AddressPointPinAnnotation.swift
//  FieldTheBern
//
//  Created by Nicolas Dedual on 11/19/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddressPointPinAnnotation: MKAnnotationView {

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
            
            if(animated)
            {
            calloutView!.alpha = 0;
            calloutView!.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }
            addSubview(calloutView!)
            if(animated)
            {
                UIView.animateWithDuration(Double(0.3), delay: Double(0.0), usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                    self.calloutView!.alpha = 1;
                    self.calloutView!.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: nil)
            }
        }
        
        if (!selected) {
            
            if(animated)
            {
                
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.calloutView!.alpha = 0;
                self.calloutView!.transform = CGAffineTransformMakeScale(0.75, 0.75)

                }, completion: nil)
                
                let delay = 0.51 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay)) // completion code in animateWithDuration was executing too early
               
                dispatch_after(time, dispatch_get_main_queue()) {
                   self.calloutView?.removeFromSuperview()
                    self.calloutView = nil
                }
            }
            else
            {
                self.calloutView!.removeFromSuperview()
                self.calloutView = nil;
            }
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