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

    var name: String? = nil
    var photoThumbURL: String? = nil
    
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
        self.userId = json["member"].string

        if let rankNumber = json["rank"].number {
            self.rank = Int(rankNumber)
        } else {
            self.rank = nil
        }

        if let scoreNumber = json["score"].number {
            self.score = Int(scoreNumber)
        } else {
            self.score = 0
        }
        
        if let memberData = json["member_data"].string {
            if let dataFromString = memberData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)

                self.name = json["name"].string
                print(json)
                self.photoThumbURL = json["photo_thumb_url"].string
            }
        }
    }
}