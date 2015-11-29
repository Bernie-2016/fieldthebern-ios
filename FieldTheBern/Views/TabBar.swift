//
//  TabBar.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/30/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class TabBar: UITabBar {

    override func sizeThatFits(size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 53
        
        return sizeThatFits
    }

}
