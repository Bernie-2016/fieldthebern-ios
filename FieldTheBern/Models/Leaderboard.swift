//
//  Leaderboard.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Leaderboard {
    
    let rankings: [Ranking]
    
    init(json: JSON) {
        let rankings = json["data"]
        let users = json["included"]
        
        var rankingsTemp: [Ranking] = []

        for(_, ranking) in rankings {
            var newRanking = Ranking(json: ranking)

            for(_, user) in users {
                if let rankingUserId = newRanking.userId {
                    if let userId = user["id"].string {
                        if rankingUserId == userId {
                            let newUser = User(userJSON: user)
                            newRanking.user = newUser
                            rankingsTemp.append(newRanking)
                        }
                    }
                }
            }
        }
        
        self.rankings = rankingsTemp
    }
}