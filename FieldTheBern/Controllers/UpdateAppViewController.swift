//
//  UpdateAppViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/17/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class UpdateAppViewController: UIViewController {

    @IBOutlet weak var updateNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateNowButton.layer.cornerRadius = updateNowButton.frame.height
    }

    @IBAction func pressUpdateNow(sender: UIButton) {
        let url = NSURL(string: "itms-apps://itunes.apple.com/app/id1061795493")
        if UIApplication.sharedApplication().canOpenURL(url!) == true  {
        UIApplication.sharedApplication().openURL(url!)
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
