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
    
    typealias UserResponse = (User?, Bool, APIError?) -> Void
    
    let api = API()

    func createUser(email email: String, password: String, firstName: String, lastName: String, callback: UserResponse) {
        api.unauthorizedPost("users", parameters: ["email": email, "password": password, "first_name": firstName, "last_name": lastName]) { (data, success, error) in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func get(id: String, callback: UserResponse) {
        api.get("users", parameters: ["id": id]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func me(callback: UserResponse) {
        api.get("users/me", parameters: nil) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func editMe(json: UserJSON, callback: UserResponse) {
        api.post("users/me", parameters: json.json.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func updateMyDevice(deviceToken: String?, callback: UserResponse) {
        let parameters = DeviceJSON(deviceToken: deviceToken).json

        api.post("devices", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func editMePhoto(photoString: String, callback: UserResponse) {
        let parameters = UserJSON(base64PhotoData: photoString).json
        
        api.post("users/me", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func handleUserResponse(data: NSData?, _ success: Bool, _ error: APIError?, callback: UserResponse) {
        if success {
            // Extract our user into a model
            if let data = data {
                
                let json = JSON(data: data)
                
                let user = User(json: json)
                
                callback(user, success, nil)
            }
        } else {
            callback(nil, success, error)
        }
    }
}