//
//  PartyAffiliation.swift
//  GroundGame
//
//  Created by Josh Smith on 10/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import UIKit

enum PartyAffiliation {
    case Republican, Democrat, Independent, Other, Undeclared, Unknown
}

struct PartyAffiliationImage {
    static let Unknown = UIImage(named: "unknown-icon")
    static let Undeclared = UIImage(named: "undeclared-icon")
    static let Democrat = UIImage(named: "democrat-icon")
    static let Independent = UIImage(named: "independent-icon")
    static let Republican = UIImage(named: "republican-icon")
    static let Other = UIImage(named: "other-icon")
}