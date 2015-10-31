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
import FBSDKLoginKit
import Parse

class Session {
    
    static let sharedInstance = Session()
    
    private init() {}

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
        
        oauth2?.forgetTokens() // We must explicitly call this to avoid data hanging around
        
        self.oauth2 = OAuth2PasswordGrant(settings: settings)
        
        if email != "facebook" {
            keychain["email"] = email
            keychain["password"] = password
            keychain["lastAuthentication"] = "email"
        }
        
        internalAuthorize(self.oauth2, callback: callback)
        
        // Update device token for push notifications
        UserService().updateMyDevice(PFInstallation.currentInstallation().deviceToken, callback: { (success) -> Void in
            print(success)
        })
    }
    
    func reauthorize(callback: (Bool) -> Void) {
        internalAuthorize(self.oauth2, callback: callback)
    }
    
    func authorizeWithFacebook(token token: FBSDKAccessToken, callback: (Bool) -> Void) {
        self.authorize("facebook", password: token.tokenString, callback: callback)
        
        // Reset other login information if this is a different facebook user
        if let facebookId = keychain["facebookId"] {
            if token.userID != facebookId {
                keychain["email"] = nil
                keychain["password"] = nil
            }
        }

        keychain["facebookId"] = token.userID
        keychain["facebookAccessToken"] = token.tokenString
        keychain["lastAuthentication"] = "facebook"
    }
    
    func authorizeWithFacebook(tokenString tokenString: String, callback: (Bool) -> Void) {
        self.authorize("facebook", password: tokenString, callback: callback)

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
                    self.authorizeWithFacebook(tokenString: accessToken) { (success) -> Void in
                        callback(success)
                    }
                }
            }
        }
    }
    
    func logout() {
        self.oauth2?.forgetTokens()
        
        // Reset everything in the keychain
        keychain["email"] = nil
        keychain["password"] = nil
        keychain["facebookId"] = nil
        keychain["facebookAccessToken"] = nil
        keychain["lastAuthentication"] = nil
        
        FBSDKLoginManager().logOut()
    }
    
    private func internalAuthorize(oauth2: OAuth2PasswordGrant?, callback: (Bool) -> Void) {

        if let oauth2 = oauth2 {
            oauth2.onAuthorize = { parameters in
                callback(true)
            }
            
            oauth2.onFailure = { error in        // `error` is nil on cancel
                if error != nil {
                    log.error("Authorization went wrong: \(error!.localizedDescription)")
                }
                callback(false)
            }
            
            oauth2.authorize(params: nil, autoDismiss: true)
        } else {
            callback(false)
        }
    }
}