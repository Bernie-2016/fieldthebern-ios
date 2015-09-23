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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
