//
//  SignupViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/28/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    struct Text {
        static let PlaceholderAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        static let Font = UIFont(name: "Lato-Medium", size: 18)
    }
    
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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func submitForm() {
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let email = emailField.text
        let password = passwordField.text
        
        print(firstName, lastName, email, password)
        
        spinner.startAnimating()
        submitButton.titleLabel?.layer.opacity = 0
        
        let userService = UserService()
        userService.createUser(email: email!, password: password!) { success in
            self.submitButton.titleLabel?.layer.opacity = 1
            self.spinner.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWasHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressSignUp() {
        submitForm()
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
            submitForm()
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
            self.bottomConstraint.constant = self.bottomConstraintValue!
        })
    }

}
