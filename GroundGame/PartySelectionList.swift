//
//  PartySelectionList.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct PartySelectionList {
    
    var options: [PartySelection]
    
    init() {
        options = [
            PartySelection.init(partyAffiliation: .Democrat),
            PartySelection.init(partyAffiliation: .Republican),
            PartySelection.init(partyAffiliation: .Independent),
            PartySelection.init(partyAffiliation: .Undeclared),
            PartySelection.init(partyAffiliation: .Other)
        ]
    }
}