//
//  UIAlertControllerExtensions.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit
import Social

extension UIAlertController {
    //
    // MARK: Social
    //

    static func socialAlertControllerForPage(page: PageModel?, parentViewController: UIViewController) -> UIAlertController {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let facebookAction = UIAlertAction.socialActionForServiceType(SLServiceTypeFacebook, title: "Facebook", page: page, parentViewController: parentViewController)
        actionController.addAction(facebookAction)
        
        let twitterAction = UIAlertAction.socialActionForServiceType(SLServiceTypeTwitter, title: "Twitter", page: page, parentViewController: parentViewController)
        actionController.addAction(twitterAction)
        
        actionController.addAction(UIAlertAction.cancelAction())
        
        return actionController
    }
    
    //
    // MARK: Errors
    //
    
    static func errorAlertControllerWithTitle(title: String?, message: String?) -> UIAlertController {
        let errorController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        errorController.addAction(UIAlertAction.dismissAction())
        return errorController
    }
}