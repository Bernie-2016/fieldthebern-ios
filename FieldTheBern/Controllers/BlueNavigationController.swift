//
//  BlueNavigationController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class BlueNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let image = UIImage.imageFromColor(Color.Blue).imageWithRenderingMode(.AlwaysOriginal)
        self.navigationBar.setBackgroundImage(image, forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.translucent = false
        self.navigationBar.shadowImage = image
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Heavy", size: 18)!]
        self.navigationBar.titleTextAttributes = attributes
        
        let navigationAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(navigationAttributes, forState: .Normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(navigationAttributes, forState: .Normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(navigationAttributes, forState: .Normal)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
