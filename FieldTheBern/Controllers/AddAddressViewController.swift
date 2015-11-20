//
//  AddAddressViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/4/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddAddressViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, SubmitButtonDelegate {

    var previousLocation: CLLocation?
    var location: CLLocation?
    var placemark: CLPlacemark?
    var previousPlacemark: CLPlacemark?
    var address: Address?
    var people: [Person]?
    
    var addressString: String {
        get {
            let street = streetAddress.text
            let number = apartmentNumber.text
            
            switch (street, number) {
            case let (street?, number?):
                return street + " " + number
            case let (street?, nil):
                return street
            case let (nil, number?):
                return number
            case (nil, nil):
                return ""
            }
        }
    }
    
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var addressActivityContainer: UIView!
    
    @IBOutlet weak var streetAddress: PaddedTextField! {
        didSet {
            streetAddress.attributedPlaceholder = NSAttributedString(string: "Street Address", attributes: Text.PlaceholderAttributes)
            streetAddress.font = Text.Font
            streetAddress.delegate = self
        }
    }
    
    @IBOutlet weak var apartmentNumber: PaddedTextField! {
        didSet {
            apartmentNumber.attributedPlaceholder = NSAttributedString(string: "Apt / Suite / Other", attributes: Text.PlaceholderAttributes)
            apartmentNumber.font = Text.Font
            apartmentNumber.delegate = self
        }
    }

    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pressSubmitAddress(sender: UIButton) {

        
        if (streetAddress.text!.isEmpty) {
            
            let alert = UIAlertController.errorAlertControllerWithTitle("Missing Address Info", message: "Please enter a street address.")            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let alert = UIAlertController(title: "Verify Address", message: "\n\(addressString)\n\nAre you sure this is the right address? GPS is not 100% accurate.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
        }
        let OKAction = UIAlertAction(title: "Submit", style: .Default) { (action) in
            self.submitForm()
        }
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
        
        // Set submit button's submitting state
        submitButton.setTitle("Verifying Address".uppercaseString, forState: UIControlState.Disabled)
        submitButton.setBackgroundImage(UIImage.imageFromColor(Color.Gray), forState: UIControlState.Disabled)
        
        placemark = previousPlacemark
        
        if locationNeedsUpdating() {
            self.addressIsLoading()
            if let currentLocation = location {
                geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                    if let placemarksArray = placemarks {
                        if placemarksArray.count > 0 {
                            let pm = placemarks![0] as CLPlacemark
                            self.placemark = pm
                            NSNotificationCenter.defaultCenter().postNotificationName("placemarkUpdated", object: self, userInfo: ["placemark": pm])
                            self.updateAddressField()
                            self.addressDidLoad()
                        }
                    }
                }
            }
        } else {
            self.updateAddressField()
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            if(identifier == "SubmitAddress") {
                let conversationViewController = segue.destinationViewController as? ConversationViewController
                conversationViewController?.location = self.location
                conversationViewController?.placemark = self.placemark
                if let people = self.people {
                    conversationViewController?.people = people
                }
                conversationViewController?.address = self.address
            }
        }

    }
    
    // MARK: - Submit Button Methods
    
    func isSubmitting() {
        submitButton.enabled = false
    }
    
    func finishedSubmittingWithError(error: APIError) {
        
        let errorTitle = error.errorTitle
        let errorMessage = error.errorDescription
        
        let alert = UIAlertController.errorAlertControllerWithTitle(errorTitle, message: errorMessage)
        
        presentViewController(alert, animated: true, completion: nil)

        submitButton.enabled = true
    }
    
    // MARK: - TouchesEnded
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case streetAddress:
            return apartmentNumber.becomeFirstResponder()
        case apartmentNumber:
            return apartmentNumber.resignFirstResponder()
        default:
            return false
        }
    }
    
    // MARK: - Location updating methods
    
    func didLocationChange() -> Bool {
        
        if let currentLocation = location, previousLocation = previousLocation {
            
            if currentLocation.distanceFromLocation(previousLocation) >= 1 {
                return true
            }
        }
        return false
    }
    
    func locationNeedsUpdating() -> Bool {
        return didLocationChange() || self.placemark == nil
    }
    
    func updateAddressField() {
        if let placemark = self.placemark {
            if let thoroughfare = placemark.thoroughfare,
                let subThoroughfare = placemark.subThoroughfare {
                    self.streetAddress.text = "\(subThoroughfare) \(thoroughfare)"
            }
        }
    }
    
    func addressIsLoading() {
        self.addressActivityContainer.hidden = false
        self.streetAddress.enabled = false
        self.apartmentNumber.enabled = false
    }
    
    func addressDidLoad() {
        self.addressActivityContainer.hidden = true
        self.streetAddress.enabled = true
        self.apartmentNumber.enabled = true
    }
    
    // MARK: - Submitting form
    
    func submitForm() {

        if (streetAddress.text != "") {
            
            if let location = self.location, let placemark = self.placemark {
                
                isSubmitting()
                
                let address = Address(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, street1: streetAddress.text, street2: apartmentNumber.text, city: placemark.locality, stateCode: placemark.administrativeArea, zipCode: placemark.postalCode, bestResult: .NotVisited, lastResult: .Unknown)
                
                AddressService().getAddress(address, callback: { (returnedAddress, people, success, error) -> Void in
                    
                    if success {
                        if returnedAddress != nil {
                            self.people = people
                            self.address = returnedAddress
                        } else {
                            self.address = address
                        }
                       
                        if let lastVisited = self.address?.visitedAt
                        {
                            if(NSDate().hoursFrom(lastVisited) <= 24)
                            {
                                let alert = UIAlertController.errorAlertControllerWithTitle("Already visited", message: "This address has already been canvassed. Please try another location.")
                                self.presentViewController(alert, animated: true, completion: nil)
                                self.submitButton.enabled = true

                                return
                            }
                        }
                        
                        self.performSegueWithIdentifier("SubmitAddress", sender: self)
                    } else {
                        if let error = error {
                            self.finishedSubmittingWithError(error)
                        }
                    }
                })
            }
        }
    }


}
