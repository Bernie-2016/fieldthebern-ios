//
//  UIStoryboardExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func itemsCollectionViewControllerWithItems(item: FTBItemModel, items: [FTBItemModel]) -> ItemsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let collectionController = storyboard.instantiateViewControllerWithIdentifier("ItemsController") as? ItemsViewController else { return nil }
        collectionController.items = items
        collectionController.navigationItem.title = item.title
        return collectionController
    }
    
    static func pageDetailViewControllerWithPage(page: PageModel) -> PageDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let pageController = storyboard.instantiateViewControllerWithIdentifier("DetailController") as? PageDetailViewController else { return nil }
        pageController.page = page
        return pageController
    }
}