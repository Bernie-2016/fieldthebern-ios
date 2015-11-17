//
//  ConversationTimerViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate, SubmitButtonDelegate, UITableViewDelegate, UITableViewDataSource, AskedToLeaveSwitchDelegate {
    
    var savedGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    let states = States()
    
    var location: CLLocation?
    var placemark: CLPlacemark?
    var address: Address?
    var people: [Person] = []
    var selectedPerson: Person?
    var selectedIndexPath: NSIndexPath?
    var peopleAreHome: Bool = false
    var askedToLeave: Bool = false
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
    
    var startTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var secondsElapsed = 0
    
    var queue: dispatch_queue_t?
    var asyncTimer: dispatch_source_t?
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        elapsedTime = currentTime - startTime

        let elapsedTimeInteger = NSInteger(elapsedTime)
        secondsElapsed = elapsedTimeInteger % 60
    }
    
    func startTimer() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        queue = dispatch_queue_create("myTimer", nil)
        asyncTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        dispatch_source_set_timer(asyncTimer!, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(asyncTimer!) {
            self.updateTime()
        }
        
        dispatch_resume(asyncTimer!)
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
    
    func finishedSubmittingWithError(error: APIError) {
        submitButton.enabled = true
        
        self.handleError(error)
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
                cell.resultLabel.text = person.canvassResponseString
                cell.partyAffiliationImage.image = person.partyAffiliationImage
                
                return cell
            } else if indexPath.row == people.count {
                // Show the "Add Person" cell
                let cell = tableView.dequeueReusableCellWithIdentifier("AddPerson")!
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("NoOneHomeCell") as! NoOneHomeTableViewCell
                
                cell.delegate = self
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
    
    // MARK: - AskedToLeaveSwitchDelegate Methods
    
    func askedToLeaveSwitched(state: Bool) {
        askedToLeave = state
    }
    
    func submitForm() {
        delegate?.isSubmitting()
        if let address = self.address {
            VisitService().postVisit(secondsElapsed, address: address, people: peopleAtHome, askedToLeave: askedToLeave) { (visit, success, error) in
                if success {
                    self.submitSuccess(visit)
                } else  {
                    if let error = error {
                        self.finishedSubmittingWithError(error)                    
                    }
                }
            }
        }
    }
    
    func submitSuccess(visit: Visit?) {
        // Set the visit to send to the score controller
        self.visit = visit
        
        // Cancel our timer
        if let timer = self.asyncTimer {
            dispatch_source_cancel(timer)
        }
        
        // Reload the map to show our new visit result
        NSNotificationCenter.defaultCenter().postNotificationName("shouldReloadMap", object: nil)
        
        // Segue to the score controller
        self.performSegueWithIdentifier("SubmitVisitDetails", sender: self)
    }
    
    func handleError(error: APIError) {
        let errorTitle = error.errorTitle
        let errorMessage = error.errorDescription
        
        let alert = UIAlertController.errorAlertControllerWithTitle(errorTitle, message: errorMessage)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
