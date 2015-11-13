//
//  UIBarButtonItem.swift
//  GroundGame
//
//  Created by Josh Smith on 11/12/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    func setTitleWithoutAnimation(title: String?) {
        UIView.setAnimationsEnabled(false)
        
        self.title = title
        
        UIView.setAnimationsEnabled(true)
    }
}