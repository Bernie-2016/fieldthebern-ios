//
//  AddAddressContainerViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/4/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class AddAddressContainerViewController: UIViewController, SubmitButtonDelegate {

    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pressSubmitAddress(sender: UIButton) {
        print("pressed")
        addAddressTableViewController?.submitForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
        
        submitButton.setTitle("Verifying Address".uppercaseString, forState: UIControlState.Disabled)
        submitButton.setBackgroundImage(UIImage.imageFromColor(Color.Gray), forState: UIControlState.Disabled)
    }
    
    var addAddressTableViewController: AddAddressTableViewController?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
