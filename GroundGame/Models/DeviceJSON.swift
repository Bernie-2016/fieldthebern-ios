//
//  DeviceJSON.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/30/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DeviceJSON {
    
    let json: JSON
    
    let deviceToken: String?
    
    init(deviceToken: String?) {
        self.deviceToken = deviceToken
        
        let parameters: JSON = [
            "data": [
                "attributes": [
                    "token": deviceToken ?? NSNull(),
                    "platform": "ios",
                    "enabled": true
                ]
            ]
        ]
        
        self.json = parameters
    }
}