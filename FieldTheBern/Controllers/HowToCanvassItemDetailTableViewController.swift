//
//  HowToCanvassItemDetailTableViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class HowToCanvassItemDetailTableViewController: UITableViewController {
    
    var dictionary: NSDictionary = NSDictionary()
    var items = []
    var type = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the title
        self.title = dictionary["title"] as? String
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        self.edgesForExtendedLayout = UIRectEdge.None

        if let type = dictionary["type"] as? String {
            self.type = type
            
            switch self.type {
            case "paragraph":
                if let items = dictionary["items"] as? [String] {
                    self.items = items
                }
            case "list":
                if let items = dictionary["items"] as? [String] {
                    self.items = items
                }
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return cellForType(self.type, tableView: tableView, indexPath: indexPath)
    }
    
    func cellForType(type: String, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        switch type {
        case "paragraph":
            let cell = tableView.dequeueReusableCellWithIdentifier("ParagraphCell", forIndexPath: indexPath) as! ParagraphTableViewCell
            
            cell.paragraphLabel.text = items[indexPath.row] as? String
            
            return cell
        case "list":
            let cell = tableView.dequeueReusableCellWithIdentifier("ParagraphCell", forIndexPath: indexPath) as! ParagraphTableViewCell
            
            if let text = items[indexPath.row] as? String {
                cell.paragraphLabel.text = "• " + text
            }
            
            return cell
        case "switch":
            let cell = tableView.dequeueReusableCellWithIdentifier("SegmentCell", forIndexPath: indexPath)

            return cell
        default:
            return UITableViewCell()
        }
    }
}
