//
//  CanvassResponseList.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct CanvassResponseList {
    
    let options: [CanvassResponseOption]
    
    init() {
        options = [
            CanvassResponseOption(canvassResponse: .StronglyFor),
            CanvassResponseOption(canvassResponse: .LeaningFor),
            CanvassResponseOption(canvassResponse: .Undecided),
            CanvassResponseOption(canvassResponse: .LeaningAgainst),
            CanvassResponseOption(canvassResponse: .StronglyAgainst)
        ]
    }
}