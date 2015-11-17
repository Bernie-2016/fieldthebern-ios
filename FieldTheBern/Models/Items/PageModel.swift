//
//  PageModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import RealmSwift

class PageModel: FTBItemModel {
    private var contentModels: [FTBContentModel]?
    
    // Realm models can only be stored as a single type, no subclasses. So the content json is stored as a string to be loaded into an array of models when needed.
    dynamic var contentJSONStr = NSData()
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        
        let contentDictionaries = dictionary.getOptionalOrDefaultForKey(FTBConfig.ContentKey, defaultValue: NSArray())
        saveContentDictionaries(contentDictionaries)
        
        createContentModels(contentDictionaries)
    }
    
    //
    // MARK: Content JSON Models
    //
    
    func saveContentDictionaries(contentDictionaries: NSArray) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(contentDictionaries, options: NSJSONWritingOptions.PrettyPrinted)
            self.contentJSONStr = data
        }
        catch _ {}
    }
    
    func loadContentDictionaries() -> NSArray {
        do {
            guard let contentDictionaries = try NSJSONSerialization.JSONObjectWithData(contentJSONStr, options: NSJSONReadingOptions.AllowFragments) as? NSArray else { return NSArray() }
            return contentDictionaries
        }
        catch _ {}
        return NSArray()
    }
    
    //
    // MARK: Content Methods
    //
    
    func getContentModels() -> [FTBContentModel] {
        if let contentModels = contentModels {
            return contentModels
        }
        else {
            let contentDictionaries = loadContentDictionaries()
            createContentModels(contentDictionaries)
            if let contentModels = contentModels { return contentModels }
        }
        
        return [FTBContentModel]()
    }
    
    private func createContentModels(contentDictionaries: NSArray) {
        self.contentModels = [FTBContentModel]()
        contentDictionaries.mapTo { (contentDictionary: NSDictionary) in
            guard let model = ModelMap.modelForDictionary(contentDictionary) as? FTBContentModel else { return }
            guard model.isValid() else { return }
            self.contentModels?.append(model)
        }
    }
    
    //
    // MARK: Realm Models
    //
    
    override static func ignoredProperties() -> [String] {
        return ["content"]
    }
}