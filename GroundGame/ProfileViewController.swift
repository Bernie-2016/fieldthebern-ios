//
//  ProfileViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/1/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rankings: [Ranking] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"

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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getLeaderboard("friends")
        UserService().me { (user) -> Void in
            if let user = user {
                if let name = user.name {
                    self.title = name
                }
            }
        }
    }
    
    func getLeaderboard(type: String) {
        LeaderboardService().get(type, callback: { (leaderboard) -> Void in
            if let leaderboard = leaderboard {
                self.rankings = leaderboard.rankings
                self.tableView.reloadData()
            }
        })
    }

    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getLeaderboard("friends")
        case 1:
            getLeaderboard("state")
        case 2:
            getLeaderboard("everyone")
        default:
            break
        }
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
        if section == 0 {
            return rankings.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserScoreCell") as! UserScoreTableViewCell

        let ranking = rankings[indexPath.row]

        if let rank = ranking.rank {
            cell.rankLabel.text = "\(rank)"
        }
        if let scoreString = ranking.scoreString {
            cell.pointsLabel.text = scoreString
        }
        if let name = ranking.name {
            cell.nameLabel.text = "\(name)"
        }
        
        return cell
    }

}
