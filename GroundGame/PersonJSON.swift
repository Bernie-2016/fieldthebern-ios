//
//  PersonJSON.swift
//  GroundGame
//
//  Created by Josh Smith on 10/14/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct PersonJSON {
    
    let attributes: [String: AnyObject]
    let include: [String: AnyObject]
    
    let id: String?
    let firstName: String?
    let lastName: String?
    let partyAffiliationString: String
    let canvasResponseJSONString: String
    
    init(person: Person) {
        id = person.id
        firstName = person.firstName
        lastName = person.lastName
        partyAffiliationString = person.partyAffiliationString
        
        switch person.canvasResponse {
        case .LeaningAgainst:
            canvasResponseJSONString = "Leaning against"
        case .LeaningFor:
            canvasResponseJSONString = "Leaning for"
        case .StronglyAgainst:
            canvasResponseJSONString = "Strongly against"
        case .StronglyFor:
            canvasResponseJSONString = "Strongly for"
        case .Undecided:
            canvasResponseJSONString = "Undecided"
        case .Unknown:
            canvasResponseJSONString = "Unknown"
        }
        
        attributes = [
            "first_name": firstName ?? NSNull(),
            "last_name": lastName ?? NSNull(),
            "party_affiliation": partyAffiliationString,
            "canvas_response": canvasResponseJSONString
        ]
        
        include = [
            "type": "people",
            "id": id ?? NSNull(),
            "attributes": self.attributes
        ]
    }
}