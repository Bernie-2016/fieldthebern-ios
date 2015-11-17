//
//  SignUpFormViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/11/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class SignUpFormViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var isFacebookSignup: Bool = false
    var photoString: String?
    var facebookToken: FBSDKAccessToken?
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var profileImage: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
        
        // Change navigation bar buttons
        let backButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
        
        // Keyboard notification listeners
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWasHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Fill out form if we have Facebook information
        firstNameField.text = firstName
        lastNameField.text = lastName
        emailField.text = email
        
        // Set profile image view to be rounded photo
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.layer.cornerRadius = 75
        
        if self.isFacebookSignup {
            // Set the button text
            self.submitButton.setTitleWithoutAnimation("FINISH SIGN UP")
            
            // Set the Facebook photo
            if let facebookId = self.facebookToken?.userID {
                let facebookPhotoURL = "https://graph.facebook.com/\(facebookId)/picture?width=1000&height=1000"
                self.profileImage.loadImageFromURLString(facebookPhotoURL)
            }
        } else {
            // Set the photo to the default thumb
            self.profileImage.image = UIImage(named: "default_thumb")
        }

    }
    
    func cancel(sender: UINavigationItem) {
        let alert = UIAlertController(title: "Cancel", message: "You'll lose any changes you've made.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Undo", style: .Cancel) { (_) in }
        let OKAction = UIAlertAction(title: "OK", style: .Destructive) { (action) in
            // Return to map
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func submitForm() {
        animateButton()

        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let email = emailField.text
        let password = passwordField.text
        
        if (firstName!.isEmpty || lastName!.isEmpty || password!.isEmpty || !email!.isValidEmail) {
            
            let alert = UIAlertController(title: "Incomplete information", message: "Please make sure to enter all details and a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (_) in}
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.stopAnimatingButton()

            return
        }
        
        if isFacebookSignup {
            signUpWithFacebook(email: email!, password: password!, firstName: firstName!, lastName: lastName!)
        } else {
            signUpWithEmail(email: email!, password: password!, firstName: firstName!, lastName: lastName!)
        }
    }
    
    func signUpWithFacebook(email email: String, password: String, firstName: String, lastName: String) {
        let userService = UserService()
        
        userService.createUser(email: email, password: password, firstName: firstName, lastName: lastName, facebookAccessToken: self.facebookToken?.tokenString, facebookId: self.facebookToken?.userID, photoString: self.photoString) { (user, success, error) -> Void in

            if success {
                let session = Session.sharedInstance
                if let token = self.facebookToken {
                    session.authorizeWithFacebook(token: token, callback: { (success) -> Void in
                        if success {
                            self.performSegueWithIdentifier("LoginFromSignUp", sender: self)
                        }
                    })
                }
            } else {
                self.stopAnimatingButton()
                if let error = error {
                    self.handleError(error)
                }
            }
        }
    }
    
    func signUpWithEmail(email email: String, password: String, firstName: String, lastName: String) {
        let userService = UserService()
        
        userService.createUser(email: email, password: password, firstName: firstName, lastName: lastName, photoString: self.photoString) { (user,success, error) in
            self.submitButton.titleLabel?.layer.opacity = 1
            if success {
                let session = Session.sharedInstance
                session.authorize(email, password: password, callback: { (success) -> Void in
                    if success {
                        self.performSegueWithIdentifier("LoginFromSignUp", sender: self)
                    } else {
                        // Handle error
                        self.stopAnimatingButton()
                    }
                })
            } else {
                self.stopAnimatingButton()
                if let error = error {
                    self.handleError(error)
                }
            }
        }
    }
    
    func animateButton() {
        spinner.startAnimating()
        submitButton.titleLabel?.layer.opacity = 0
    }
    
    func stopAnimatingButton() {
        spinner.stopAnimating()
        submitButton.titleLabel?.layer.opacity = 1
    }
    
    @IBAction func pressSignUp() {
        submitForm()
    }
    
    // MARK: - Image Picker
    
    @IBAction func tapPhoto() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.takePhoto()
        })
        let chooseAction = UIAlertAction(title: "Choose from Library", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.pickImage()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(chooseAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let resizedImage = Toucan(image: image).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image
        
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.7)
        
        self.photoString = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.profileImage.image = resizedImage
        }
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
            self.bottomConstraint.constant = keyboardFrame.size.height - self.submitButton.frame.size.height
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 0
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
    
    // MARK: - Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
