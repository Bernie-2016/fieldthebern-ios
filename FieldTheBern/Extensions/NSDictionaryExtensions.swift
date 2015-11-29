//
//  NSDictionaryExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

extension NSDictionary {
    func getOptionalOrDefaultForKey<T>(key: String, defaultValue: T) -> T {
        guard let value = objectForKey(key) as? T else { return defaultValue }
        return value
    }
}