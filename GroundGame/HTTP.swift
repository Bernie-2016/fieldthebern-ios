//
//  HTTP.swift
//  GroundGame
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire
import SwiftyJSON

typealias HTTPCallback = (Response<AnyObject, NSError>) -> Void

class HTTP {
    
    private let session: Session = Session.sharedInstance
        
    func authorizedRequest(method: Alamofire.Method, _ url: String, parameters: [String: AnyObject]?, callback: HTTPCallback) {
        session.reauthorize { (success) -> Void in
            if success {
                if let accessToken = self.session.oauth2?.accessToken {
                    let headers = ["Authorization": "Bearer \(accessToken)"]
                    Alamofire.request(method, url, parameters: parameters, headers: headers)
                        .validate()
                        .responseJSON { response in
                            callback(response)
                    }
                }
            }
        }
    }
    
    func unauthorizedRequest(method: Alamofire.Method, _ url: String, parameters: [String: AnyObject]?, callback: HTTPCallback) {
        Alamofire.request(method, url, parameters: parameters)
            .validate()
            .responseJSON { response in
                callback(response)
        }
    }
}