//
//  Session.swift
//  GroundGame
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import p2_OAuth2
import KeychainAccess

struct OAuth {
    static let ClientId = "0ad2e3ecb80393a5e83732b0e89c15d0eecedcc31f22bfb3cbc0f31e2be11410"
    static let ClientSecret = "5dc507867184b8d77b0928ba51dd3f724e4c5ac786d3f153f53f34802abae682"
    static let AuthorizeURI = "http://api.lvh.me:3000/oauth/token"
    static let TokenURI = "http://api.lvh.me:3000/oauth/token"
}

enum SessionType {
    case Facebook, Email
}

class Session {
    
    static let sharedInstance = Session()

    var oauth2: OAuth2PasswordGrant?
    
    let keychain = Keychain(service: "com.groundgameapp.api")
    
    func authorize(email: String, password: String, callback: (Bool) -> Void) {
    
        let settings = [
            "client_id": OAuth.ClientId,
            "client_secret": OAuth.ClientSecret,
            "authorize_uri": OAuth.AuthorizeURI,
            "token_uri": OAuth.TokenURI,
            "scope": "",
            "redirect_uris": ["myapp://oauth/callback"],   // don't forget to register this scheme
            "keychain": true,
            "username": email,
            "password": password
        ] as OAuth2JSON
        
        self.oauth2 = OAuth2PasswordGrant(settings: settings)
        
        keychain["email"] = email
        keychain["password"] = password
        keychain["lastAuthentication"] = "email"

        internalAuthorize(self.oauth2, callback: callback)
    }
    
    func reauthorize(callback: (Bool) -> Void) {
        internalAuthorize(self.oauth2, callback: callback)
    }
    
    func authorizeWithFacebook(token: String, callback: (Bool) -> Void) {
        self.authorize("facebook", password: token, callback: callback)
        
        keychain["facebookAccessToken"] = token
        keychain["lastAuthentication"] = "facebook"
    }
    
    func attemptAuthorizationFromKeychain(callback: (Bool) -> Void) {
        
        if let lastAuthentication = keychain["lastAuthentication"] {
            if lastAuthentication == "email" {
                if let email = keychain["email"], let password = keychain["password"] {
                    self.authorize(email, password: password) { (success) -> Void in
                        callback(success)
                    }
                }
            } else if lastAuthentication == "facebook" {
                if let accessToken = keychain["facebookAccessToken"] {
                    self.authorizeWithFacebook(accessToken) { (success) -> Void in
                        callback(success)
                    }
                }
            }
        }
    }
    
    func logout() {
        if let oauth2 = self.oauth2 {
            oauth2.forgetTokens()
        }
    }
    
    private func internalAuthorize(oauth2: OAuth2PasswordGrant?, callback: (Bool) -> Void) {
        if let oauth2 = oauth2 {
            oauth2.onAuthorize = { parameters in
                callback(true)
            }
            
            oauth2.onFailure = { error in        // `error` is nil on cancel
                if error != nil {
                    print("Authorization went wrong: \(error!.localizedDescription)")
                }
                callback(false)
            }
            
            oauth2.authorize(params: nil, autoDismiss: true)
        } else {
            callback(false)
        }
    }
}