//
//  OAuth.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct OAuth {
    static let ClientId = "f882c6bce6c71cd90181b27821e404a3927c4d4fe2c90a8ff715a7cb52c3dc57"
    static let ClientSecret = "9815b06d0edc2e616c92cd926473f5bdcaf9b4382dc5d436536cb94d58196654"
    static let AuthorizeURI = APIURL.url + "/oauth/token"
    static let TokenURI = APIURL.url + "/oauth/token"
}