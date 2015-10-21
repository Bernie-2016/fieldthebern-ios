//
//  OAuth.swift
//  GroundGame
//
//  Created by Josh Smith on 10/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct OAuth {
    static let ClientId = "0ad2e3ecb80393a5e83732b0e89c15d0eecedcc31f22bfb3cbc0f31e2be11410"
    static let ClientSecret = "5dc507867184b8d77b0928ba51dd3f724e4c5ac786d3f153f53f34802abae682"
    static let AuthorizeURI = APIURL.url + "/oauth/token"
    static let TokenURI = APIURL.url + "http://api.lvh.me:3000/oauth/token"
}