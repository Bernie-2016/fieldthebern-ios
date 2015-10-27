//
//  ModelTypeMap.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

class ModelMap {
    static func modelForDictionary(dictionary: NSDictionary) -> FTBModel? {
        guard let type = dictionary.objectForKey("type") as? String else { return nil }
        
        var model: FTBModel?
        switch type {
            case "collection":
                model = ItemCollectionModel()
            case "page":
                model = PageModel()
            case "link":
                model = LinkModel()
            case "header", "h1":
                model = HeaderModel()
            case "title", "h2":
                model = TitleModel()
            case "subtitle", "h3":
                model = SubtitleModel()
            case "caption", "quote":
                model = CaptionModel()
            case "paragraph", "p":
                model = ParagraphModel()
            case "image", "img":
                model = ImageModel()
            case "video":
                model = VideoModel()
            case "list":
                model = ListModel()
            default:
            return model
        }
        
        model?.updateToDictionary(dictionary)
        return model
    }
}