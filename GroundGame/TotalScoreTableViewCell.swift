//
//  TotalScoreTableViewCell.swift
//  GroundGame
//
//  Created by Josh Smith on 10/20/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import Spring

class TotalScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var totalScore: SpringLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
