//
//  Visit.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/13/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Visit {
    let id: String?
    let totalPoints: Int
    
    init(json: JSON) {
        let data = json["data"]

        self.id = data["id"].string
        let attributes = data["attributes"]

        if let points = attributes["total_points"].number {
            totalPoints = points as Int
        } else {
            totalPoints = 0
        }
    }
}