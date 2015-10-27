//
//  CanvasResponseTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class CanvasResponseTableViewController: UITableViewController {
    
    let canvasResponseOptions = CanvasResponseList().options

    var delegate: CanvasResponseOptionSelectionDelegate?
    var canvasResponseOption: CanvasResponseOption?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for (index, option) in canvasResponseOptions.enumerate() {
            if option.canvasResponse == canvasResponseOption?.canvasResponse {
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
        return canvasResponseOptions.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CanvasResponseCell") as! CheckableTableViewCell
        
        let option = canvasResponseOptions[indexPath.row]
        
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
        
        let option = canvasResponseOptions[indexPath.row]

        canvasResponseOption = option
        delegate?.didSelectCanvasResponseOption(option)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CheckableTableViewCell
        
        if cell.checked {
            cell.checked = false
        }
    }

}
