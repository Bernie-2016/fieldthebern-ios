//
//  SLComposeViewControllerExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import Social

extension SLComposeViewController {
    func updateToPage(page: PageModel?) {
        guard let page = page else { return }
        setInitialText("Bernie Sanders on \(page.title) #FeelTheBern")
        if let url = NSURL(string: page.url) { addURL(url) }
    }
}