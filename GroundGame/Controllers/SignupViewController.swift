//
//  SignupViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/28/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Text {
    static let PlaceholderAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    static let Font = UIFont(name: "Lato-Medium", size: 18)
}

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    var bottomConstraintValue: CGFloat?
    
    @IBOutlet weak var firstNameField: UITextField! {
        didSet {
            firstNameField.attributedPlaceholder = NSAttributedString(string: "First name", attributes: Text.PlaceholderAttributes)
            firstNameField.font = Text.Font
            firstNameField.delegate = self
        }
    }
    
    @IBOutlet weak var lastNameField: UITextField! {
        didSet {
            lastNameField.attributedPlaceholder = NSAttributedString(string: "Last name", attributes: Text.PlaceholderAttributes)
            lastNameField.font = Text.Font
            lastNameField.delegate = self
        }
    }
    
    @IBOutlet weak var emailField: UITextField! {
        didSet {
            emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: Text.PlaceholderAttributes)
            emailField.font = Text.Font
            emailField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: Text.PlaceholderAttributes)
            passwordField.font = Text.Font
            passwordField.delegate = self
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var facebookSpinner: UIActivityIndicatorView!
    
    
    func submitForm() {
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let email = emailField.text
        let password = passwordField.text
        
        
        if (firstName!.isEmpty || lastName!.isEmpty || password!.isEmpty || !email!.isValidEmail) {
            
            let alert = UIAlertController(title: "Incomplete information", message: "Please make sure to enter all details and a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (_) in}
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        spinner.startAnimating()
        submitButton.titleLabel?.layer.opacity = 0
        
        let userService = UserService()
    
        userService.createUser(email: email!, password: password!, firstName: firstName!, lastName: lastName!) { (user,success, error) in
            self.submitButton.titleLabel?.layer.opacity = 1
            if success {
                let session = Session.sharedInstance
                session.authorize(email!, password: password!, callback: { (success) -> Void in
                    self.spinner.stopAnimating()
                    if success {
                        self.performSegueWithIdentifier("Login", sender: self)
                    } else {
                        // Handle error
                    }
                })
            } else {
                self.spinner.stopAnimating()
                if let error = error {
                    self.handleError(error)
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWasHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func pressSignUp() {
        submitForm()
    }
    
    @IBAction func pressFacebookButton() {
        facebookSpinner.startAnimating()
        facebookButton.titleLabel?.layer.opacity = 0

        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.Native
        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            self.facebookButton.titleLabel?.layer.opacity = 1
            self.facebookSpinner.stopAnimating()

            if error != nil {
                NSLog("Process error")
            } else {
                if result.isCancelled {
                    NSLog("Cancelled")
                } else {
                    let session = Session.sharedInstance
                    print(result.token.permissions)
                    print(result.token.declinedPermissions)
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])
                    request.startWithCompletionHandler({ (connection, graphResult, error) -> Void in
                        if error == nil {
                            if let email = graphResult.valueForKey("email") as? String {
                                // They have an email, okay to proceed
                                session.authorizeWithFacebook(token: result.token, callback: { (success) -> Void in
                                    if success {
                                        self.performSegueWithIdentifier("Login", sender: self)
                                    }
                                })
                            } else {
                                // no email
                            }
                        } else {
                             // Facebook error
                        }
                    })
                }
            }
        })
    }
    
    @IBAction func pressSignIn() {
        performSegueWithIdentifier("SignInModalSegue", sender: self)
    }
    
    // MARK: - Text Field Delegate Methods

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            return lastNameField.becomeFirstResponder()
        case lastNameField:
            return emailField.becomeFirstResponder()
        case emailField:
            return passwordField.becomeFirstResponder()
        case passwordField:
            return passwordField.resignFirstResponder()
        default:
            return false
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraintValue = self.bottomConstraint.constant
            self.bottomConstraint.constant = keyboardFrame.size.height - 106
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if let value = self.bottomConstraintValue {
                self.bottomConstraint.constant = value
            }
        })
    }
    
    // MARK: - Error Handling
    
    func handleError(error: APIError) {
        let errorTitle = error.errorTitle
        let errorMessage = error.errorDescription
        
        let alert = UIAlertController.errorAlertControllerWithTitle(errorTitle, message: errorMessage)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
