//
//  AnimatedNavigationControllerDelegate.swift
//  GroundGame
//
//  Created by Josh Smith on 10/31/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}