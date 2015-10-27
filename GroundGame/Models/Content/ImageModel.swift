//
//  ImageModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class ImageModel: FTBContentModel {
    dynamic var imageURLString = ""
    dynamic var width = 0
    dynamic var height = 0
    
    dynamic var caption = ""
    dynamic var sourceURLString = ""
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        self.imageURLString = dictionary.getOptionalOrDefaultForKey(FTBConfig.TextKey, defaultValue: "")
        self.width = dictionary.getOptionalOrDefaultForKey(FTBConfig.WidthKey, defaultValue: 0)
        self.height = dictionary.getOptionalOrDefaultForKey(FTBConfig.HeightKey, defaultValue: 0)
        
        self.caption = dictionary.getOptionalOrDefaultForKey(FTBConfig.CaptionKey, defaultValue: "")
        self.sourceURLString = dictionary.getOptionalOrDefaultForKey(FTBConfig.SourceKey, defaultValue: "")
    }
    
    override func isValid() -> Bool {
        return super.isValid() && self.imageURLString != "" && self.width > 0 && self.height > 0
    }
}