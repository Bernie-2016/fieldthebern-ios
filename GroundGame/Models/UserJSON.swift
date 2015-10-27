//
//  UserJSON.swift
//  GroundGame
//
//  Created by Josh Smith on 10/24/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserJSON {
    
    let json: JSON

    let base64PhotoData: String?
    
//    init(user: User) {
//        id = person.id
//        firstName = person.firstName
//        lastName = person.lastName
//        partyAffiliationString = person.partyAffiliationString
//        canvasResponseJSONString = person.canvasResponse.JSONString()
//        
//        attributes = [
//            "first_name": firstName ?? NSNull(),
//            "last_name": lastName ?? NSNull(),
//            "party_affiliation": partyAffiliationString,
//            "canvas_response": canvasResponseJSONString
//        ]
//        
//        include = [
//            "type": "people",
//            "id": id ?? NSNull(),
//            "attributes": self.attributes
//        ]
//    }
    
    init(base64PhotoData: String?) {
        self.base64PhotoData = base64PhotoData
        
        let parameters: JSON = [
            "data": [
                "attributes": [ "base_64_photo_data": base64PhotoData ?? NSNull() ]
            ]
        ]

        self.json = parameters
    }
}