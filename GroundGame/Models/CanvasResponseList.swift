//
//  CanvassResponseList.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct CanvassResponseList {
    
    let options: [CanvassResponseOption]
    
    init() {
        options = [
            CanvassResponseOption(canvass_: .StronglyFor),
            CanvassResponseOption(canvass_: .LeaningFor),
            CanvassResponseOption(canvass_: .Undecided),
            CanvassResponseOption(canvass_: .LeaningAgainst),
            CanvassResponseOption(canvass_: .StronglyAgainst)
        ]
    }
}