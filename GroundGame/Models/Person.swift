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

public struct Person {
    let id: String?
    var firstName: String?
    var lastName: String?

    var partyAffiliation: PartyAffiliation = .Unknown
    var canvassResponse: CanvassResponse = .Unknown
    var atHomeStatus: Bool = false
    var askedToLeave: Bool = true
    
    // Only set; never displayed in app
    var phone: String?
    var email: String?
    var preferredContactMethod: String?
    var previouslyParticipatedInCaucusOrPrimary: Bool?
    
    var name: String? {
        get {
            if let first = firstName, last = lastName {
                return "\(first) \(last)"
            } else {
                return firstName
            }
        }
    }
    
    var canvassResponseString: String {
        get {
            return canvassResponse.description()
        }
    }
    
    var partyAffiliationString: String {
        get {
            return partyAffiliation.title()
        }
    }
    
    var partyAffiliationImage: UIImage? {
        get {
            return partyAffiliation.image()
        }
    }
    
    init() {
        self.id = nil
        firstName = nil
        lastName = nil
        partyAffiliation = .Unknown
        canvassResponse = .Unknown
        email = nil
        phone = nil
        preferredContactMethod = nil
    }
    
    init(json: JSON) {
        self.id = json["id"].string
        let attributes = json["attributes"]
        firstName = attributes["first_name"].string
        lastName = attributes["last_name"].string
        
        if let partyAffiliationString = attributes["party_affiliation"].string {
            partyAffiliation = PartyAffiliation.fromJSONString(partyAffiliationString)
        }
        
        if let response = attributes["canvas_response"].string {
            canvassResponse = CanvassResponse.fromJSONString(response)
        }

    }
    
    init(firstName: String?, lastName: String?, partyAffiliation: String?, canvassResponse: CanvassResponse) {
        self.id = nil
        self.firstName = firstName
        self.lastName = lastName
        
        if let partyAffiliationString = partyAffiliation {
            setPartyAffiliation(partyAffiliationString)
        }
        
        self.canvassResponse = canvassResponse
    }
    
    private mutating func setPartyAffiliation(partyAffiliationString: String) {
        self.partyAffiliation = PartyAffiliation.fromString(partyAffiliationString)
    }
}