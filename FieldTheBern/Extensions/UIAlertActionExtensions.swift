//
//  UIAlertActionExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import Social

extension UIAlertAction {
    static func cancelAction() -> UIAlertAction {
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        return cancelAction
    }
    
    static func dismissAction() -> UIAlertAction {
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
        return dismissAction
    }
    
    static func socialActionForServiceType(serviceType: String, title: String, page: PageModel?, parentViewController: UIViewController) -> UIAlertAction {
        
        let action = UIAlertAction(title: title, style: UIAlertActionStyle.Default) { (action) -> Void in
            let actionController = SLComposeViewController(forServiceType: serviceType)
            if SLComposeViewController.isAvailableForServiceType(serviceType) {
                actionController.updateToPage(page)
                parentViewController.presentViewController(actionController, animated: true, completion: nil)
            }
            else {
                let errorController = UIAlertController.errorAlertControllerWithTitle("Account Not Found", message: "Please make sure you are logged into \(title) in system settings.")
                parentViewController.presentViewController(errorController, animated: true, completion: nil)
            }
        }
        
        return action
    }
}