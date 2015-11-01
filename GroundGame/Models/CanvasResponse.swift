//
//  CanvasResponse.swift
//  GroundGame
//
//  Created by Josh Smith on 10/10/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

enum CanvasResponse {
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
            return "Unknown"
        case .StronglyAgainst:
            return "Strongly against"
        case .LeaningAgainst:
            return "Leaning against"
        case .Undecided:
            return "Undecided"
        case .LeaningFor:
            return "Leaning for"
        case .StronglyFor:
            return "Strongly for"
        }
    }
    
    static func fromJSONString(string: String) -> CanvasResponse {
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