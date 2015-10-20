//
//  AddAddressContainerViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/4/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class AddAddressContainerViewController: UIViewController, SubmitButtonDelegate {

    var addAddressTableViewController: AddAddressTableViewController?

    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pressSubmitAddress(sender: UIButton) {
        if let addAddressTableViewController = addAddressTableViewController {
            let alert = UIAlertController(title: "Verify Address", message: "\n\(addAddressTableViewController.addressString)\n\nAre you sure this is the right address? GPS is not 100% accurate.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
                
            }
            let OKAction = UIAlertAction(title: "Submit", style: .Default) { (action) in
                // Return to map
                addAddressTableViewController.submitForm()
            }
            alert.addAction(cancelAction)
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
        
        // Set submit button's submitting state
        submitButton.setTitle("Verifying Address".uppercaseString, forState: UIControlState.Disabled)
        submitButton.setBackgroundImage(UIImage.imageFromColor(Color.Gray), forState: UIControlState.Disabled)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if(identifier == "AddAddressEmbedSegue") {
                addAddressTableViewController = segue.destinationViewController as? AddAddressTableViewController
                if let navigationController = self.navigationController as? AddAddressNavigationController {
                    addAddressTableViewController?.location = navigationController.location
                    addAddressTableViewController?.delegate = self
                }
            }
        }
    }
    
    // MARK: - SubmitButtonDelegate Protocol Methods
    
    func isSubmitting() {
        submitButton.enabled = false
    }
    
    func finishedSubmittingWithError(errorMessage: String) {
        let alert = UIAlertController(title: "Missing Address Information", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
        alert.addAction(alertAction)
        
        presentViewController(alert, animated: true) { () -> Void in }

        submitButton.enabled = true
    }

}
