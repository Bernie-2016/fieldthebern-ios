//
//  HowToCanvassTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 11/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class HowToCanvassTableViewController: UITableViewController {

    var items = []
    var selectedItem = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()

        if let path = NSBundle.mainBundle().pathForResource("Canvassing", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) {
                self.items = array
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
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HowToCanvassCell", forIndexPath: indexPath) as! HowToCanvassTableViewCell
        
        if let item = items[indexPath.row] as? NSDictionary {
            if let title = item["title"] as? String {
                cell.titleLabel.text = title
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dictionary = items[indexPath.row] as? NSDictionary {
            selectedItem = dictionary
        }
        
        self.performSegueWithIdentifier("CanvassItemDetail", sender: self)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CanvassItemDetail" {
            if let destinationVC = segue.destinationViewController as? HowToCanvassItemDetailTableViewController {
                destinationVC.dictionary = selectedItem
            }
        }
    }


}
