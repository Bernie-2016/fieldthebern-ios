//
//  PartySelection.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

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