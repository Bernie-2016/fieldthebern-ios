//
//  SignInViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/26/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailField: PaddedTextField! {
        didSet {
            emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: Text.PlaceholderAttributes)
            emailField.font = Text.Font
            emailField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordField: PaddedTextField! {
        didSet {
            passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: Text.PlaceholderAttributes)
            passwordField.font = Text.Font
            passwordField.delegate = self
        }
    }
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var facebookSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        // Change navigation bar buttons
        let backButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.startKeyboardObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopKeyboardObserver()
    }
    
    private func startKeyboardObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func stopKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func cancel(sender: UINavigationItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func submitForm() {
        let email = emailField.text
        let password = passwordField.text
        
        
        if (password!.isEmpty || !email!.isValidEmail) {
            
            let alert = UIAlertController.errorAlertControllerWithTitle("Details Missing", message: "Please check your email and password and try again.")
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        spinner.startAnimating()
        submitButton.titleLabel?.layer.opacity = 0

        let session = Session.sharedInstance
        
        session.authorize(email!, password: password!) { (success) -> Void in
            if success {
                self.performSegueWithIdentifier("LoginFromSignIn", sender: self)
            } else {
                self.submitButton.titleLabel?.layer.opacity
                 = 1
                self.spinner.stopAnimating()
                
                let alert = UIAlertController.errorAlertControllerWithTitle("Login Failed", message: "Please check your email and password and try again.")
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func pressCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func pressSubmitButton(sender: UIButton) {
        submitForm()
    }
    
    @IBAction func pressFacebookButton(sender: UIButton) {
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
                    session.authorizeWithFacebook(token: result.token, callback: { (success) -> Void in
                        if success {
                            self.performSegueWithIdentifier("LoginFromSignIn", sender: self)
                        }
                    })
                }
            }
        })
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            return passwordField.becomeFirstResponder()
        case passwordField:
            return passwordField.resignFirstResponder()
        default:
            return false
        }
    }
    
    // MARK: - Keyboard Delegate Methods
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 10
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 20
        })
    }
}