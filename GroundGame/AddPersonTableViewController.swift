//
//  AddPersonTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class AddPersonTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameField: PaddedTextField! {
        didSet {
            firstNameField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: Text.PlaceholderAttributes)
            firstNameField.font = Text.Font
            firstNameField.delegate = self
        }
    }
    
    @IBOutlet weak var lastNameField: PaddedTextField! {
        didSet {
            lastNameField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: Text.PlaceholderAttributes)
            lastNameField.font = Text.Font
            lastNameField.delegate = self
        }
    }
    
    func backToNameField(sender: UIBarButtonItem) {
        lastNameField.becomeFirstResponder()
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let additionalSeparatorThickness = CGFloat(1)
        let additionalSeparator = UIView(frame: CGRectMake(0,
            cell.frame.size.height - additionalSeparatorThickness,
            cell.frame.size.width,
            additionalSeparatorThickness))
        additionalSeparator.backgroundColor = Color.Blue
        cell.addSubview(additionalSeparator)
    }

}
