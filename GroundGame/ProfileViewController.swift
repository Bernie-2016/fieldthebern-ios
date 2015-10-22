//
//  ProfileViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/1/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }

    @IBAction func logout(sender: UIButton) {
        let session = Session.sharedInstance
        session.logout()
        self.performSegueWithIdentifier("Logout", sender: self)
    }

}
