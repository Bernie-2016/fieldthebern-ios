//
//  AddOrEditPersonDelegate.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

protocol AddOrEditPersonDelegate {
    func willSubmit() -> Person?
}