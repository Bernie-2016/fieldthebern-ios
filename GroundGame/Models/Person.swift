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
    var canvasResponse: CanvasResponse = .Unknown
    var atHomeStatus: Bool = false
    var askedToLeave: Bool = true
    
    var name: String? {
        get {
            if let first = firstName, last = lastName {
                return "\(first) \(last)"
            } else {
                return firstName
            }
        }
    }
    
    var canvasResponseString: String {
        get {
            return canvasResponse.description()
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
        canvasResponse = .Unknown
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
            canvasResponse = CanvasResponse.fromJSONString(response)
        }

    }
    
    init(firstName: String?, lastName: String?, partyAffiliation: String?, canvasResponse: CanvasResponse) {
        self.id = nil
        self.firstName = firstName
        self.lastName = lastName
        
        if let partyAffiliationString = partyAffiliation {
            setPartyAffiliation(partyAffiliationString)
        }
        
        self.canvasResponse = canvasResponse
    }
    
    private mutating func setPartyAffiliation(partyAffiliationString: String) {
        self.partyAffiliation = PartyAffiliation.fromString(partyAffiliationString)
    }
}