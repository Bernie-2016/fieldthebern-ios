//
//  Leaderboard.swift
//  GroundGame
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Leaderboard {
    
    let rankings: [Ranking]
    
    init(json: JSON) {
        var rankingsTemp: [Ranking] = []
        
        for(_, ranking) in json {
            let newRanking = Ranking(json: ranking)
            rankingsTemp.append(newRanking)
        }
        
        rankings = rankingsTemp
    }
}