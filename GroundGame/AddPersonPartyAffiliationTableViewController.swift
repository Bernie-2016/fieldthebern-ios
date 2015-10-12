//
//  AddPersonPartyAffiliationTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class AddPersonPartyAffiliationTableViewController: UITableViewController {
    
    let partyOptions = PartySelectionList().options

    var delegate: PartySelectionDelegate?
    var partySelection: PartySelection?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for (index, option) in partyOptions.enumerate() {
            if option.partyAffiliation == partySelection?.partyAffiliation {
                let rowToSelect = NSIndexPath(forRow: index, inSection: 0)
                tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
                self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect)
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyOptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PartyCell") as! CheckableTableViewCell

        let partyOption = partyOptions[indexPath.row]

        cell.checked = false
        
        cell.label.text = partyOption.title
        
        return cell
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckableTableViewCell
        
        cell.checked = true
        
        let partySelection = partyOptions[indexPath.row]
        delegate?.didSelectParty(partySelection)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckableTableViewCell
        
        print(cell.checked)
        if cell.checked {
            cell.checked = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            partySelection = partyOptions[indexPath.row]
        }
    }

}
