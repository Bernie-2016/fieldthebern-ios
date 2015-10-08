//
//  AddAddressNavigationController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/4/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddAddressNavigationController: UINavigationController {
    
    var location: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let image = UIImage.imageFromColor(Color.Blue).imageWithRenderingMode(.AlwaysOriginal)
        self.navigationBar.setBackgroundImage(image, forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        self.navigationBar.translucent = false
        self.navigationBar.shadowImage = image
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Heavy", size: 18)!]
        self.navigationBar.titleTextAttributes = attributes
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
