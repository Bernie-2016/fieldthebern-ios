//
//  Compatibility.swift
//  FieldTheBern
//
//  Created by Josh Smith on 11/17/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

class Compatibility {
    
    static let sharedInstance = Compatibility()
    
    private init() {}
    
    func checkCompatibility(callback: (Bool -> Void)) {
        
        let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        
        CompatibilityService().checkCompatibility(versionNumber) { (success, isCompatible) -> Void in

            if success {
                if let isCompatible = isCompatible {
                    callback(isCompatible)
                } else {
                    callback(false)
                }
            } else {
                callback(false)
            }
        }
    }
}