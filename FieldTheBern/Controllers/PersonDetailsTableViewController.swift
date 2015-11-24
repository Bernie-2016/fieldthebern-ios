//
//  PersonDetailsTableViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class PersonDetailsTableViewController: UITableViewController, UITextFieldDelegate, PartySelectionDelegate, CanvassResponseOptionSelectionDelegate, AddOrEditPersonDelegate {
    
    var person: Person?
    var partySelection: PartyAffiliation?
    var canvassResponseOption: CanvassResponseOption?

    @IBOutlet weak var firstNameField: PaddedTextField! {
        didSet {
            firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: Text.PlaceholderAttributes)
            firstNameField.font = Text.Font
            firstNameField.delegate = self
        }
    }
    
    @IBOutlet weak var lastNameField: PaddedTextField! {
        didSet {
            lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name (optional)", attributes: Text.PlaceholderAttributes)
            lastNameField.font = Text.Font
            lastNameField.delegate = self
        }
    }
    
    @IBOutlet weak var emailField: PaddedTextField! {
        didSet {
            emailField.attributedPlaceholder = NSAttributedString(string: "Email (optional)", attributes: Text.PlaceholderAttributes)
            emailField.font = Text.Font
            emailField.delegate = self
        }
    }
    
    @IBOutlet weak var phoneField: PaddedTextField! {
        didSet {
            phoneField.attributedPlaceholder = NSAttributedString(string: "Phone (optional)", attributes: Text.PlaceholderAttributes)
            phoneField.font = Text.Font
            phoneField.delegate = self
        }
    }
    
    @IBOutlet weak var phoneSwitch: UISwitch!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var previouslyParticipatedSwitch: UISwitch!
    @IBOutlet weak var askedToLeaveSwitch: UISwitch!
    
    func backToNameField(sender: UIBarButtonItem) {
        lastNameField.becomeFirstResponder()
    }

    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var canvassResponseLabel: UILabel!
    @IBOutlet weak var canvassResponseCell: UITableViewCell!
    @IBOutlet weak var canvassResponseDisclosure: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)

        if let person = self.person { // We were passed a person, so we're editing
            
            // Set their first name
            if let firstName = person.firstName {
                firstNameField.text = firstName
            }
            // Set their last name
            if let lastName = person.lastName {
                lastNameField.text = lastName
            }
            // Select their party affiliation
            self.didSelectParty(person.partyAffiliation)

            // Select their canvas response
            let personCanvassResponse = CanvassResponseOption(canvassResponse: person.canvassResponse)
            self.didSelectCanvassResponseOption(personCanvassResponse)
            
            // Set their phone
            if let phone = person.phone {
                phoneField.text = phone
                
                // Enable the switch since their phone was already entered
                phoneSwitch.userInteractionEnabled = true
            }
            
            // Set their email
            if let email = person.email {
                emailField.text = email
                
                // Enable the switch since their email was already entered
                emailSwitch.userInteractionEnabled = true
            }
            
            // Set the preferred contact method
            if let preferredContactMethod = person.preferredContactMethod {
                if preferredContactMethod == "phone" {
                    phoneSwitch.setOn(true, animated: false)
                }
                if preferredContactMethod == "email" {
                    emailSwitch.setOn(true, animated: false)
                }
            }
            
            // Set their previously participated information
            if let previouslyParticipatedInCaucusOrPrimary = person.previouslyParticipatedInCaucusOrPrimary {
                previouslyParticipatedSwitch.setOn(previouslyParticipatedInCaucusOrPrimary, animated: false)
            }
        } else {
            // We have no person, but we need a new one to save changes to
            self.person = Person()
        }
        
        self.addDoneButtonOnKeyboard()
    }
    
    // MARK: - Text Field Delegate Methods
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("hideKeyboard"))
        
        var items:[UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.phoneField.inputAccessoryView = doneToolbar
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case firstNameField:
            scrollToField(firstNameField)
        case lastNameField:
            scrollToField(lastNameField)
        case emailField:
            scrollToField(emailField)
        case phoneField:
            scrollToField(phoneField)
        default:
            break
        }
    }
    
    func scrollToField(textField: UITextField) {
        if let cell = textField.superview?.superview as? UITableViewCell,
            let indexPath = tableView.indexPathForCell(cell) {
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // We need to update the person's name
        switch textField {
        case firstNameField:
            self.person?.firstName = firstNameField.text
        case lastNameField:
            self.person?.lastName = lastNameField.text
            
        case emailField:
            if(emailField.text?.characters.count < 1 && emailSwitch.on)
            {
                emailSwitch.setOn(false, animated: true)
            }
            
        case phoneField:
            if(phoneField.text?.characters.count < 1 && phoneSwitch.on)
            {
                phoneSwitch.setOn(false, animated: true)
            }
        default:
            break
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            return lastNameField.becomeFirstResponder()
        case lastNameField:
            return emailField.becomeFirstResponder()
        case emailField:
            return phoneField.becomeFirstResponder()
        case phoneField:
            return phoneField.resignFirstResponder()
        default:
            return false
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        if textField == emailField {
            if let text = textField.text {
                let newString = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
                print(newString)
                if(newString.characters.count > 0) {
                    emailSwitch.userInteractionEnabled = true
                } else {
                    emailSwitch.userInteractionEnabled = false
                }
            }
        }
        
        
        if textField == phoneField {
            if let text = textField.text {
                let newString = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
                
                if(newString.characters.count > 0) {
                    phoneSwitch.userInteractionEnabled = true
                } else {
                    phoneSwitch.userInteractionEnabled = false
                }
                
                let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                
                let decimalString = components.joinWithSeparator("") as NSString
                let length = decimalString.length
                
                let hasLeadingOne = length > 0 && newString[newString.startIndex] == "1"
                
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                    let newLength = (text as NSString).length + (string as NSString).length - range.length as Int
                    
                    return (newLength > 10) ? false : true
                }
                
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne && !(range.location == 1 && range.length == 1) {
                    let leadingOne = decimalString.substringWithRange(NSMakeRange(index, 1))
                    formattedString.appendFormat("%@ ", leadingOne)
                    index += 1
                }
                
                if (length - index) > 3 {
                    let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("(%@) ", areaCode)
                    index += 3
                }
                
                if length - index > 3 {
                    let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
                
                let remainder = decimalString.substringFromIndex(index)
                formattedString.appendString(remainder)
                textField.text = formattedString as String
                
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }

    
    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        self.tableView.superview?.endEditing(true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let additionalSeparatorThickness = CGFloat(1)
        let additionalSeparator = UIView(frame: CGRectMake(0,
            cell.frame.size.height - additionalSeparatorThickness,
            cell.frame.size.width,
            additionalSeparatorThickness))
        additionalSeparator.backgroundColor = Color.Blue
        cell.addSubview(additionalSeparator)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hideKeyboard()

        if indexPath.row == 2 {
            self.performSegueWithIdentifier("PersonDetailsPartySegue", sender: self)
        }
        
        if indexPath.row == 3 {
            self.performSegueWithIdentifier("CanvassResponseSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "PersonDetailsPartySegue" {
            if let partyAffiliationViewController = segue.destinationViewController as? PartyAffiliationTableViewController {
                partyAffiliationViewController.delegate = self
                partyAffiliationViewController.partySelection = partySelection
            }
        }
        
        if segue.identifier == "CanvassResponseSegue" {
            if let canvassResponseViewController = segue.destinationViewController as? CanvassResponseTableViewController {
                canvassResponseViewController.delegate = self
                canvassResponseViewController.canvassResponseOption = canvassResponseOption
            }
        }
    }
    
    func didSelectParty(partySelection: PartyAffiliation) {
        // Update the person we're returning
        self.person?.partyAffiliation = partySelection
        
        self.partySelection = partySelection
        partyLabel.text = partySelection.title()
    }
    
    func didSelectCanvassResponseOption(canvassResponseOption: CanvassResponseOption) {
        // Update the person we're returning
        self.person?.canvassResponse = canvassResponseOption.canvassResponse
        
        self.canvassResponseOption = canvassResponseOption
        self.canvassResponseLabel.text = canvassResponseOption.title
        self.canvassResponseLabel.textColor = canvassResponseOption.textColor
        self.canvassResponseCell.backgroundColor = canvassResponseOption.backgroundColor
        self.canvassResponseDisclosure.image = canvassResponseOption.disclosureImage
    }
    
    
    @IBAction func tappedPhoneSwitch() {
        if(emailField.text?.characters.count > 0) {
            emailSwitch.setOn(!phoneSwitch.on, animated: true)
        }
    }
    
    @IBAction func tappedEmailSwitch() {
        if(phoneField.text?.characters.count > 0) {
            phoneSwitch.setOn(!emailSwitch.on, animated: true)
        }
    }
    
    func willSubmit() -> Person? {
        if !firstNameField.text!.isEmpty { self.person?.firstName = firstNameField.text }
        if !lastNameField.text!.isEmpty { self.person?.lastName = lastNameField.text }
        
        self.person?.phone = phoneField.text
        self.person?.email = emailField.text
        
        //if !phoneField.text!.isEmpty { self.person?.phone = phoneField.text }
        //if !emailField.text!.isEmpty { self.person?.email = emailField.text }
        
        if emailSwitch.on {
            self.person?.preferredContactMethod = "email"
        } else if phoneSwitch.on {
            self.person?.preferredContactMethod = "phone"
        } else {
            self.person?.preferredContactMethod = nil
        }
        
        self.person?.previouslyParticipatedInCaucusOrPrimary = previouslyParticipatedSwitch.on
        
        self.person?.atHomeStatus = true
        self.person?.askedToLeave = askedToLeaveSwitch.on
        
        return self.person
    }
    
    func showValidationError(title: String, message: String) {
        let alert = UIAlertController.errorAlertControllerWithTitle(title, message: message)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
