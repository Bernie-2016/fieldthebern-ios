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
        api.post("users/me", parameters: nil) { (data, success) -> Void in
            
        }
    }
    
    func editMePhoto(photoString: String, callback: (User?) -> Void) {
        let parameters = UserJSON(base64PhotoData: photoString).json
        
        api.post("users/me", parameters: parameters.object as? [String : AnyObject]) { (data, success) -> Void in
            
        }
    }
}