//
//  VideoModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class VideoModel: FTBContentModel {
    dynamic var videoURLString = ""
    dynamic var youtubeId = ""
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        self.videoURLString = dictionary.getOptionalOrDefaultForKey(FTBConfig.VideoSourceKey, defaultValue: "")
        self.youtubeId = dictionary.getOptionalOrDefaultForKey(FTBConfig.IDKey, defaultValue: "")
    }
    
    override func isValid() -> Bool {
        return super.isValid() && self.videoURLString != "" && self.youtubeId != ""
    }
}