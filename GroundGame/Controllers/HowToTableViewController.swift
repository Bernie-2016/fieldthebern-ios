//
//  HowToTableViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/3/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class HowToTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.layoutMargins = UIEdgeInsetsZero
//        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
    }
}
