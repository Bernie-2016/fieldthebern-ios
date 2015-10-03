//
//  AddressService.swift
//  GroundGame
//
//  Created by Josh Smith on 10/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

struct AddressService {

    let api = API()
    
    func getAddresses(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, callback: ([Address]? -> Void)) {
        
        api.get("addresses", parameters: ["latitude": latitude, "longitude": longitude, "radius": radius]) { (data, success) in
            
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
                    
                    callback(addressesArray)
                }
                
            } else {
                // API call failed with no addresses
                callback(nil)
            }
        }
    }

}