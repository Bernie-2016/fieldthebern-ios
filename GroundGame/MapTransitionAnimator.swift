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

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! LoadingAnimationViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        containerView!.addSubview(fromViewController.view)

        let dimension = fromViewController.mapContainer.frame.width * 10

        fromViewController.heightConstraint.constant = dimension
        fromViewController.widthConstraint.constant = dimension

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            fromViewController.mapContainer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            fromViewController.view.layoutIfNeeded()

        }) { (success) -> Void in
            containerView!.addSubview(toViewController!.view)
            self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        }

    }
}
