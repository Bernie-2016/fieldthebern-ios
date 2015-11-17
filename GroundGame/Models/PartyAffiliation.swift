//
//  PartyAffiliation.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import UIKit

enum PartyAffiliation {
    case Republican, Democrat, Independent, Other, Undeclared, Unknown
    
    func title() -> String {
        switch self {
        case .Republican:
            return "Republican"
        case .Democrat:
            return "Democrat"
        case .Independent:
            return "Independent"
        case .Other:
            return "Other"
        case .Undeclared:
            return "Undeclared"
        case .Unknown:
            return "Unknown"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .Unknown:
            return UIImage(named: "unknown-icon")
        case .Undeclared:
            return UIImage(named: "undeclared-icon")
        case .Democrat:
            return UIImage(named: "democrat-icon")
        case .Independent:
            return UIImage(named: "independent-icon")
        case .Republican:
            return UIImage(named: "republican-icon")
        case .Other:
            return UIImage(named: "other-icon")
        }
    }
    
    static func fromString(string: String) -> PartyAffiliation {
        switch string {
        case "Republican":
            return .Republican
        case "Democrat":
            return .Democrat
        case "Independent":
            return .Independent
        case "Undeclared":
            return .Undeclared
        case "Unknown":
            return .Unknown
        default:
            return .Unknown
        }
    }
    
    static func fromJSONString(string: String) -> PartyAffiliation {
        switch string {
        case "democrat_affiliation":
            return .Democrat
        case "republican_affiliation":
            return .Republican
        case "independent_affiliation":
            return .Independent
        case "other_affiliation":
            return .Other
        case "undeclared_affiliation":
            return .Undeclared
        case "unknown_affiliation":
            return .Unknown
        default:
            return .Unknown
        }
    }
    
    static func list() -> [PartyAffiliation] {
        return [
            .Democrat,
            .Republican,
            .Independent,
            .Undeclared,
            .Other
        ]
    }
}