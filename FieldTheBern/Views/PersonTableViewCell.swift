//
//  PersonTableViewCell.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class PersonTableViewCell: BlueTableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var partyAffiliationImage: UIImageView!
    
    var checked: Bool = false {
        didSet {
            if checked {
                checkImage?.image = UIImage(named: "check")
            } else {
                checkImage?.image = UIImage(named: "checkbox")
            }
        }
    }

}
