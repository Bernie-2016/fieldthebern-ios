//
//  NSArrayExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

extension NSArray {
    func mapTo<T>(itemHandler: (T -> Void)) {
        for item in self {
            if let item = item as? T {
                itemHandler(item)
            }
        }
    }
}