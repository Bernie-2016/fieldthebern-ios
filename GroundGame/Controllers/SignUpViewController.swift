//
//  SignUpViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 11/11/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var facebookSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressFacebook() {
        facebookSpinner.startAnimating()
        facebookButton.titleLabel?.layer.opacity = 0
        
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.Native
        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            self.facebookButton.titleLabel?.layer.opacity = 1
            self.facebookSpinner.stopAnimating()
            
            let token = result.token
            
            if error != nil {
                log.error("Process error")
            } else {
                if result.isCancelled {
                    log.error("Cancelled")
                } else {
                    let session = Session.sharedInstance
                    print(token.permissions)
                    print(token.declinedPermissions)
                    UserService().checkUserWithFacebookIdExists(token.userID, callback: { (userExists, apiSuccess, error) -> Void in
                        print(userExists)
                        if userExists {
                            session.authorizeWithFacebook(token: token, callback: { (success) -> Void in
                                print(success)
                                if success {
                                    self.performSegueWithIdentifier("Login", sender: self)
                                }
                            })
                        } else {
                            if apiSuccess {
                                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name"])
                                request.startWithCompletionHandler({ (connection, graphResult, error) -> Void in
                                    log.error("\(graphResult)")
                                    if error == nil {
                                        if let email = graphResult.valueForKey("email") as? String {
                                            // They have an email, okay to proceed
                                        } else {
                                            // no email
                                        }
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
    
}
