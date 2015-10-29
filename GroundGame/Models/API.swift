//
//  API.swift
//  GroundGame
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import Alamofire

class API {
    private let http = HTTP()
    private let baseURL = APIURL.url
    
    func get(endpoint: String, parameters: [String: AnyObject]?, callback: (NSData?, Bool, APIError?) -> Void) {
        let url = baseURL + "/" + endpoint
        http.authorizedRequest(.GET, url, parameters: parameters) { response in
            switch response.result {
            case .Success:
                callback(response.data, true, nil)
            case .Failure(let error):
                let apiError = APIError(error: error, data: response.data)
                callback(response.data, false, apiError)
            }
        }
    }
    
    func post(endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, callback: (NSData?, Bool, APIError?) -> Void) {

        let url = baseURL + "/" + endpoint
                
        if let parameters = parameters {
            http.authorizedRequest(.POST, url, parameters: parameters, encoding: encoding) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true, nil)
                case .Failure(let error):
                    let apiError = APIError(error: error, data: response.data)
                    callback(response.data, false, apiError)
                }
            }
        }
    }
    
    func unauthorizedPost(endpoint: String, parameters: [String: AnyObject]?, callback: (NSData?, Bool, APIError?) -> Void) {
        
        let url = baseURL + "/" + endpoint
        
        if let parameters = parameters {
            http.unauthorizedRequest(.POST, url, parameters: ["data": ["attributes": parameters]]) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true, nil)
                case .Failure(let error):
                    let apiError = APIError(error: error, data: response.data)
                    callback(nil, false, apiError)
                }
            }
        }
    }
}