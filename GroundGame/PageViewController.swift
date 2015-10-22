//
//  PageViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(red:0.24, green:0.35, blue:0.43, alpha:1.0)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.whiteColor()
        UIPageControl.appearance().backgroundColor = UIColor(red:0.22, green:0.56, blue:0.85, alpha:1.0)
    }
}
