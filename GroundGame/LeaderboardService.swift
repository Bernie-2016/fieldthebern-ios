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
    
    func getEveryone(callback: (Leaderboard? -> Void)) {
        
        api.get("rankings", parameters: ["type": "all"]) { (data, success, error, response) in
            
            if success {
                // Extract our addresses into models
                if let data = data {
                    
                    let json = JSON(data: data)
                    
                    let leaderboard = Leaderboard(json: json)
                    
                    callback(leaderboard)
                }
                
            } else {
                // API call failed with no rankings
                callback(nil)
            }
        }
    }
    
}