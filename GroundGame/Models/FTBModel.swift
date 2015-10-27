//
//  FTBModel.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation

protocol FTBModel {
    func updateToDictionary(dictionary: NSDictionary)
    func isValid() -> Bool
}