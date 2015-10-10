//
//  Person.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct Person {
    let id: String?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let partyAffiliation: String?
    
    var result: VisitResult = .NotVisited
    
    var name: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    init(id: String?, personJSON: JSON) {
        self.id = id
        firstName = personJSON["first_name"].string
        lastName = personJSON["last_name"].string
        phoneNumber = personJSON["phone"].string
        partyAffiliation = personJSON["party_affiliation"].string
    }
}