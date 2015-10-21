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
    
    @IBOutlet weak var askedToLeaveSwitch: UISwitch!
    
    func backToNameField(sender: UIBarButtonItem) {
        lastNameField.becomeFirstResponder()
    }

    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var canvasResponseLabel: UILabel!
    @IBOutlet weak var canvasResponseCell: UITableViewCell!
    
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
        } else {
            // We have no person, but we need a new one to save changes to
            self.person = Person()
        }
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case firstNameField:
            if let cell = firstNameField.superview?.superview?.superview as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell) {
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        case lastNameField:
            if let cell = lastNameField.superview?.superview?.superview as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell) {
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        default:
            break
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
            return lastNameField.resignFirstResponder()
        default:
            return false
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
    }
    
    func willSubmit() -> Person? {
        self.person?.firstName = firstNameField.text
        self.person?.lastName = lastNameField.text
        self.person?.atHomeStatus = true
        self.person?.askedToLeave = askedToLeaveSwitch.on

        return self.person
    }
    
}
