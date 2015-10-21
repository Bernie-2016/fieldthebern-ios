//
//  ConversationTableViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class ConversationTableViewController: UITableViewController {
    
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

//    @IBOutlet weak var stateImage: UIImageView!
//    @IBOutlet weak var stateNameLabel: UILabel!
//    @IBOutlet weak var stateTypeAndStatusLabel: UILabel!
//    @IBOutlet weak var stateDateLabel: UILabel!
//    @IBOutlet weak var stateDetailsLabel: UILabel!
//    @IBOutlet weak var stateDeadlineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
//        let josh = Person.init(firstName: "Josh", lastName: "Smith", partyAffiliation: nil, canvasResponse: .LeaningFor)
//        let molly = Person.init(firstName: "Molly", lastName: nil, partyAffiliation: "Democrat", canvasResponse: .StronglyFor)
//        
//        people = [josh, molly]
        
//        let states = States()
//        if let pm = placemark {
//            if let stateName = pm.administrativeArea {
//                if let state = states.find(stateName as String) {
//                    stateImage.image = state.icon
//                    if let type = state.type,
//                        let status = state.status {
//                            stateTypeAndStatusLabel.text = "\(status) \(type)"
//                    }
//                    stateNameLabel.text = state.name
//                    if let deadline = state.deadline {
//                        stateDeadlineLabel.text = "Registration Deadline: \(deadline)"
//                    }
//                    if let date = state.date {
//                        stateDateLabel.text = "on \(date)"
//                    }
//                    stateDetailsLabel.text = state.details
//                }
//            }
//        }
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 26
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            var extraRows = 1
            if !peopleAreHome { extraRows++ } // Show the extra row for saying someone's not home
            
            return people.count + extraRows
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Who did you talk to?".uppercaseString
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("AddPerson")!
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        
        if segue.identifier == "SubmitVisitDetails" {
            if let scoreContainerViewController = segue.destinationViewController as? ScoreContainerViewController {
                scoreContainerViewController.people = self.peopleAtHome
                scoreContainerViewController.visit = self.visit
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
            VisitService().postVisit(1, address: address, people: peopleAtHome) { (visit) in
                self.visit = visit
                NSNotificationCenter.defaultCenter().postNotificationName("shouldReloadMap", object: nil)
                self.performSegueWithIdentifier("SubmitVisitDetails", sender: self)
            }
        }
    }
}
