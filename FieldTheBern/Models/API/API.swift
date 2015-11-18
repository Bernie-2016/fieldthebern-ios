//
//  API.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import Alamofire

class API {
    typealias APIResponse = (NSData?, Bool, APIError?) -> Void
    
    private let http = HTTP()
    private let baseURL = APIURL.url
    
    func get(endpoint: String, parameters: [String: AnyObject]?, callback: APIResponse) {
        let url = baseURL + "/" + endpoint
        http.authorizedRequest(.GET, url, parameters: parameters) { response in
            switch response.result {
            case .Success:
                callback(response.data, true, nil)
            case .Failure(let error):
                self.handleAPIFailure(response: response, error: error, callback: callback)
            }
        }
    }
    
    func post(endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, callback: APIResponse) {
        let url = baseURL + "/" + endpoint
                
        if let parameters = parameters {
            http.authorizedRequest(.POST, url, parameters: parameters, encoding: encoding) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true, nil)
                case .Failure(let error):
                    self.handleAPIFailure(response: response, error: error, callback: callback)
                }
            }
        }
    }

    func patch(endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, callback: APIResponse) {
        let url = baseURL + "/" + endpoint
        
        if let parameters = parameters {
            http.authorizedRequest(.PATCH, url, parameters: parameters, encoding: encoding) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true, nil)
                case .Failure(let error):
                    self.handleAPIFailure(response: response, error: error, callback: callback)
                }
            }
        }
    }

    func unauthorizedGet(endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, callback: APIResponse) {
        let url = baseURL + "/" + endpoint
        
        http.unauthorizedRequest(.GET, url, parameters: parameters, encoding: encoding) { response in
            switch response.result {
            case .Success:
                callback(response.data, true, nil)
            case .Failure(let error):
                self.handleAPIFailure(response: response, error: error, callback: callback)
            }
        }
    }

    func unauthorizedPost(endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .JSON, callback: APIResponse) {
        let url = baseURL + "/" + endpoint
        
        if let parameters = parameters {
            http.unauthorizedRequest(.POST, url, parameters: parameters, encoding: encoding) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true, nil)
                case .Failure(let error):
                    self.handleAPIFailure(response: response, error: error, callback: callback)
                }
            }
        }
    }
    
    private func handleAPIFailure(response response: Response<AnyObject, NSError>, error: NSError, callback: APIResponse) {
        if let httpResponse = response.response {
            let apiError = APIError(error: error, data: response.data, statusCode: httpResponse.statusCode)
            callback(response.data, false, apiError)
        } else {
            let apiError = APIError(error: error, data: response.data, statusCode: 503) // 503 because service is unavailable
            callback(response.data, false, apiError)
        }
    }
}