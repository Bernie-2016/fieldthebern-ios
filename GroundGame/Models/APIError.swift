//
//  APIError.swift
//  GroundGame
//
//  Created by Josh Smith on 10/28/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct APIError {
    
    var errorTitle: String = "Error"
    var errorDescription: String = "An unexpected error occurred."
    
    private let error: NSError?
    private let errorJSON: JSON?
    
    init(error: NSError?, data: NSData?) {
        self.error = error
        
        if let data = data {
            self.errorJSON = JSON(data: data)
        } else {
            self.errorJSON = nil
        }
        
        if let json = self.errorJSON {
            if json == JSON.null {
                // No JSON was returned from the server, use the error object
                if let error = self.error {
                    self.errorDescription = error.localizedDescription
                }
            } else {
                // We have JSON from the server, use that instead
                if let errorString = json["error"].string {
                    self.errorDescription = errorString
                }
            }
        }
    }
}