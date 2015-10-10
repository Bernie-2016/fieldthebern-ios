//
//  AddAddressTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/4/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddAddressTableViewController: UITableViewController, UITextFieldDelegate {
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var headerView: UIView! {
        didSet {
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let currentLocation = location {
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                if let placemarksArray = placemarks {
                    if placemarksArray.count > 0 {
                        let pm = placemarks![0] as CLPlacemark
                        self.placemark = pm
                        if let city = pm.locality,
                            let state = pm.administrativeArea,
                            let thoroughfare = pm.thoroughfare,
                            let subThoroughfare = pm.subThoroughfare,
                            let zipCode = pm.postalCode {
                                self.streetAddress.text = "\(subThoroughfare) \(thoroughfare)"
                        }
                    }
                }
            }
        }

    }
    
    func submitForm() {
        if (streetAddress.text != "") {
            let addressString = "\(streetAddress.text) \(apartmentNumber.text) \(self.placemark?.locality) \(self.placemark?.administrativeArea) \(self.placemark?.postalCode)"
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
                if let placemarksArray = placemarks {

                    if placemarksArray.count > 0 {
                        let pm = placemarks![0] as CLPlacemark
                        
                        if let streetName = pm.thoroughfare {
                            if streetName != "" {
                                self.performSegueWithIdentifier("SubmitAddress", sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if(identifier == "SubmitAddress") {
                let conversationTimerViewController = segue.destinationViewController as? ConversationTimerViewController
                conversationTimerViewController?.location = self.location
                conversationTimerViewController?.placemark = self.placemark
            }
        }
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


}
