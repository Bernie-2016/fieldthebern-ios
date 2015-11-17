//
//  PersonJSON.swift
//  FieldTheBern
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
    let email: String?
    let phone: String?
    let preferredContactMethod: String?
    let partyAffiliationString: String
    let canvassResponseJSONString: String
    let previouslyParticipatedInCaucusOrPrimary: Bool?
    
    init(person: Person) {
        id = person.id
        firstName = person.firstName
        lastName = person.lastName
        email = person.email
        phone = person.phone
        preferredContactMethod = person.preferredContactMethod
        previouslyParticipatedInCaucusOrPrimary = person.previouslyParticipatedInCaucusOrPrimary
        partyAffiliationString = person.partyAffiliationString        
        canvassResponseJSONString = person.canvassResponse.JSONString()
        
        attributes = [
            "first_name": firstName ?? NSNull(),
            "last_name": lastName ?? NSNull(),
            "email": email ?? NSNull(),
            "phone": phone ?? NSNull(),
            "preferred_contact_method": preferredContactMethod ?? NSNull(),
            "previously_participated_in_caucus_or_primary": previouslyParticipatedInCaucusOrPrimary ?? NSNull(),
            "party_affiliation": partyAffiliationString,
            "canvass_response": canvassResponseJSONString
        ]
        
        include = [
            "type": "people",
            "id": id ?? NSNull(),
            "attributes": self.attributes
        ]
    }
}