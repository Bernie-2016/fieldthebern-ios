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
            CanvassResponseOption(canvasResponse: .StronglyFor),
            CanvassResponseOption(canvasResponse: .LeaningFor),
            CanvassResponseOption(canvasResponse: .Undecided),
            CanvassResponseOption(canvasResponse: .LeaningAgainst),
            CanvassResponseOption(canvasResponse: .StronglyAgainst)
        ]
    }
}