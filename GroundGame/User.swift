//
//  User.swift
//  GroundGame
//
//  Created by Josh Smith on 10/23/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let id: String?
    let firstName: String?
    let lastName: String?

    var name: String? {
        get {
            if let first = firstName, last = lastName {
                return "\(first) \(last)"
            } else {
                return firstName
            }
        }
    }

    init(json: JSON) {
        let data = json["data"]
        
        self.id = data["id"].string
        
        let attributes = data["attributes"]
        
        self.firstName = attributes["first_name"].string
        self.lastName = attributes["last_name"].string
    }
}