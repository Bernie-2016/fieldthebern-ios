//
//  PersonDetailsViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    
    var person: Person?
    var personIndexPath: NSIndexPath?
    var returnedPerson: Person?
    var delegate: AddOrEditPersonDelegate?
    var editingPerson: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        if self.person != nil { // We were passed a person, so we're editing
            self.editingPerson = true
        }
        
        if self.editingPerson {
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
        let alert = UIAlertController(title: "Cancel", message: "You'll lose any edits you've made.", preferredStyle: UIAlertControllerStyle.Alert)
        
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
            if identifier == "PersonDetailsEmbedSegue" {
                let personDetailsTableViewController = segue.destinationViewController as? PersonDetailsTableViewController
                personDetailsTableViewController?.person = self.person
                self.delegate = personDetailsTableViewController
            }
            
            if identifier == "UnwindToConversationTableSegue" {
                if let conversationViewController = segue.destinationViewController as? ConversationViewController {
                    print(self.editingPerson, self.returnedPerson, self.personIndexPath)
                    if self.editingPerson {
                        if let person = self.returnedPerson,
                            let indexPath = self.personIndexPath {
                                conversationViewController.updatePerson(person, indexPath: indexPath)
                        }
                    } else {
                        if let person = self.returnedPerson {
                            conversationViewController.addPerson(person)
                        }
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "UnwindToConversationTableSegue" {
            if let returnedPerson = self.delegate?.willSubmit() {
                self.returnedPerson = returnedPerson
                if let firstName = returnedPerson.firstName,
                    let lastName = returnedPerson.lastName {
                        if firstName != ""
                            && returnedPerson.partyAffiliation != .Unknown
                            && returnedPerson.canvasResponse != .Unknown {
                                // We have all the details we need
                                return true
                        } else {
                            print("We're missing details")
                            return false
                        }
                }
            }
        }
        
        return true
    }
}
