//
//  AddressJSON.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/14/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct AddressJSON {
    
    let attributes: [String: AnyObject]
    let include: [String: AnyObject]
    
    let id: AnyObject
    let latitude: AnyObject
    let longitude: AnyObject
    let street1: AnyObject
    let street2: AnyObject
    let city: AnyObject
    let stateCode: AnyObject
    let zipCode: AnyObject
    let bestCanvassResponseString: AnyObject
    
    init(address: Address) {
        id = address.id ?? NSNull()
        latitude = address.latitude ?? NSNull()
        longitude = address.longitude ?? NSNull()
        street1 = address.street1 ?? NSNull()
        street2 = address.street2 ?? NSNull()
        city = address.city ?? NSNull()
        stateCode = address.stateCode ?? NSNull()
        zipCode = address.zipCode ?? NSNull()
        bestCanvassResponseString = address.bestCanvassResponseString ?? NSNull()
        
        attributes = [
            "latitude": latitude,
            "longitude": longitude,
            "street_1": street1,
            "street_2": street2,
            "city": city,
            "state_code": stateCode,
            "zip_code": zipCode,
            "best_canvass_response": bestCanvassResponseString
        ]

        include = [
            "type": "addresses",
            "id": id,
            "attributes": self.attributes
        ]
    }
}