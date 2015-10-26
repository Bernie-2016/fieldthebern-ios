//
//  LoadingTableViewCell.swift
//  GroundGame
//
//  Created by Josh Smith on 10/26/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
