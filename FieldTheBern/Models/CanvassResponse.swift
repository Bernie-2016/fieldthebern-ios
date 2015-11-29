//
//  CanvassResponse.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/10/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

enum CanvassResponse {
    case Unknown, StronglyAgainst, LeaningAgainst, Undecided, LeaningFor, StronglyFor
    
    func description() -> String {
        switch self {
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
    
    func JSONString() -> String {
        switch self {
        case .Unknown:
            return "unknown"
        case .StronglyAgainst:
            return "strongly_against"
        case .LeaningAgainst:
            return "leaning_against"
        case .Undecided:
            return "undecided"
        case .LeaningFor:
            return "leaning_for"
        case .StronglyFor:
            return "strongly_for"
        }
    }
    
    static func fromJSONString(string: String) -> CanvassResponse {
        switch string {
        case "strongly_against":
            return .StronglyAgainst
        case "leaning_against":
            return .LeaningAgainst
        case "undecided":
            return .Undecided
        case "leaning_for":
            return .LeaningFor
        case "strongly_for":
            return .StronglyFor
        default:
            return .Unknown
        }
    }
}