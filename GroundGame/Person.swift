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
        switch canvasResponse {
        case .Unknown:
            return "Unknown"
        case .StronglyAgainst:
            return "Strongly against Bernie"
        case .LeaningAgainst:
            return "Leaning against Bernie"
        case .Undecided:
            return "Undecided about Bernie"
        case .LeaningFor:
            return "Leaning for Bernie"
        case .StronglyFor:
            return "Strongly for Bernie"
        }
    }
    
    var partyAffiliationString: String {
        get {
            switch partyAffiliation {
            case .Unknown:
                return "Unknown"
            case .Undeclared:
                return "Undeclared"
            case .Republican:
                return "Republican"
            case .Independent:
                return "Independent"
            case .Democrat:
                return "Democrat"
            case .Other:
                return "Other"
            }
        }
    }
    
    var partyAffiliationImage: UIImage? {
        get {
            switch partyAffiliation {
            case .Unknown:
                return PartyAffiliationImage.Unknown
            case .Undeclared:
                return PartyAffiliationImage.Undeclared
            case .Republican:
                return PartyAffiliationImage.Republican
            case .Independent:
                return PartyAffiliationImage.Independent
            case .Democrat:
                return PartyAffiliationImage.Democrat
            case .Other:
                return PartyAffiliationImage.Other
            }
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
            switch partyAffiliationString {
            case "democrat_affiliation":
                partyAffiliation = .Democrat
            case "republican_affiliation":
                partyAffiliation = .Republican
            case "independent_affiliation":
                partyAffiliation = .Independent
            case "other_affiliation":
                partyAffiliation = .Other
            case "undeclared_affiliation":
                partyAffiliation = .Undeclared
            case "unknown_affiliation":
                partyAffiliation = .Unknown
            default:
                partyAffiliation = .Unknown
            }
        }
        
        if let response = attributes["canvas_response"].string {
        
            switch response {
            case "strongly_against":
                canvasResponse = .StronglyAgainst
            case "leaning_against":
                canvasResponse = .LeaningAgainst
            case "undecided":
                canvasResponse = .Undecided
            case "leaning_for":
                canvasResponse = .LeaningFor
            case "strongly_for":
                canvasResponse = .StronglyFor
            default:
                canvasResponse = .Unknown
            }
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
        switch partyAffiliationString {
        case "Republican":
            self.partyAffiliation = .Republican
        case "Democrat":
            self.partyAffiliation = .Democrat
        case "Independent":
            self.partyAffiliation = .Independent
        case "Undeclared":
            self.partyAffiliation = .Undeclared
        case "Unknown":
            self.partyAffiliation = .Unknown
        default:
            self.partyAffiliation = .Unknown
        }
    }
}