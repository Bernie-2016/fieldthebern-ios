//
//  LoadingAnimationViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/31/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class LoadingAnimationViewController: UIViewController {
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var canAnimate = false
    var finishedAnimating = false
    var finishedAuthenticating = false
    var authorizationSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let session = Session.sharedInstance
        
        session.attemptAuthorizationFromKeychain { (success) -> Void in
            self.animate()
            self.authorizationSuccess = success
            self.finishedAuthenticating = true
            self.attemptTransition()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.canAnimate = true
        
        if self.finishedAuthenticating { animate() }
    }
    
    func animate() {
        if canAnimate {
            let dimension = mapContainer.frame.width * 10
            
            self.heightConstraint.constant = dimension
            self.widthConstraint.constant = dimension
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                    self.mapContainer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
                    self.view.layoutIfNeeded()
                
                }) { (success) -> Void in
                    
                    self.finishedAnimating = true
                    self.attemptTransition()
            }
        }
    }
    
    func attemptTransition() {
        log.debug("attempting transition")
        if finishedAnimating && finishedAuthenticating {
            NSNotificationCenter.defaultCenter().postNotificationName("appDidLoad", object: self, userInfo: ["authorized": self.authorizationSuccess])
        }
    }
}
