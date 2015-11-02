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
    
    init(firstName: String?, lastName: String?, email: String?) {
        base64PhotoData = nil
        
        let parameters: JSON = [
            "data": [
                "attributes": [
                    "first_name": firstName ?? NSNull(),
                    "last_name": lastName ?? NSNull(),
                    "email": email ?? NSNull(),
                ]
            ]
        ]
        
        self.json = parameters
    }
    
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