//
//  PartyAffiliationList.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct PartyAffiliationList {
    
    var options: [PartyAffiliation]
    
    init() {
        options = [
            .Democrat,
            .Republican,
            .Independent,
            .Undeclared,
            .Other
        ]
    }
}