//
//  ItemModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import RealmSwift

let FTBItemModelPrimaryKey = "modelId"

class FTBItemModel: Object, FTBModel {
    dynamic var modelId = ""
    dynamic var type = ""
    dynamic var title = ""
    dynamic var url = ""
    dynamic var imageURLStr = ""
    dynamic var superlevel = false
    
    func updateToDictionary(dictionary: NSDictionary) {
        self.modelId = dictionary.getOptionalOrDefaultForKey(FTBConfig.URLKey, defaultValue: "")
        self.url = dictionary.getOptionalOrDefaultForKey(FTBConfig.URLKey, defaultValue: "")
        self.type = dictionary.getOptionalOrDefaultForKey(FTBConfig.TypeKey, defaultValue: "")
        
        self.title = dictionary.getOptionalOrDefaultForKey(FTBConfig.TitleKey, defaultValue: "")
        self.imageURLStr = dictionary.getOptionalOrDefaultForKey(FTBConfig.ImageThumbKey, defaultValue: "")
    }
    
    func isValid() -> Bool { return self.type != "" && self.modelId != "" && self.title != "" }
    
    override static func primaryKey() -> String? { return FTBItemModelPrimaryKey }
}