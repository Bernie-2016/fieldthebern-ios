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

class HTTP {
    
    private var url: String!
    private var method: Alamofire.Method!
    private var parameters: [String: AnyObject]?
    private let session: Session = Session.sharedInstance
        
    func request(method: Alamofire.Method, _ url: String, parameters: [String: AnyObject]?) {
        session.reauthorize { (success) -> Void in
            if success {
                if let accessToken = self.session.oauth2?.accessToken {
                    let headers = ["Authorization": "Bearer \(accessToken)"]
                    Alamofire.request(method, url, parameters: parameters, headers: headers)
                        .responseJSON { response in
                            print(response)
                    }
                }
            }
        }
    }
}