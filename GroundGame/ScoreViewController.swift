//
//  ScoreViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/15/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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

    @IBOutlet weak var gifContainer: UIImageView!

    let images = ["bernie-ellen", "bernie", "bernie-shrug", "bernie-dancing", "bernie-dance"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadBernieGif()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
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
    }
    
    func loadBernieGif() {
        let randomIndex = Int(arc4random_uniform(UInt32(images.count)))
        let imageName = images[randomIndex]
        
        if let path = NSBundle.mainBundle().pathForResource(imageName, ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                let imageSize = 100.0
                let imageSizeFloat = CGFloat(imageSize)
                let image = FLAnimatedImage(animatedGIFData: data)
                let imageView: FLAnimatedImageView = FLAnimatedImageView()
                imageView.animatedImage = image
                imageView.frame = CGRectMake(3, 3, imageSizeFloat, imageSizeFloat)
                
                let innerFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                let maskLayer = CAShapeLayer()
                let circlePath = UIBezierPath(roundedRect: innerFrame, cornerRadius: imageSizeFloat)
                maskLayer.path = circlePath.CGPath
                maskLayer.fillColor = UIColor.whiteColor().CGColor
                
                imageView.layer.mask = maskLayer
                
                gifContainer.addSubview(imageView)
            }
            
        }
    }
    
    @IBAction func pressedBackToMap(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return peopleCount + 1 // Knocking base score + people
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
