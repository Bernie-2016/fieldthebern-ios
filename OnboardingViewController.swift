//
//  OnboardingViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/28/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import p2_OAuth2
import SwiftyJSON

class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let pages = [
        [
            "title": "Learn",
            "description": "We’ll teach you to canvas your neighborhood and learn useful talking points.",
            "image": "intro-map"
        ],
        [
            "title": "Canvas",
            "description": "Find new doors to knock on and earn points for all your hard work.",
            "image": "intro-map"
        ],
        [
            "title": "Track",
            "description": "Watch your progress as you compete to get America to #FeelTheBern.",
            "image": "intro-users"
        ]
    ]
    
    var pagesRange: Range<Int> {
        get {
            let maxPages = pagesCount - 1
            return 0...maxPages
        }
    }
    
    var pagesCount: Int {
        return viewControllers.count
    }
    
    var index: Int = 0
    
    var pageViewController: UIPageViewController!
    
    var viewControllers: [UIViewController] = []

    struct ViewControllers {
        static let OnboardingPageViewController = "OnboardingPageViewController"
        static let PageContentViewController = "PageContentViewController"
        static let SignupViewController = "SignupViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = Session.sharedInstance
        session.authorize("joshdotsmith@gmail.com", password: "password") { success in
            if success {
                HTTP().request(.GET, "http://api.lvh.me:3000/ping", parameters: nil)
            }
        }
        
        self.view.backgroundColor = UIColor(red:0.22, green:0.56, blue:0.85, alpha:1.0)
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllers.OnboardingPageViewController) as! UIPageViewController
        self.pageViewController.dataSource = self

        
        for _ in pages {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllers.PageContentViewController) as! PageContentViewController
            self.viewControllers.append(viewController)
        }
        
        for (index, viewController) in viewControllers.enumerate() {
            let viewController = viewController as! PageContentViewController
            viewController.imageName = pages[index]["image"]
            viewController.titleText = pages[index]["title"]
            viewController.descriptionText = pages[index]["description"]
        }
        
        let signupViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllers.SignupViewController)
        self.viewControllers.append(signupViewController!)
        
        pageViewController.setViewControllers([viewControllers[0]], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = viewControllers.indexOf(viewController)!

        index++
        
        if pagesRange ~= index {
            return self.viewControllers[index]
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = viewControllers.indexOf(viewController)!

        index--
        
        if pagesRange ~= index {
            return self.viewControllers[index]
        } else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pagesCount
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
