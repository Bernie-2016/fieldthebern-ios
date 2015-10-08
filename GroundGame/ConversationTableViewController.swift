//
//  ConversationTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class ConversationTableViewController: UITableViewController, UITextFieldDelegate {
    
    var location: CLLocation?
    var placemark: CLPlacemark?

    @IBOutlet weak var timerLabel: UILabel!
    
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

    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var stateTypeAndStatusLabel: UILabel!
    @IBOutlet weak var stateDateLabel: UILabel!
    @IBOutlet weak var stateDetailsLabel: UILabel!
    @IBOutlet weak var stateDeadlineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyle.White

        startTimer()
        let states = States()
        if let pm = placemark {
            if let stateName = pm.administrativeArea {
                print(stateName)
                if let state = states.find(stateName as String) {
                    stateImage.image = state.icon
                    if let type = state.type,
                        let status = state.status {
                            stateTypeAndStatusLabel.text = "\(status) \(type)"
                    }
                    stateNameLabel.text = state.name
                    if let deadline = state.deadline {
                        stateDeadlineLabel.text = "Registration Deadline: \(deadline)"
                    }
                    if let date = state.date {
                        stateDateLabel.text = "on \(date)"
                    }
                    stateDetailsLabel.text = state.details
                }
            }
        }
    }

    var startTime = NSTimeInterval()
    var cachedElapsedTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var timer = NSTimer()
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        elapsedTime = currentTime - startTime
        cachedElapsedTime = elapsedTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        dispatch_async(dispatch_get_main_queue()) {
            self.timerLabel.text = "\(strMinutes):\(strSeconds)"
        }
        
    }
    
    func startTimer() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTime", userInfo: nil, repeats: true)
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
