//
//  VisitJSON.swift
//  GroundGame
//
//  Created by Josh Smith on 10/14/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct VisitJSON {
    
    let json: JSON

    private let duration: Int
    private let address: Address
    private let people: [Person]?
    
    init(duration: Int, address: Address, people: [Person]?) {
        self.duration = duration
        self.address = address
        self.people = people
        
        let addressDictionary: [String: AnyObject] = AddressJSON(address: address).include
        let addressDictionaries: [[String: AnyObject]] = [addressDictionary]
        
        var peopleDictionaries: [[String: AnyObject]] = []
        if let people = people {
            for person in people {
                let personDictionary = PersonJSON(person: person).include
                peopleDictionaries.append(personDictionary)
            }
        }
        
        
        let parameters: JSON = [
            "data": [
                "attributes": [ "duration_sec": duration ]
            ],
            "included": peopleDictionaries + addressDictionaries
        ]
        
        json = parameters
    }
}