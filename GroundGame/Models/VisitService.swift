//
//  VisitService.swift
//  GroundGame
//
//  Created by Josh Smith on 10/13/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

struct VisitService {
    
    let api = API()
    
    func postVisit(duration: Int, address: Address, people: [Person]?, askedToLeave: Bool, callback: ((Visit?, Bool, APIError?) -> Void)) {
        
        let parameters = VisitJSON(duration: duration, address: address, people: people, askedToLeave: askedToLeave).json

        print(parameters)

        api.post("visits", parameters: parameters.object as? [String : AnyObject], encoding: .JSON) { (data, success, error) in
            if success {
                // Extract our visit into a model
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    let visit = Visit(json: json)
                    
                    callback(visit, success, nil)
                }
            } else {
                callback(nil, success, error)
            }
        }
    }
    
}