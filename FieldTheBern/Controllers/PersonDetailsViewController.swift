//
//  PersonDetailsViewController.swift
//  FieldTheBern
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
    
        switch identifier {
    
            case "PersonDetailsEmbedSegue":
                return true
        
            case "UnwindToConversationTableSegue":
                
                guard let returnedPerson = self.delegate?.willSubmit() else
                {
                    print("should not happen");
                    break
                }

                guard let firstName = returnedPerson.firstName where firstName.characters.count > 0 else { self.showValidationError("Missing first name", message: "Make sure to enter the person's first name."); break }

                if returnedPerson.partyAffiliation == .Unknown {
                    self.showValidationError("Missing party affiliation", message: "Make sure to enter the person's party affiliation.")
                    return false
                }
                
                if returnedPerson.canvassResponse == .Unknown {
                    self.showValidationError("Missing canvas response", message: "Make sure to enter how the person felt about Bernie.")
                    return false
                }

                if let email = returnedPerson.email {
                    guard email.isValidEmail else { self.showValidationError("Invalid email", message: "Double-check the email you entered."); break }
                    
                }
                                
                let hasEmailOrPhone = returnedPerson.email != nil || returnedPerson.phone != nil
                if hasEmailOrPhone {
                    guard let preferredContactMethod = returnedPerson.preferredContactMethod where preferredContactMethod == "phone" || preferredContactMethod == "email" else {
                        self.showValidationError("Missing preferred contact method", message: "Make sure to enter the person's preferred contact method.")
                        break
                    }
                    
                    if(preferredContactMethod == "phone")
                    {
                        if(!(returnedPerson.phone!.characters.count == 16 || returnedPerson.phone!.characters.count == 14))
                        {
                            self.showValidationError("Invalid phone", message: "Double-check the phone number you entered")
                            break;
                        }
                    }
                }
                return true
            
            default:
                return false
        }
        
        return false
    }
    
    func showValidationError(title: String, message: String) {
        let alert = UIAlertController.errorAlertControllerWithTitle(title, message: message)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
