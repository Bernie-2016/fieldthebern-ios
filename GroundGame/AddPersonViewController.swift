//
//  AddPersonViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class AddPersonViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        if self.person != nil { // We were passed a person, so we're editing
            self.title = "Edit Person"
            self.submitButton.setTitle("Save Person".uppercaseString, forState: .Normal)
        } else { // We weren't passed a person, so we're adding
            self.title = "Add Person"
            self.submitButton.setTitle("Add Person".uppercaseString, forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
    }
    
    func cancel(sender: UINavigationItem) {
        let alert = UIAlertController(title: "Cancel", message: "You'll lose all your progress.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Undo", style: .Cancel) { (_) in }
        let OKAction = UIAlertAction(title: "OK", style: .Destructive) { (action) in
            // Return to map
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if(identifier == "AddPersonEmbedSegue") {
                let addPersonTableViewController = segue.destinationViewController as? AddPersonTableViewController
                addPersonTableViewController?.person = self.person
            }
        }
    }

}
