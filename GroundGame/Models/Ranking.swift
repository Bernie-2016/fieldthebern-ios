//
//  Ranking.swift
//  GroundGame
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Ranking {
    
    let userId: String?
    let rank: Int?
    let score: Int?

    var user: User?
    
    var scoreString: String? {
        get {
            if let score = self.score {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                return numberFormatter.stringFromNumber(score)
            } else {
                return nil
            }
        }
    }
    
    init(json: JSON) {
        self.userId = json["relationships"]["user"]["data"]["id"].string

        if let rankNumber = json["attributes"]["rank"].number {
            self.rank = Int(rankNumber)
        } else {
            self.rank = nil
        }
        
        if let scoreNumber = json["attributes"]["score"].number {
            self.score = Int(scoreNumber)
        } else {
            self.score = 0
        }
    }
}