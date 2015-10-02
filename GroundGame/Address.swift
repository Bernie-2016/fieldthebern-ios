//
//  Address.swift
//  GroundGame
//
//  Created by Josh Smith on 10/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

struct Address {
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let street1: String?
    let street2: String?
    let city: String?
    let stateCode: String?
    let zipCode: String?
    let coordinate: CLLocationCoordinate2D?
    
    init(addressJSON: JSON) {
        latitude = addressJSON["latitude"].number as? CLLocationDegrees
        longitude = addressJSON["longitude"].number as? CLLocationDegrees
        street1 = addressJSON["street_1"].string
        street2 = addressJSON["street_2"].string
        city = addressJSON["city"].string
        stateCode = addressJSON["state_code"].string
        zipCode = addressJSON["zip_code"].string
        
        if let latitude = latitude, let longitude = longitude {
            coordinate = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
    }
}