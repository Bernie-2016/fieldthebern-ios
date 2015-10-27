//
//  ListModel.swift
//  GroundGame
//
//  Created by Josh Smith on 10/27/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

class ListModel: TextModel {

    var listItems = [String]()

    override func updateToDictionary(dictionary: NSDictionary) {
        super.updateToDictionary(dictionary)
        
        let listDictionaries = dictionary.getOptionalOrDefaultForKey(FTBConfig.ListKey, defaultValue: NSArray())
        listDictionaries.mapTo { (string: String) in
            let bulletizedString = "• \(string)"
            self.listItems.append(bulletizedString)
        }
        self.text = self.listItems.joinWithSeparator("\n")
    }
    
    override func isValid() -> Bool {
        return super.isValid()
    }

}