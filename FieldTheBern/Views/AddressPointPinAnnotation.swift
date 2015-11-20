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
    
    private var containerView: UIView?
    private var calloutView: AddressPointAnnotationView?
    private var triangleView: UIView?
    private var hitOutside:Bool = true
    
    var preventDeselection:Bool {
        return !hitOutside
    }
    
    convenience init(annotation:MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: AddressPointPinAnnotation.reuseIdentifier)
        
        canShowCallout = false
    }
    
    let pinWidth: CGFloat = 20.5
    let triangleHeight: CGFloat = 13
    let triangleWidth: CGFloat = 26
    let borderWidth: CGFloat = 0.5

    override func setSelected(selected: Bool, animated: Bool) {
        let containerViewAdded = containerView?.superview != nil
        let calloutViewAdded = calloutView?.superview != nil
        let triangleViewAdded = triangleView?.superview != nil
        
        
        if (selected || !selected && hitOutside) {
            super.setSelected(selected, animated: animated)
        }
        
        self.superview?.bringSubviewToFront(self)
        
        if calloutView == nil {
            calloutView = (NSBundle.mainBundle().loadNibNamed("AddressPointAnnotationView", owner: self, options: nil))[0] as? AddressPointAnnotationView
        }
        
        if (containerView == nil) {
            
            containerView = UIView()
            
            containerView?.center = CGPoint(x: 0.5, y: 0.5)
            
            let pinAnnotation = annotation as! AddressPointAnnotation
            
            calloutView!.addressLabel.text = annotation!.title!
            calloutView!.bestCanvassResponseLabel.text = annotation!.subtitle!
            if let lastVisited = pinAnnotation.lastVisited {
                calloutView!.lastVisitedAtLabel.text = lastVisited
            }
            
            calloutView!.frame = CGRect(
                origin: CGPoint(
                    x: calloutView!.frame.origin.x + pinWidth - calloutView!.frame.width / 2,
                    y: calloutView!.frame.origin.y - calloutView!.frame.height - triangleHeight
                ),
                size: calloutView!.frame.size
            )
            
            calloutView?.layer.borderColor = Color.TanGray.CGColor
            calloutView?.layer.borderWidth = borderWidth
            calloutView?.layer.cornerRadius = 10
            calloutView?.layer.masksToBounds = true
            calloutView?.clipsToBounds = false
            
            triangleView = TriangleView(frame: CGRect(x: 8, y: -(triangleHeight + borderWidth), width: triangleWidth, height: triangleHeight))
            containerView?.bringSubviewToFront(triangleView!)
        }
        
        
        
        if (self.selected && !containerViewAdded && !calloutViewAdded && !triangleViewAdded) {

            if (animated) {
                containerView!.alpha = 0
                containerView!.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }
            
            self.addSubview(containerView!)
            self.containerView!.addSubview(calloutView!)

            triangleView!.backgroundColor = UIColor.clearColor()
            self.containerView!.addSubview(triangleView!)
            
            if (animated) {
                UIView.animateWithDuration(Double(0.2), delay: Double(0.0), usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                    self.containerView!.alpha = 1
                    self.containerView!.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: nil)
            }
        }
        
        if (!selected) {
            
            if(animated) {
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.containerView!.alpha = 0
                    self.containerView!.transform = CGAffineTransformMakeScale(0.75, 0.75)
                    
                    }, completion: nil)
                    
                let delay = 0.51 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay)) // completion code in animateWithDuration was executing too early
               
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.containerView?.removeFromSuperview()
                    self.containerView = nil
                    self.calloutView = nil
                    self.triangleView = nil
                }
            } else {
                self.containerView?.removeFromSuperview()
                self.containerView = nil
                self.calloutView = nil
                self.triangleView = nil
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
        
        return hitView
    }
}