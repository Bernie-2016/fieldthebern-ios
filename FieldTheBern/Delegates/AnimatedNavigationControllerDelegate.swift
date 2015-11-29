//
//  AnimatedNavigationControllerDelegate.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/31/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

class AnimatedNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if fromVC.isKindOfClass(LoadingAnimationViewController) {
            return MapTransitionAnimator()
        } else {
            return nil
        }
    }
}