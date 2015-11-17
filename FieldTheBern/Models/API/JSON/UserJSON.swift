//
//  UserJSON.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/24/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserJSON {
    
    let json: JSON
    
    init(firstName: String?, lastName: String?, email: String?) {
        
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
    
    init(firstName: String, lastName: String, email: String, password: String, facebookId: String?, facebookAccessToken: String?, base64PhotoData: String?) {
        
        let parameters: JSON = [
            "data": [
                "attributes": [
                    "first_name": firstName ?? NSNull(),
                    "last_name": lastName ?? NSNull(),
                    "email": email ?? NSNull(),
                    "password": password ?? NSNull(),
                    "facebook_id": facebookId ?? NSNull(),
                    "facebook_access_token": facebookAccessToken ?? NSNull(),
                    "base_64_photo_data": base64PhotoData ?? NSNull()
                ]
            ]
        ]
                
        self.json = parameters
    }
    
    init(base64PhotoData: String?) {
        
        let parameters: JSON = [
            "data": [
                "attributes": [ "base_64_photo_data": base64PhotoData ?? NSNull() ]
            ]
        ]

        self.json = parameters
    }
}