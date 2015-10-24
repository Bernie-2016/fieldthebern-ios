//
//  String.swift
//  GroundGame
//
//  Created by Alon Rosenfeld on 10/24/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail : Bool {
        
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(self)
    }
}