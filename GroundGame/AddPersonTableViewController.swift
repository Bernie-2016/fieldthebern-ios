//
//  AddPersonTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class AddPersonTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: PaddedTextField! {
        didSet {
            nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: Text.PlaceholderAttributes)
            nameField.font = Text.Font
            nameField.delegate = self
        }
    }
    
    @IBOutlet weak var phoneNumberField: PaddedTextField! {
        didSet {
            phoneNumberField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: Text.PlaceholderAttributes)
            phoneNumberField.font = Text.Font
            phoneNumberField.delegate = self
            
            let keyboardDoneButtonView = UIToolbar()
            keyboardDoneButtonView.sizeToFit()
            let previousButton = UIBarButtonItem.init(title: "Previous", style: UIBarButtonItemStyle.Plain, target: self, action: "backToNameField:")
            let space = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneWithPhoneNumber:")
            keyboardDoneButtonView.setItems([previousButton, space, doneButton], animated: false)
            phoneNumberField.inputAccessoryView = keyboardDoneButtonView
            
        }
    }
    
    func backToNameField(sender: UIBarButtonItem) {
        nameField.becomeFirstResponder()
    }
    
    func doneWithPhoneNumber(sender: UIBarButtonItem) {
        phoneNumberField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case nameField:
            if let cell = nameField.superview?.superview?.superview as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell) {
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        case phoneNumberField:
            if let cell = phoneNumberField.superview?.superview?.superview as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell) {
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        default:
            break
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            return phoneNumberField.becomeFirstResponder()
        case phoneNumberField:
            return phoneNumberField.resignFirstResponder()
        default:
            return false
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberField
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

}
