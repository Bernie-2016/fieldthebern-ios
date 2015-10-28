//
//  ConversationTimerViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate, SubmitButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var savedGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    let states = States()
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    var address: Address?
    var people: [Person] = []
    var selectedPerson: Person?
    var selectedIndexPath: NSIndexPath?
    var peopleAreHome: Bool = false
    var visit: Visit?
    var delegate: SubmitButtonDelegate?
    
    var peopleAtHome: [Person] {
        get {
            var tempArray: [Person] = []
            for person in people {
                if person.atHomeStatus { tempArray.append(person) }
            }
            return tempArray
        }
    }
    
    var state: State? {
        get {
            if let stateName = placemark?.administrativeArea {
               return states.find(stateName)
            } else {
                return nil
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Set submit button's submitting state
        submitButton.setTitle("Submitting Visit Details".uppercaseString, forState: UIControlState.Disabled)
        submitButton.setBackgroundImage(UIImage.imageFromColor(Color.Gray), forState: UIControlState.Disabled)
        
        startTimer()
        
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
        self.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        savedGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let backButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
    }
    
    func cancel(sender: UINavigationItem) {

        let alert = UIAlertController(title: "Cancel Visit", message: "You'll lose all your progress with this visit and go back to the map.", preferredStyle: UIAlertControllerStyle.Alert)

        let cancelAction = UIAlertAction(title: "Undo", style: .Cancel) { (_) in
            
        }
        let OKAction = UIAlertAction(title: "Back to Map", style: .Destructive) { (action) in
            // Return to map
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(OKAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer {
        case self.navigationController!.interactivePopGestureRecognizer!:
            return false
        default:
            return true
        }
    }
    
    @IBAction func pressSubmitButton(sender: UIButton) {
        self.submitForm()
    }
    
    func isSubmitting() {
        submitButton.enabled = false
    }
    
    func finishedSubmittingWithError(errorMessage: String) {
        submitButton.enabled = true
    }
    
    @IBAction func editPerson(sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                selectedPerson = people[indexPath.row]
                selectedIndexPath = indexPath
                performSegueWithIdentifier("EditPersonSegue", sender: self)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 26
        case 1:
            return 26
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            var extraRows = 1
            if !peopleAreHome { extraRows++ } // Show the extra row for saying someone's not home
            
            return people.count + extraRows
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Who did you talk to?".uppercaseString
        } else if section == 1 {
            return "Primary & policy info".uppercaseString
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Color.Blue
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textAlignment = NSTextAlignment.Center
            header.textLabel?.font = UIFont(name: "Lato-Heavy", size: 12.0)
            header.textLabel?.textColor = UIColor.whiteColor()
            
            let separatorWidth = CGFloat(0.5)
            let separator = UIView.init(frame: CGRect(x: 0, y: header.frame.height - separatorWidth, width: self.tableView.frame.width, height: separatorWidth))
            separator.backgroundColor = UIColor.whiteColor()
            header.addSubview(separator)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            if indexPath.row < people.count {
                // We have a person's info to display
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell") as! PersonTableViewCell
                
                let person = people[indexPath.row] as Person
                
                cell.checked = person.atHomeStatus
                
                if let name = person.name {
                    cell.nameLabel.text = name
                }
                cell.resultLabel.text = person.canvasResponseString
                cell.partyAffiliationImage.image = person.partyAffiliationImage
                
                return cell
            } else if indexPath.row == people.count {
                // Show the "Add Person" cell
                let cell = tableView.dequeueReusableCellWithIdentifier("AddPerson")!
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("NoOneHomeCell") as! NoOneHomeTableViewCell
                
                cell.noOneHomeSwitch.setOn(!peopleAreHome, animated: false)
                
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ElectionCell") as! ElectionTableViewCell
                
                if let state = self.state {
                    cell.stateImage.image = state.icon
                    cell.stateName.text = state.name
                    cell.electionType.text = state.type
                    if let date = state.date {
                        cell.electionDate.text = "on \(date)"
                    }
                }
            
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("PoliciesCell")
                
                return cell!
            }
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("AddPerson")!
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row < people.count {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PersonTableViewCell
                
                cell.checked = !cell.checked
                
                people[indexPath.row].atHomeStatus = cell.checked
                
                updatePeopleAtHome()
                self.tableView.reloadData()
            } else if indexPath.row == people.count {
                performSegueWithIdentifier("AddPersonSegue", sender: self)
            }
        case 1:
            if indexPath.row == 0 {
                performSegueWithIdentifier("ShowElectionDetails", sender: self)
            }
            if indexPath.row == 1 {
                performSegueWithIdentifier("ShowPolicies", sender: self)
            }
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditPersonSegue" {
            if let PersonDetailsViewController = segue.destinationViewController as? PersonDetailsViewController {
                PersonDetailsViewController.person = self.selectedPerson
                PersonDetailsViewController.personIndexPath = self.selectedIndexPath
            }
        }
        if segue.identifier == "ShowElectionDetails" {
            if let electionDetailsViewController = segue.destinationViewController as? ElectionDetailsViewController {
                electionDetailsViewController.state = self.state
            }
        }
        if segue.identifier == "SubmitVisitDetails" {
            if let scoreViewController = segue.destinationViewController as? ScoreViewController {
                scoreViewController.people = self.peopleAtHome
                scoreViewController.visit = self.visit
            }
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
    }
    
    func updatePerson(person: Person, indexPath: NSIndexPath) {
        people[indexPath.row] = person
        updatePeopleAtHome()
        tableView.reloadData()
    }
    
    func addPerson(person: Person) {
        people.append(person)
        updatePeopleAtHome()
        tableView.reloadData()
    }
    
    func updatePeopleAtHome() {
        var updatedStatus = false
        for person in people {
            if person.atHomeStatus {
                updatedStatus = true
            }
        }
        peopleAreHome = updatedStatus
    }
    
    func submitForm() {
        delegate?.isSubmitting()
        if let address = self.address {
            
            stopTimer()
            
            VisitService().postVisit(1, address: address, people: peopleAtHome) { (visit) in
                self.visit = visit
                NSNotificationCenter.defaultCenter().postNotificationName("shouldReloadMap", object: nil)
                self.performSegueWithIdentifier("SubmitVisitDetails", sender: self)
            }
        }
    }
    
    // MARK: - Timer
    
    var startTime : NSTimeInterval?
    var elapsedTime : NSTimeInterval?
    var timer : NSTimer?
    
    
    func startTimer() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
    }

    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        elapsedTime = currentTime - startTime!
        
        let minutes = UInt8(elapsedTime! / 60.0)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime! - (NSTimeInterval(minutes) * 60))
        
        print("\(minutes):\(seconds)")
    }
    
    func stopTimer() {
        
        timer!.invalidate()
    }
}
