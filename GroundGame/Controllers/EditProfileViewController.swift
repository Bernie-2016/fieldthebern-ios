//
//  EditProfileViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 11/1/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var firstNameField: PaddedTextField! {
        didSet {
            firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: Text.PlaceholderAttributes)
            firstNameField.font = Text.Font
            firstNameField.delegate = self
        }
    }
    
    @IBOutlet weak var lastNameField: PaddedTextField! {
        didSet {
            lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: Text.PlaceholderAttributes)
            lastNameField.font = Text.Font
            lastNameField.delegate = self
        }
    }
    
    @IBOutlet weak var emailField: PaddedTextField! {
        didSet {
            emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: Text.PlaceholderAttributes)
            emailField.font = Text.Font
            emailField.delegate = self
        }
    }
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadUser()
    }
    
    func showActivityIndicator() {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        activityView.startAnimating()
        activityView.hidden = false

        let loadingView = UIBarButtonItem(customView: activityView)
        
        self.navigationItem.rightBarButtonItem =  loadingView
    }
    
    func showCancelButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "pressDone:")
    }
    
    func loadUser() {
        showActivityIndicator()
        
        UserService().me { (user, success, error) -> Void in
            if success {
                if let user = user {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.loadingView.hidden = true
                        self.firstNameField.text = user.firstName
                        self.lastNameField.text = user.lastName
                        self.emailField.text = user.email
                        self.showCancelButton()
                    })
                }
            } else {
                if let error = error {
                    self.handleError(error)
                }
            }
                
        }
    }

    @IBAction func pressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pressDone(sender: AnyObject) {
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let email = emailField.text
        
        if (firstName!.isEmpty || lastName!.isEmpty || !email!.isValidEmail) {
            let alert = UIAlertController.errorAlertControllerWithTitle("Missing Information", message: "You can't leave any fields blank.")
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let json = UserJSON(firstName: firstName, lastName: lastName, email: email)

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            UserService().editMe(json) { (user, success, error) -> Void in
                if success {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                if let apiError = error {
                    self.handleError(apiError)
                }
            }
        }
    }
        
    // MARK: - Error Handling
    
    func handleError(error: APIError) {
        let errorTitle = error.errorTitle
        let errorMessage = error.errorDescription
        
        let alert = UIAlertController.errorAlertControllerWithTitle(errorTitle, message: errorMessage)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            return lastNameField.becomeFirstResponder()
        case lastNameField:
            return emailField.becomeFirstResponder()
        case emailField:
            return emailField.resignFirstResponder()
        default:
            return false
        }
    }
}
