//
//  LeaderboardService.swift
//  GroundGame
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

import Foundation
import MapKit
import SwiftyJSON

struct LeaderboardService {
    
    let api = API()
    
    func get(type: String, callback: (Leaderboard? -> Void)) {
        // type is one of "everyone", "state", "friends"
        api.get("rankings", parameters: ["type": type]) { (data, success, error, response) in
            
            if success {
                // Extract our addresses into models
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    let leaderboard = Leaderboard(json: json["data"])
                    
                    callback(leaderboard)
                }
                
            } else {
                // API call failed with no rankings
                callback(nil)
            }
        }
    }
    
}