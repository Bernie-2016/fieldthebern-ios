//
//  MapTransitionAnimator.swift
//  GroundGame
//
//  Created by Josh Smith on 10/31/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class MapTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    weak var fromViewController: LoadingAnimationViewController?
    weak var toViewController: UIViewController?
    weak var containerView: UIView?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        containerView = transitionContext.containerView()
        fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? LoadingAnimationViewController
        toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        containerView!.addSubview(fromViewController!.view)

        shrinkMap()
    }
    
    func shrinkMap() {
        let dimension = fromViewController!.mapContainer.frame.width / 1.5
        
        fromViewController?.heightConstraint.constant = dimension
        fromViewController?.widthConstraint.constant = dimension
        
        UIView.animateWithDuration(0.2,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.fromViewController!.mapContainer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
                self.fromViewController!.view.layoutIfNeeded()
            },
            completion: { finished in
                self.explodeMap()
        })
    }
    
    func explodeMap() {
        let dimension = UIScreen.mainScreen().bounds.size.height * 3
        
        fromViewController?.heightConstraint.constant = dimension
        fromViewController?.widthConstraint.constant = dimension

        UIView.animateWithDuration(0.4,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.fromViewController!.mapContainer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
                self.fromViewController!.view.layoutIfNeeded()
            },
            completion: { finished in
                self.containerView!.addSubview(self.toViewController!.view)
                self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        })
    }
}
