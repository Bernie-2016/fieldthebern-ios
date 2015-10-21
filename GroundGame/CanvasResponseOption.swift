//
//  CanvasResponseOption.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import UIKit

struct CanvasResponseOption {
    let title: String
    let textColor: UIColor
    let backgroundColor: UIColor
    let canvasResponse: CanvasResponse
    let checkImage: UIImage?
    
    init(canvasResponse: CanvasResponse) {

        self.canvasResponse = canvasResponse
        
        switch canvasResponse {
        case .StronglyAgainst:
            title = "Strongly against Bernie"
            textColor = UIColor.whiteColor()
            backgroundColor = Color.Red
            self.checkImage = UIImage(named: "check")
        case .LeaningAgainst:
            title = "Leaning against Bernie"
            textColor = UIColor.whiteColor()
            backgroundColor = Color.Pink
            self.checkImage = UIImage(named: "check")
        case .Undecided:
            title = "Undecided"
            textColor = UIColor.blackColor()
            backgroundColor = UIColor.whiteColor()
            self.checkImage = UIImage(named: "check-black")
        case .LeaningFor:
            title = "Leaning for Bernie"
            textColor = UIColor.whiteColor()
            backgroundColor = Color.LightBlue
            self.checkImage = UIImage(named: "check")
        case .StronglyFor:
            title = "Strongly for Bernie"
            textColor = UIColor.whiteColor()
            backgroundColor = Color.DarkBlue
            self.checkImage = UIImage(named: "check")
        case .Unknown:
            title = "Unknown"
            textColor = UIColor.blackColor()
            backgroundColor = UIColor.whiteColor()
            self.checkImage = UIImage(named: "check-black")
        }
    }
}