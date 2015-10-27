//
//  CanvasResponseList.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct CanvasResponseList {
    
    let options: [CanvasResponseOption]
    
    init() {
        options = [
            CanvasResponseOption(canvasResponse: .StronglyFor),
            CanvasResponseOption(canvasResponse: .LeaningFor),
            CanvasResponseOption(canvasResponse: .Undecided),
            CanvasResponseOption(canvasResponse: .LeaningAgainst),
            CanvasResponseOption(canvasResponse: .StronglyAgainst)
        ]
    }
}