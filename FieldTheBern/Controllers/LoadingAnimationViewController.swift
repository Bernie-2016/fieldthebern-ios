//
//  LoadingAnimationViewController.swift
//  FieldTheBern
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
        
        session.authorize(.Keychain) { (success) -> Void in
            self.animate()
            self.authorizationSuccess = success
            self.finishedAuthenticating = true
            self.attemptTransition()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showApplicationUpdateNotification:", name: "appNeedsUpdate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideApplicationUpdateNotification:", name: "appDoesNotNeedUpdate", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.canAnimate = true
        
        if self.finishedAuthenticating { animate() }
    }
    
    func animate() {
        if canAnimate {
            self.finishedAnimating = true
            self.attemptTransition()
        }
    }
    
    func attemptTransition() {
        if finishedAnimating && finishedAuthenticating {
            if self.authorizationSuccess {
                self.navigationController?.topViewController?.performSegueWithIdentifier("ShowMapSegue", sender: self)
            } else {
                self.navigationController?.topViewController?.performSegueWithIdentifier("ShowOnboardingSegue", sender: self)
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func showApplicationUpdateNotification(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateAppViewController = storyboard.instantiateViewControllerWithIdentifier("UpdateAppViewController") as! UpdateAppViewController
        
        self.presentViewController(updateAppViewController, animated: true, completion: nil)
    }
    
    func hideApplicationUpdateNotification(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
