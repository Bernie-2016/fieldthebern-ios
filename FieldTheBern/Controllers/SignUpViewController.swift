//
//  SignUpViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/11/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var isFacebookSignup: Bool = false
    var facebookToken: FBSDKAccessToken?

    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var facebookSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressEmail() {
        self.performSegueWithIdentifier("SignUpFormSegue", sender: self)
    }
    
    @IBAction func pressFacebook() {
        self.isFacebookSignup = true
        
        facebookSpinner.startAnimating()
        facebookButton.titleLabel?.layer.opacity = 0
        
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.Native
        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            self.animateFacebookButton()
            
            let token = result.token
            
            if error != nil {
                log.error("Process error")
            } else {
                if result.isCancelled {
                    log.error("Cancelled")
                } else {
                    let session = Session.sharedInstance

                    UserService().checkUserWithFacebookIdExists(token.userID, callback: { (userExists, apiSuccess, error) -> Void in

                        if userExists {
                            session.authorize(.Facebook, email: nil, password: nil, facebookToken: token) { (success) -> Void in
                                if success {
                                    self.performSegueWithIdentifier("Login", sender: self)
                                }
                            }
                        } else {
                            if apiSuccess {
                                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name"])
                                request.startWithCompletionHandler({ (connection, graphResult, error) -> Void in

                                    if error == nil {
                                        self.email = graphResult.valueForKey("email") as? String
                                        self.firstName = graphResult.valueForKey("first_name") as? String
                                        self.lastName = graphResult.valueForKey("last_name") as? String
                                        self.facebookToken = token
                                        
                                        self.performSegueWithIdentifier("SignUpFormSegue", sender: self)
                                    } else {
                                        // Facebook error
                                    }
                                })
                            } else {
                            
                            }
                        }
                    })
                }
            }
        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignUpFormSegue" {
            if let destinationVC = segue.destinationViewController as? SignUpFormViewController {
                if self.isFacebookSignup {
                    destinationVC.email = self.email
                    destinationVC.firstName = self.firstName
                    destinationVC.lastName = self.lastName
                    destinationVC.facebookToken = self.facebookToken
                }
                destinationVC.isFacebookSignup = self.isFacebookSignup
                
                // Reset our values
                self.email = nil
                self.firstName = nil
                self.lastName = nil
                self.facebookToken = nil
                self.isFacebookSignup = false
            }
        }
    }
    
    private func animateFacebookButton() {
        self.facebookButton.titleLabel?.layer.opacity = 1
        self.facebookSpinner.stopAnimating()
    }
    
    // MARK: - Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
