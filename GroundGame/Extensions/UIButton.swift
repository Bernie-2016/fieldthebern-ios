//
//  UIButton.swift
//  GroundGame
//
//  Created by Josh Smith on 11/11/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

extension UIButton {
    func setTitleWithoutAnimation(title: String?) {
        UIView.setAnimationsEnabled(false)
        
        setTitle(title, forState: .Normal)
        
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}