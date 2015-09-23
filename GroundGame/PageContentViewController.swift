//
//  PageContentViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/22/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var pageIndex: Int?
    var titleText: String!
    var descriptionText: String!
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.titleText
        self.descriptionLabel.text = self.descriptionText
        self.image.image = UIImage(named: self.imageName)
    }
}