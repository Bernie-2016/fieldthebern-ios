//
//  TabBarViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/30/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let tabs = [
        [
            "title": "Learn"
        ],
        [
            "title": "Canvas"
        ],
        [
            "title": "Profile"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundImage = UIImage.imageFromColor(Color.Blue).imageWithRenderingMode(.AlwaysOriginal)
        
        UITabBar.appearance().selectionIndicatorImage = UIImage.imageFromColor(Color.DarkBlue).imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.selectionIndicatorImage = nil
        self.tabBar.selectionIndicatorImage = UIImage.imageFromColor(Color.DarkBlue).imageWithRenderingMode(.AlwaysOriginal)

        // Set the tab bar images
        self.tabBar.items?[0].image = UIImage(named: "book")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "map")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "award")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // Set the selected colors
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        let selectedAttributes: [String: AnyObject]? = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Lato-Heavy", size: 11)!
        ]
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: .Selected)
        
        // Set the unselected text color
        let unselectedAttributes: [String: AnyObject]? = [
            NSForegroundColorAttributeName: Color.DarkBlue,
            NSFontAttributeName: UIFont(name: "Lato-Medium", size: 11)!
        ]
        UITabBarItem.appearance().setTitleTextAttributes(unselectedAttributes, forState: .Normal)
        
        // Generate a tinted unselected image
        if let tabBarItems = self.tabBar.items {
            for (index, item) in tabBarItems.enumerate() {
                item.title = tabs[index]["title"]
                item.image = item.selectedImage?.imageWithColor(Color.DarkBlue).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            }
        }
        
        // Set the map as our default tab
        self.selectedIndex = 1
        
    }
}
