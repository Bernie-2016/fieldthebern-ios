//
//  AddressService.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

struct AddressService {

    let api = API()
    
    func getAddress(address: Address, callback: ((Address?, [Person]?, Bool, APIError?) -> Void)) {
        let parameters = AddressJSON(address: address).attributes
        
        api.get("addresses", parameters: parameters) { (data, success, error) in
            
            if success {
            
                // Extract addresses and people into models
                if let data = data {
                    let json = JSON(data: data)
                    
                    var people: [Person] = []
                    
                    for (_, person) in json["included"] {
                        let newPerson = Person(json: person)
                        people.append(newPerson)
                    }
                    
                    let addressJSON = json["data"][0]
                    let address = Address(id: addressJSON["id"].string, addressJSON: addressJSON["attributes"])

                    callback(address, people, success, nil)
                }
            } else {
                if error?.statusCode == 404 {
                    callback(nil, nil, true, error)
                } else {
                    callback(nil, nil, success, error)
                }
            }
        }
    }
    
    func getAddresses(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, callback: (([Address]?, Bool, APIError?) -> Void)) {
        
        api.get("addresses", parameters: ["latitude": latitude, "longitude": longitude, "radius": radius]) { (data, success, error) in
            
            if success {
                // Extract our addresses into models
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    var addressesArray: [Address] = []
                    
                    for (_, addresses) in json {
                        for (_, address) in addresses {
                            let newAddress = Address(id: address["id"].string, addressJSON: address["attributes"])
                            addressesArray.append(newAddress)
                        }
                    }
                    
                    callback(addressesArray, success, nil)
                }
                
            } else {
                // API call failed with no addresses
                callback(nil, success, error)
            }
        }
    }

}