//
//  ElectionDetailsViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/26/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class ElectionDetailsViewController: UIViewController {
    
    var state: State?

    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var electionType: UILabel!
    @IBOutlet weak var electionDate: UILabel!
    @IBOutlet weak var registrationDeadline: UILabel!
    @IBOutlet weak var details: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let state = self.state {
            stateImage.image = state.icon
            stateName.text = state.name
            electionType.text = state.type
            if let date = state.date {
                electionDate.text = "on \(date)"
            }
            if let deadline = state.deadline {
                registrationDeadline.text = "Registration Deadline: \(deadline)"
            }
            details.text = state.details
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
