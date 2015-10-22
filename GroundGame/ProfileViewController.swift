//
//  ProfileViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/1/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the fonts for the segmented control
        let medium = [NSFontAttributeName: UIFont(name: "Lato-Medium", size: 13.0)!]
        let heavy = [NSFontAttributeName: UIFont(name: "Lato-Heavy", size: 13.0)!]
        UISegmentedControl.appearance().setTitleTextAttributes(medium, forState: .Normal)
        UISegmentedControl.appearance().setTitleTextAttributes(heavy, forState: .Selected)
        
        // Set the styles for the leaderboard table view
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @IBAction func logout(sender: UIButton) {
        let session = Session.sharedInstance
        session.logout()
        self.performSegueWithIdentifier("Logout", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScoreSectionHeader")
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserScoreCell") as! UserScoreTableViewCell
        return cell
    }

}
