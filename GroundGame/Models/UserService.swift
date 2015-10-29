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

    func createUser(email email: String, password: String, firstName: String, lastName: String, completion: (Bool) -> Void) {
        api.unauthorizedPost("users", parameters: ["email": email, "password": password, "first_name": firstName, "last_name": lastName]) { (data, success, error, response) in
            completion(success)
        }
    }
    
    func get(id: String, callback: (User?) -> Void) {
        api.get("users", parameters: ["id": id]) { (data, success, error, response) -> Void in
            
        }
    }
    
    func me(callback: (User?) -> Void) {
        api.get("users/me", parameters: nil) { (data, success, error, response) -> Void in
            if success {
                // Extract our visit into a model
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    let user = User(json: json)
                    
                    callback(user)
                }
            }
        }
    }
    
    func editMe(me: Person, callback: (User?) -> Void) {
        api.post("users/me", parameters: nil) { (data, success, error) -> Void in
            
        }
    }
    
    func editMePhoto(photoString: String, callback: (User?) -> Void) {
        let parameters = UserJSON(base64PhotoData: photoString).json
        
        api.post("users/me", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            
        }
    }
}