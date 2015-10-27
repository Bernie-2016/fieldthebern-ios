//
//  ElectionTableViewCell.swift
//  GroundGame
//
//  Created by Josh Smith on 10/26/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class ElectionTableViewCell: BlueTableViewCell {

    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var electionType: UILabel!
    @IBOutlet weak var electionDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
