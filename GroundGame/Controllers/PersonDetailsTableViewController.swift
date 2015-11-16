//
//  PersonDetailsTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class PersonDetailsTableViewController: UITableViewController, UITextFieldDelegate, PartySelectionDelegate, CanvasResponseOptionSelectionDelegate, AddOrEditPersonDelegate {
    
    var person: Person?
    var partySelection: PartyAffiliation?
    var canvasResponseOption: CanvasResponseOption?

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
    @IBOutlet weak var canvasResponseLabel: UILabel!
    @IBOutlet weak var canvasResponseCell: UITableViewCell!
    @IBOutlet weak var canvasResponseDisclosure: UIImageView!
    
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
            let personCanvasResponse = CanvasResponseOption(canvasResponse: person.canvasResponse)
            self.didSelectCanvasResponseOption(personCanvasResponse)
            
            // Set their phone
            if let phone = person.phone {
                phoneField.text = phone
            }
            
            // Set their email
            if let email = person.email {
                emailField.text = email
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
    }
    
    // MARK: - Text Field Delegate Methods
    
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
        if let cell = textField.superview?.superview?.superview as? UITableViewCell,
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
        if textField == phoneField
        {
            if let text = textField.text {
                let newString = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
                let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                
                let decimalString = components.joinWithSeparator("") as NSString
                let length = decimalString.length
                
                let hasLeadingOne = length > 0 && newString[newString.startIndex] == "1"
                
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
                {
                    let newLength = (text as NSString).length + (string as NSString).length - range.length as Int
                    
                    return (newLength > 10) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne && !(range.location == 1 && range.length == 1)
                {
                    let leadingOne = decimalString.substringWithRange(NSMakeRange(index, 1))
                    formattedString.appendFormat("%@ ", leadingOne)
                    index += 1
                }
                
                if (length - index) > 3
                {
                    let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("(%@) ", areaCode)
                    index += 3
                }
                if length - index > 3
                {
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "PersonDetailsPartySegue" {
            if let partyAffiliationViewController = segue.destinationViewController as? PartyAffiliationTableViewController {
                partyAffiliationViewController.delegate = self
                partyAffiliationViewController.partySelection = partySelection
            }
        }
        if segue.identifier == "CanvasResponseSegue" {
            if let canvasResponseViewController = segue.destinationViewController as? CanvasResponseTableViewController {
                canvasResponseViewController.delegate = self
                canvasResponseViewController.canvasResponseOption = canvasResponseOption
            }
        }
    }
    
    func didSelectParty(partySelection: PartyAffiliation) {
        // Update the person we're returning
        self.person?.partyAffiliation = partySelection
        
        self.partySelection = partySelection
        partyLabel.text = partySelection.title()
    }
    
    func didSelectCanvasResponseOption(canvasResponseOption: CanvasResponseOption) {
        // Update the person we're returning
        self.person?.canvasResponse = canvasResponseOption.canvasResponse
        
        self.canvasResponseOption = canvasResponseOption
        self.canvasResponseLabel.text = canvasResponseOption.title
        self.canvasResponseLabel.textColor = canvasResponseOption.textColor
        self.canvasResponseCell.backgroundColor = canvasResponseOption.backgroundColor
        self.canvasResponseDisclosure.image = canvasResponseOption.disclosureImage
    }
    
    
    @IBAction func tappedPhoneSwitch() {
        emailSwitch.setOn(!phoneSwitch.on, animated: true)
    }
    
    @IBAction func tappedEmailSwitch() {
        phoneSwitch.setOn(!emailSwitch.on, animated: true)
    }
    
    func willSubmit() -> Person? {
        if !firstNameField.text!.isEmpty { self.person?.firstName = firstNameField.text }
        if !lastNameField.text!.isEmpty { self.person?.lastName = lastNameField.text }
        if !phoneField.text!.isEmpty { self.person?.phone = phoneField.text }
        if !emailField.text!.isEmpty { self.person?.email = emailField.text }
        
        if emailSwitch.on && !emailField.text!.isEmpty {
            self.person?.preferredContactMethod = "email"
        }
        
        if phoneSwitch.on && !phoneField.text!.isEmpty {
            self.person?.preferredContactMethod = "phone"
        }
        
        self.person?.previouslyParticipatedInCaucusOrPrimary = previouslyParticipatedSwitch.on
        
        self.person?.atHomeStatus = true
        self.person?.askedToLeave = askedToLeaveSwitch.on

        return self.person
    }
    
}
