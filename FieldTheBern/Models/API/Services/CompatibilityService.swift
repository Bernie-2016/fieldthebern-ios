//
//  CompatibilityService.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/17/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CompatibilityService {
    
    let api = API()
    
    func checkCompatibility(versionNumber: String, callback: ((success: Bool, isCompatible: Bool?) -> Void)) {

        api.unauthorizedGet("compatibility", parameters: ["version": versionNumber]) { (data, success, error) in

            if success {
                // Extract our addresses into models
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    if let compatible = json["compatible"].bool {
                        callback(success: true, isCompatible: compatible)
                    } else {
                        callback(success: true, isCompatible: false)
                    }
                }
                
            } else {
                // API call failed
                callback(success: false, isCompatible: nil)
            }
        }
    }
    
}