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
    
    @IBOutlet weak var scoreLabel: SpringLabel!
    
    @IBOutlet weak var firstLabel: SpringLabel!
    @IBOutlet weak var secondLabel: SpringLabel!
    @IBOutlet weak var thirdLabel: SpringLabel!
    
    @IBOutlet weak var firstSublabel: SpringLabel!
    @IBOutlet weak var thirdSublabel: SpringLabel!
    @IBOutlet weak var secondSublabel: SpringLabel!
    
    
    let score = 40
    var incrementedScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        queue = dispatch_queue_create("myTimer", nil)
        asyncTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        dispatch_source_set_timer(asyncTimer!, DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
        
        dispatch_source_set_event_handler(asyncTimer!) {
            self.incrementScore()
        }
        
        dispatch_resume(asyncTimer!)
        
        firstLabel.animation = "fadeInLeft"
        firstLabel.duration = 1.5
        secondLabel.animation = "fadeInLeft"
        secondLabel.delay = 0.5
        secondLabel.duration = 1.5
        thirdLabel.animation = "fadeInLeft"
        thirdLabel.duration = 1.5
        thirdLabel.delay = 1.0
        firstLabel.animate()
        secondLabel.animate()
        thirdLabel.animate()

    
        firstSublabel.animation = "fadeInLeft"
        firstSublabel.duration = 1.5
        secondSublabel.animation = "fadeInLeft"
        secondSublabel.duration = 1.5
        secondSublabel.delay = 0.5
        thirdSublabel.animation = "fadeInLeft"
        thirdSublabel.duration = 1.5
        thirdSublabel.delay = 1.0
        firstSublabel.animate()
        secondSublabel.animate()
        thirdSublabel.animate()
}
    
    var queue: dispatch_queue_t?
    var asyncTimer: dispatch_source_t?
    
    func incrementScore() {
        print("incrementing")
        if incrementedScore < score {
            let increment = arc4random_uniform(4)
            incrementedScore = incrementedScore + Int(increment)
            
            if incrementedScore > score {
                incrementedScore = score
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.scoreLabel.text = "\(self.incrementedScore)"
            }
        } else {
            dispatch_source_cancel(asyncTimer!)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

}
