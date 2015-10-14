//
//  VisitService.swift
//  GroundGame
//
//  Created by Josh Smith on 10/13/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

struct VisitService {
    
    let api = API()
    
    func postVisit(duration: Int, address: Address, people: [Person]?) {
        
        let parameters = VisitJSON(duration: duration, address: address, people: people).json()
        
        api.post("visits", parameters: parameters.object as? [String : AnyObject], encoding: .JSON) { (data, success) in
        }
    }
    
}

struct PersonJSON {
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
    }
    
    func attributes() -> [String: AnyObject] {
        return [
            "first_name": firstName ?? NSNull(),
            "last_name": lastName ?? NSNull(),
            "party_affiliation": partyAffiliationString,
            "canvas_response": canvasResponseJSONString
        ]
    }
    
    func include() -> [String: AnyObject] {
        return [
            "type": "people",
            "id": id ?? NSNull(),
            "attributes": self.attributes()
        ]
    }
}

struct AddressJSON {
    let id: AnyObject
    let latitude: AnyObject
    let longitude: AnyObject
    let street1: AnyObject
    let street2: AnyObject
    let city: AnyObject
    let stateCode: AnyObject
    let zipCode: AnyObject
    
    init(address: Address) {
        id = address.id ?? NSNull()
        latitude = address.latitude ?? NSNull()
        longitude = address.longitude ?? NSNull()
        street1 = address.street1 ?? NSNull()
        street2 = address.street2 ?? NSNull()
        city = address.city ?? NSNull()
        stateCode = address.stateCode ?? NSNull()
        zipCode = address.zipCode ?? NSNull()
    }
    
    func attributes() -> [String: AnyObject] {
        return [
            "latitude": latitude,
            "longitude": longitude,
            "street_1": street1,
            "street_2": street2,
            "city": city,
            "state_code": stateCode,
            "zip_code": zipCode
        ]
    }
    
    func include() -> [String: AnyObject] {
        return [
            "type": "addresses",
            "id": id,
            "attributes": self.attributes()
        ]
    }
}

struct VisitJSON {
    
    private let duration: Int
    private let address: Address
    private let people: [Person]?
    
    init(duration: Int, address: Address, people: [Person]?) {
        self.duration = duration
        self.address = address
        self.people = people
    }
    
    func json() -> JSON {
        
        let addressDictionary: [String: AnyObject] = AddressJSON(address: address).include()
        let addressDictionaries: [[String: AnyObject]] = [addressDictionary]
        
        var peopleDictionaries: [[String: AnyObject]] = []
        if let people = people {
            for person in people {
                let personDictionary = PersonJSON(person: person).include()
                peopleDictionaries.append(personDictionary)
            }
        }
        
        let parameters: JSON = [
            "data": [
                "attributes": [ "duration_sec": duration ]
            ],
            "included": peopleDictionaries + addressDictionaries
        ]
        
        return parameters
    }
}