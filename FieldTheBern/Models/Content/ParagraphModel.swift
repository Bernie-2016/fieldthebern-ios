//
//  ParagraphModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class ParagraphModel: FTBContentModel {
    dynamic var paragraph = ""
    var links = [LinkModel]()
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        self.paragraph = dictionary.getOptionalOrDefaultForKey(FTBConfig.TextKey, defaultValue: "")
        
        let linkDictionaries = dictionary.getOptionalOrDefaultForKey(FTBConfig.LinksKey, defaultValue: NSArray())
        linkDictionaries.mapTo { (linkDictionary: NSDictionary) in
            let link = LinkModel()
            link.updateToDictionary(linkDictionary)
            self.links.append(link)
        }
    }
    
    override func isValid() -> Bool {
        let nospaces = self.paragraph.stringByReplacingOccurrencesOfString(" ", withString: "")
        return super.isValid() && self.paragraph != "" && nospaces != ""
    }
}