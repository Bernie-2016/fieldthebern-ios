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

enum PartyAffiliation {
    case Republican, Democrat, Independent, Undeclared, Unknown
}

struct PartyAffiliationImage {
    static let Unknown = UIImage(named: "unknown-icon")
    static let Undeclared = UIImage(named: "undeclared-icon")
    static let Democrat = UIImage(named: "democrat-icon")
    static let Independent = UIImage(named: "independent-icon")
    static let Republican = UIImage(named: "republican-icon")
}

public struct Person {
    let id: String?
    let firstName: String?
    let lastName: String?

    var partyAffiliation: PartyAffiliation = .Unknown
    var canvasResponse: CanvasResponse = .Unknown
    
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
            }
        }
    }
    
    init(id: String?, personJSON: JSON) {
        self.id = id
        firstName = personJSON["first_name"].string
        lastName = personJSON["last_name"].string
        
        if let partyAffiliationString = personJSON["party_affiliation"].string {
            setPartyAffiliation(partyAffiliationString)
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