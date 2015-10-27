//
//  AddAddressNavigationController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/4/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class AddAddressNavigationController: BlueNavigationController {
    
    var location: CLLocation?
    var previousLocation: CLLocation?
    var previousPlacemark: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - TouchesEnded
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
