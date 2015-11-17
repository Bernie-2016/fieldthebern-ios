//
//  CheckableTableViewCell.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class CheckableTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var checked: Bool = false {
        didSet {
            checkImage?.highlighted = checked
        }
    }

}
