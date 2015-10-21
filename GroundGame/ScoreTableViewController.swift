//
//  ScoreTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/15/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import Spring

class ScoreTableViewController: UITableViewController {
    
    var people: [Person]?
    var visit: Visit?
    
    var peopleCount: Int {
        get {
            if let people = people {
                return people.count
            } else {
                return 0
            }
        }
    }
    
    var score = 0
    var incrementedScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0

        if let points = visit?.totalPoints {
            self.score = points
        }
        
        queue = dispatch_queue_create("myTimer", nil)
        asyncTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        dispatch_source_set_timer(asyncTimer!, DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
        
        dispatch_source_set_event_handler(asyncTimer!) {
            self.incrementScore()
        }
        
        dispatch_resume(asyncTimer!)
        
//        firstLabel.animation = "fadeInLeft"
//        firstLabel.duration = 1.5
//        secondLabel.animation = "fadeInLeft"
//        secondLabel.delay = 0.5
//        secondLabel.duration = 1.5
//        thirdLabel.animation = "fadeInLeft"
//        thirdLabel.duration = 1.5
//        thirdLabel.delay = 1.0
//        firstLabel.animate()
//        secondLabel.animate()
//        thirdLabel.animate()
//
//    
//        firstSublabel.animation = "fadeInLeft"
//        firstSublabel.duration = 1.5
//        secondSublabel.animation = "fadeInLeft"
//        secondSublabel.duration = 1.5
//        secondSublabel.delay = 0.5
//        thirdSublabel.animation = "fadeInLeft"
//        thirdSublabel.duration = 1.5
//        thirdSublabel.delay = 1.0
//        firstSublabel.animate()
//        secondSublabel.animate()
//        thirdSublabel.animate()
    }
    
    var queue: dispatch_queue_t?
    var asyncTimer: dispatch_source_t?
    var randomizer: UInt32 {
        get {
            if peopleCount < 2 {
                return 2
            } else {
                return UInt32(peopleCount)
            }
        }
    }
    
    func incrementScore() {

        if incrementedScore < score {
            let increment = arc4random_uniform(randomizer)
            incrementedScore = incrementedScore + Int(increment)
            
            if incrementedScore > score {
                incrementedScore = score
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TotalScoreTableViewCell
                cell.totalScore.text = "\(self.incrementedScore)"
            }
        } else {
            dispatch_source_cancel(asyncTimer!)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return peopleCount + 1 // Knocking base score + people
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("TotalScoreCell") as! TotalScoreTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("IndividualScoreCell") as! IndividualScoreTableViewCell
            
            let personIndex = indexPath.row - 1
            
            if indexPath.row == 0 {
                cell.pointsLabel.text = "+5"
                cell.explanationLabel.text = "for knocking"
            } else {
                var explanationText = "for updating someone's info"

                if let people = people {
                    let person = people[personIndex]
                    if let firstName = person.firstName {
                        explanationText = "for updating \(firstName)'s info"
                    }
                }
                
                cell.pointsLabel.text = "+10"
                cell.explanationLabel.text = explanationText
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("TotalScoreCell") as! TotalScoreTableViewCell
            return cell
        }
    }
    
    var preventAnimation = Set<NSIndexPath>()
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            
            if let cell = cell as? IndividualScoreTableViewCell {
            
                if !preventAnimation.contains(indexPath) {
                    preventAnimation.insert(indexPath)
                    
                    let delay = CGFloat(Double(indexPath.row) * 0.5)
                    
                    cell.pointsLabel.animation = "fadeInLeft"
                    cell.pointsLabel.duration = 1.5
                    cell.pointsLabel.delay = delay
                    cell.pointsLabel.animate()
                    
                    cell.explanationLabel.animation = "fadeInLeft"
                    cell.explanationLabel.duration = 1.5
                    cell.explanationLabel.delay = delay
                    cell.explanationLabel.animate()
                }
            }
        }
    }

}
