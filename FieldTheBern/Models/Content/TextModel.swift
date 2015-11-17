//
//  TextModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class TextModel: FTBContentModel {
    dynamic var text = ""
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        self.text = dictionary.getOptionalOrDefaultForKey(FTBConfig.TextKey, defaultValue: "")
    }
    
    override func isValid() -> Bool {
        return super.isValid() && self.text != ""
    }
}

class HeaderModel: TextModel {}
class TitleModel: TextModel {}
class SubtitleModel: TextModel {}
class CaptionModel: TextModel {}