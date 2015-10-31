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
    
    typealias SuccessResponse = (Bool) -> Void
    
    static let sharedInstance = Session()
    
    private init() {}

    var oauth2: OAuth2PasswordGrant?
    
    let keychain = Keychain(service: "com.groundgameapp.api")
    
    func authorize(email: String, password: String, callback: SuccessResponse) {
        
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

        self.internalAuthorize(self.oauth2, callback: callback)
        
        // Update device token for push notifications
        UserService().updateMyDevice(PFInstallation.currentInstallation().deviceToken, callback: { (success) -> Void in
            print(success)
        })
    }
    
    func reauthorize(callback: SuccessResponse) {
        internalAuthorize(self.oauth2, callback: callback)
    }
    
    func authorizeWithFacebook(token token: FBSDKAccessToken, callback: SuccessResponse) {
        
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

        self.authorize("facebook", password: token.tokenString, callback: callback)
    }
    
    private func authorizeWithFacebook(tokenString tokenString: String, callback: SuccessResponse) {
        keychain["lastAuthentication"] = "facebook"

        self.authorize("facebook", password: tokenString, callback: callback)
    }
    
    func attemptAuthorizationFromKeychain(callback: SuccessResponse) {

        if let lastAuthentication = keychain["lastAuthentication"] {
            if lastAuthentication == "email" {
                if let email = keychain["email"], let password = keychain["password"] {
                    self.authorize(email, password: password, callback: callback)
                }
            } else if lastAuthentication == "facebook" {
                if let accessToken = keychain["facebookAccessToken"] {
                    self.authorizeWithFacebook(tokenString: accessToken, callback: callback)
                }
            }
        } else {
            callback(false)
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
    
    private func internalAuthorize(oauth2: OAuth2PasswordGrant?, callback: SuccessResponse) {
        if let oauth2 = self.oauth2 {

            oauth2.onAuthorize = { parameters in
                callback(true)
            }
            
            oauth2.onFailure = { error in   // `error` is nil on cancel
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