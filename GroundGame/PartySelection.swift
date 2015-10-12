//
//  PartySelection.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
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

struct PartySelection {
    
    let title: String
    let partyAffiliation: PartyAffiliation
    
    init(partyAffiliation: PartyAffiliation) {
        self.partyAffiliation = partyAffiliation
        
        switch partyAffiliation {
        case .Democrat:
            title = "Democrat"
        case .Republican:
            title = "Republican"
        case .Independent:
            title = "Independent"
        case .Undeclared:
            title = "Undeclared"
        case .Unknown:
            title = "Unknown"
        case .Other:
            title = "Other"
        }
    }
}