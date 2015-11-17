//
//  ItemCollectionModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import RealmSwift

class ItemCollectionModel: FTBItemModel {
    let items = List<ItemCollectionModel>()
    let pages = List<PageModel>()
    
    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        items.removeAll()
        
        let itemDictionaries = dictionary.getOptionalOrDefaultForKey(FTBConfig.ItemsKey, defaultValue: NSArray())
        itemDictionaries.mapTo { (itemDictionary: NSDictionary) in
            let model = ModelMap.modelForDictionary(itemDictionary)
            if let model = model as? ItemCollectionModel { self.items.append(model) }
            else if let model = model as? PageModel { self.pages.append(model) }
        }
    }
    
    override func isValid() -> Bool {
        return super.isValid() && items.count + pages.count != 0
    }
    
    func allItems() -> [FTBItemModel] {
        var collection = [FTBItemModel]()
        for value in items { collection.append(value) }
        for value in pages { collection.append(value) }
        return collection
    }
}
