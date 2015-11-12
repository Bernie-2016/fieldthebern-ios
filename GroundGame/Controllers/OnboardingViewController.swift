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

    @IBOutlet weak var topButton: UIButton!
    
    let pages = [
        [
            "title": "Learn",
            "description": "We’ll teach you to canvas your neighborhood and learn useful talking points.",
            "image": "intro-learn"
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
            return 0...lastPageIndex
        }
    }
    
    var pagesCount: Int {
        return viewControllers.count
    }
    
    var lastPageIndex: Int {
        return pagesCount - 1
    }
    
    var pageViewController: PageViewController!
    
    var viewControllers: [UIViewController] = []

    struct ViewControllers {
        static let OnboardingPageViewController = "OnboardingPageViewController"
        static let PageContentViewController = "PageContentViewController"
        static let SignUpViewController = "SignUpViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.Blue
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllers.OnboardingPageViewController) as! PageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
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
        
        let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllers.SignUpViewController)
        self.viewControllers.append(signUpViewController!)
        
        pageViewController.setViewControllers([viewControllers[0]], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = viewControllers.indexOf(viewController)!

        print("Forward from \(index)")
        index++
        print(index)
        
        if pagesRange ~= index {
            setTopButtonForIndex(index)
            return self.viewControllers[index]
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = viewControllers.indexOf(viewController)!
        
        print("Back from \(index)")
        index--
        print(index)

        if pagesRange ~= index {
            setTopButtonForIndex(index)
            return self.viewControllers[index]
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        print(pendingViewControllers)
    }
    
    func setTopButtonForIndex(index: Int) {
        if pagesRange ~= index {
            if index == lastPageIndex {
                topButton.setTitleWithoutAnimation("Login")
            } else {
                topButton.setTitleWithoutAnimation("Skip")
            }
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pagesCount
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        let index = pageViewController.viewControllers?.count == 0 ? 0 : viewControllers.indexOf((pageViewController.viewControllers?.first)!)!

        return index
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
