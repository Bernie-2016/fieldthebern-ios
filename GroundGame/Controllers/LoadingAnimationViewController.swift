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
    
    var finishedAnimating = false
    var finishedAuthenticating = false
    var authorizationSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let session = Session.sharedInstance
        
        log.debug("attempting")
        
        session.attemptAuthorizationFromKeychain { (success) -> Void in
            log.debug("\(success)")
            self.authorizationSuccess = success
            self.finishedAuthenticating = true
            self.attemptTransition()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
    
    func animate() {
        let dimension = mapContainer.frame.width * 15
        
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
    
    func attemptTransition() {
        log.debug("attempting transition")
        if finishedAnimating && finishedAuthenticating {
            NSNotificationCenter.defaultCenter().postNotificationName("appDidLoad", object: self, userInfo: ["authorized": self.authorizationSuccess])
        }
    }
}
