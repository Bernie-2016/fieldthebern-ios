//
//  NoOneHomeTableViewCell.swift
//  GroundGame
//
//  Created by Josh Smith on 10/15/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class NoOneHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var noOneHomeSwitch: UISwitch!
    @IBOutlet weak var goAwaySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tappedNoOneHomeSwitch(sender: UISwitch) {
        goAwaySwitch.setOn(!noOneHomeSwitch.on, animated: true)
    }
    @IBAction func tappedGoAwaySwitch(sender: UISwitch) {
        noOneHomeSwitch.setOn(!goAwaySwitch.on, animated: true)
    }
}
