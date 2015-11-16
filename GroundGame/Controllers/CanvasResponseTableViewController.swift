//
//  CanvassResponseTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class CanvassResponseTableViewController: UITableViewController {
    
    let canvass_Options = CanvassResponseList().options

    var delegate: CanvassResponseOptionSelectionDelegate?
    var canvass_Option: CanvassResponseOption?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for (index, option) in canvass_Options.enumerate() {
            if option.canvass_ == canvass_Option?.canvass_ {
                let rowToSelect = NSIndexPath(forRow: index, inSection: 0)
                tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None)
                self.tableView(self.tableView, didSelectRowAtIndexPath: rowToSelect)
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return canvass_Options.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CanvassResponseCell") as! CheckableTableViewCell
        
        let option = canvass_Options[indexPath.row]
        
        cell.checked = false
        cell.label.text = option.title
        cell.label.textColor = option.textColor
        cell.backgroundColor = option.backgroundColor
        cell.checkImage.highlightedImage = option.checkImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckableTableViewCell
        
        cell.checked = true
        
        let option = canvass_Options[indexPath.row]

        canvass_Option = option
        delegate?.didSelectCanvassResponseOption(option)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckableTableViewCell
        
        if cell.checked {
            cell.checked = false
        }
    }

}
