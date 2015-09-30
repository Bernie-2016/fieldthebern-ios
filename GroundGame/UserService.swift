//
//  UserService.swift
//  GroundGame
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserService {
    
    let api = API()

    func createUser(email email: String, password: String, completion: (Bool) -> Void) {
        api.unauthorizedPost("users", parameters: ["email": email, "password": password]) { response in
            print(response)
            completion(true)
        }
    }
}