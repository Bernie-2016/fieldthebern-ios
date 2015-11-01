//
//  InviteFriendsTableViewCell.swift
//  GroundGame
//
//  Created by Josh Smith on 10/24/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {
    
    var delegate: CellButtonDelegate?

    @IBOutlet weak var inviteFriendsButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inviteFriendsButton.layer.cornerRadius = inviteFriendsButton.frame.height / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pressInviteFriendsButton() {
        delegate?.didPressButton()
    }
}
