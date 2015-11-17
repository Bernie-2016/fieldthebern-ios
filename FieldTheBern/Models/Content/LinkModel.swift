//
//  LinkModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class LinkModel: FTBContentModel {
    dynamic var urlString = ""
    dynamic var start = 0
    dynamic var end = 0
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        self.urlString = dictionary.getOptionalOrDefaultForKey(FTBConfig.HREFKey, defaultValue: "")
        self.start = dictionary.getOptionalOrDefaultForKey(FTBConfig.StartKey, defaultValue: 0)
        self.end = dictionary.getOptionalOrDefaultForKey(FTBConfig.EndKey, defaultValue: 0)
    }
    
    override func isValid() -> Bool {
        return super.isValid() && self.urlString != "" && self.start >= 0 && self.end >= 0
    }
}