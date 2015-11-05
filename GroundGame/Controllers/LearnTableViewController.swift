//
//  LearnTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/27/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class LearnTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Learn"

        self.tableView.tableFooterView = UIView()
        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            self.performSegueWithIdentifier("HowToCanvass", sender: self)
        }
        if indexPath.row == 2 {
            self.performSegueWithIdentifier("ShowHowTo", sender: self)
        }
    }
}
