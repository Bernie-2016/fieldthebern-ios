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
    private var address: Address
    private let people: [Person]?
    
    init(duration: Int, address: Address, people: [Person]?, askedToLeave: Bool) {
        self.duration = duration
        self.address = address
        self.people = people
                
        let peopleAreHome: Bool = self.people?.count > 0
        
        if askedToLeave && !peopleAreHome {
            // This must come first, since you could have no people and still be asked to leave
            self.address.bestCanvasResponse = "asked_to_leave"
        } else if !peopleAreHome {
            self.address.bestCanvasResponse = "not_home"
        } else {
            self.address.bestCanvasResponse = nil
        }
        
        let addressDictionary: [String: AnyObject] = AddressJSON(address: self.address).include
        let addressDictionaries: [[String: AnyObject]] = [addressDictionary]
                
        var peopleDictionaries: [[String: AnyObject]] = []
        if let people = self.people {
            for person in people {
                let personDictionary = PersonJSON(person: person).include
                peopleDictionaries.append(personDictionary)
            }
        }
        
        let parameters: JSON = [
            "data": [
                "attributes": [
                    "duration_sec": duration
                ]
            ],
            "included": peopleDictionaries + addressDictionaries
        ]
        
        json = parameters
    }
}