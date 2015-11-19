//
//  Address.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON
import UIKit

struct Address {
    let id: String?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let street1: String?
    let street2: String?
    let city: String?
    let stateCode: String?
    let zipCode: String?
    let coordinate: CLLocationCoordinate2D?
    let visitedAt: NSDate?

    var bestResult: VisitResult = .NotVisited
    var lastResult: VisitResult = .Unknown
    var bestCanvassResponseString: String?

    var title: String {
        get {
            if let street1 = street1, street2 = street2 {
                let string = street1 + " " + street2
                return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            } else if let street1 = street1 {
                return street1
            } else {
                return ""
            }
        }
    }
    
    var subtitle: String {
        get {
            switch displayedResult {
            case .NotVisited:
                return "Not yet visited"
            case .NotHome:
                return "No one was home"
            case .Unknown:
                return "Not yet visited"
            case .LeaningAgainst:
                return "Leaning against Bernie"
            case .LeaningFor:
                return "Leaning for Bernie"
            case .StronglyAgainst:
                return "Strongly against Bernie"
            case .StronglyFor:
                return "Strongly for Bernie"
            case .Undecided:
                return "Undecided about Bernie"
            }
        }
    }
    
    var image: UIImage? {
        get {
            switch displayedResult {
            case .NotVisited:
                return PinImage.Gray
            case .NotHome:
                return PinImage.Gray
            case .Unknown:
                return PinImage.Gray
            case .LeaningAgainst:
                return PinImage.Pink
            case .LeaningFor:
                return PinImage.LightBlue
            case .StronglyAgainst:
                return PinImage.Red
            case .StronglyFor:
                return PinImage.Blue
            case .Undecided:
                return PinImage.White
            }
        }
    }
    
    var latitudeFloat: Float? {
        get {
            if let latitude = latitude {
                return Float(latitude)
            }
            return nil
        }
    }

    var longitudeFloat: Float? {
        get {
            if let longitude = longitude {
                return Float(longitude)
            }
            return nil
        }
    }
    
    var displayedResult: VisitResult {
        get {
            if lastResult == .NotHome {
                return lastResult
            } else {
                return bestResult
            }
        }
    }
    
    var visitedAtString: String? {
        get {
            if let date = visitedAt {
                return NSDate().offsetFrom(date)
            } else {
                return nil
            }
        }
    }

    init(id: String?, addressJSON: JSON) {
        self.id = id
        latitude = addressJSON["latitude"].number as? CLLocationDegrees
        longitude = addressJSON["longitude"].number as? CLLocationDegrees
        street1 = addressJSON["street_1"].string
        street2 = addressJSON["street_2"].string
        city = addressJSON["city"].string
        stateCode = addressJSON["state_code"].string
        zipCode = addressJSON["zip_code"].string

        if let dateString = addressJSON["visited_at"].string {
            visitedAt = NSDate.dateFromISOString(dateString)
        } else {
            visitedAt = NSDate()
        }
        
        if let bestResultString = addressJSON["best_canvass_response"].string {
            switch bestResultString {
            case "not_visited":
                bestResult = .NotVisited
            case "not_home":
                bestResult = .NotHome
            case "unknown":
                bestResult = .Unknown
            case "strongly_for":
                bestResult = .StronglyFor
            case "leaning_for":
                bestResult = .LeaningFor
            case "undecided":
                bestResult = .Undecided
            case "leaning_against":
                bestResult = .LeaningAgainst
            case "strongly_against":
                bestResult = .StronglyAgainst
            default:
                bestResult = .NotVisited
            }
        }

        if let lastResultString = addressJSON["last_canvass_response"].string {
            switch lastResultString {
            case "not_visited":
                lastResult = .NotVisited
            case "not_home":
                lastResult = .NotHome
            case "unknown":
                lastResult = .Unknown
            case "strongly_for":
                lastResult = .StronglyFor
            case "leaning_for":
                lastResult = .LeaningFor
            case "undecided":
                lastResult = .Undecided
            case "leaning_against":
                lastResult = .LeaningAgainst
            case "strongly_against":
                lastResult = .StronglyAgainst
            default:
                lastResult = .NotVisited
            }
        }

        if let latitude = latitude, let longitude = longitude {
            coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
    }
    
    init(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, street1: String?, street2: String?, city: String?, stateCode: String?, zipCode: String?, bestResult: VisitResult, lastResult: VisitResult) {
        self.id = nil
        self.latitude = latitude
        self.longitude = longitude
        self.street1 = street1
        self.street2 = street2
        self.city = city
        self.stateCode = stateCode
        self.zipCode = zipCode
        self.bestResult = bestResult
        self.lastResult = lastResult
        self.visitedAt = nil

        if let latitude = latitude, let longitude = longitude {
            self.coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
    }
}