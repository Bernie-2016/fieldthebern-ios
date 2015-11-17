//
//  ContentModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class FTBContentModel: FTBModel {
    dynamic var type = "Content"
    
    func updateToDictionary(dictionary: NSDictionary) {
        self.type = dictionary.getOptionalOrDefaultForKey(FTBConfig.TypeKey, defaultValue: "")
    }
    
    func isValid() -> Bool { return self.type != "" }
}