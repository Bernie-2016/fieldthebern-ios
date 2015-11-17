//
//  NoOneHomeTableViewCell.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/15/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class NoOneHomeTableViewCell: UITableViewCell {
    
    var delegate: AskedToLeaveSwitchDelegate?

    @IBOutlet weak var noOneHomeSwitch: UISwitch!
    @IBOutlet weak var goAwaySwitch: UISwitch!
    
    @IBAction func tappedNoOneHomeSwitch(sender: UISwitch) {
        goAwaySwitch.setOn(!noOneHomeSwitch.on, animated: true)
    }
    @IBAction func tappedGoAwaySwitch(sender: UISwitch) {
        noOneHomeSwitch.setOn(!goAwaySwitch.on, animated: true)

        // Notify the delegate
        delegate?.askedToLeaveSwitched(goAwaySwitch.on)
    }
}
