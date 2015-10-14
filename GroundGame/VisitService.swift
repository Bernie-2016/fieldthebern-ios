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
    
    func postVisit(duration: Int, address: Address, people: [Person]?) {
        
        let parameters = VisitJSON(duration: duration, address: address, people: people).json
        
        api.post("visits", parameters: parameters.object as? [String : AnyObject], encoding: .JSON) { (data, success) in
        }
    }
    
}