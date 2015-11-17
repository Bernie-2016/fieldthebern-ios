//
//  UserService.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserService {
    
    typealias UserResponse = (User?, Bool, APIError?) -> Void
    
    let api = API()

    func createUser(email email: String, password: String, firstName: String, lastName: String, photoString: String?, callback: UserResponse) {
        
        let json = UserJSON(firstName: firstName, lastName: lastName, email: email, password: password, facebookId: nil, facebookAccessToken: nil, base64PhotoData: photoString).json

        api.unauthorizedPost("users", parameters: json.object as? [String : AnyObject]) { (data, success, error) in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func createUser(email email: String, password: String, firstName: String, lastName: String, facebookAccessToken: String?, facebookId: String?, photoString: String?, callback: UserResponse) {

        let json = UserJSON(firstName: firstName, lastName: lastName, email: email, password: password, facebookId: facebookId, facebookAccessToken: facebookAccessToken, base64PhotoData: photoString).json
        
        api.unauthorizedPost("users", parameters: json.object as? [String : AnyObject]) { (data, success, error) in
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
        api.patch("users/me", parameters: json.json.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func updateMyDevice(deviceToken: String?, callback: UserResponse) {
        let parameters = DeviceJSON(deviceToken: deviceToken).json

        api.patch("devices", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func editMePhoto(photoString: String, callback: UserResponse) {
        let parameters = UserJSON(base64PhotoData: photoString).json
        
        api.patch("users/me", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func checkUserWithFacebookIdExists(facebookId: String, callback: (userExists: Bool, apiSuccess: Bool, APIError?) -> Void) {
        let parameters: JSON = [
            "data": [
                "attributes": [
                    "facebook_id": facebookId
                ]
            ]
        ]
        
        api.unauthorizedGet("users/lookup", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            if success {
                if let data = data {
                    let json = JSON(data: data)
                    
                    if json["data"].count > 0 {
                        callback(userExists: true, apiSuccess: success, error)
                    } else {
                        callback(userExists: false, apiSuccess: success, error)
                    }

                } else {
                    callback(userExists: false, apiSuccess: success, error)
                }
            } else {
                callback(userExists: false, apiSuccess: success, error)
            }
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