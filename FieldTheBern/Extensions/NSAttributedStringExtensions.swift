//
//  NSAttributedStringExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func highlightLinks(links: [LinkModel]) {
        for link in links {
            if link.end < length {
                let range = NSMakeRange(link.start, link.end - link.start)
                addAttribute(NSLinkAttributeName, value: link.urlString, range: range)
            }
        }
    }
}