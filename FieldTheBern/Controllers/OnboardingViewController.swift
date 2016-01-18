//
//  OnboardingViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/28/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import p2_OAuth2
import SwiftyJSON

class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var topButton: UIBarButtonItem?
    
    let pages = [
        [
            "title": "Learn",
            "description": "We’ll teach you to canvass your neighborhood and learn useful talking points.",
            "image": "intro-learn"
        ],
        [
            "title": "Canvass",
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
        
        topButton = UIBarButtonItem.init(title: "Skip", style: UIBarButtonItemStyle.Plain, target: self, action: "skipOrLogin:")
        self.navigationItem.rightBarButtonItem = topButton
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier(ViewControllers.OnboardingPageViewController) as! PageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self;
        
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
        
        pageViewController.setViewControllers([viewControllers[0]], direction: .Forward, animated: false, completion: nil)
        
        let fullFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        let backgroundImageView = UIImageView(image: UIImage(named: "bernie-background"))
        backgroundImageView.frame = fullFrame
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)

        self.pageViewController.view.frame = fullFrame
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
                
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageViewController.scrollView?.frame = view.bounds
    }
    
    func skipOrLogin(sender: AnyObject) {
        let vc = pageViewController.viewControllers?.last
        let index = self.viewControllers.indexOf(vc!)!
        
        if index == lastPageIndex {
            // We're on the last page; show login
            self.performSegueWithIdentifier("SignInModalSegue", sender: self)
        } else {
            // Skip to the last page
            
            self.pageViewController.setViewControllers([self.viewControllers[lastPageIndex]], direction: .Forward, animated: true, completion: nil)
            setTopButtonForIndex(lastPageIndex)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        self.pageViewController.pageControl?.userInteractionEnabled = true
        
        let vc = pageViewController.viewControllers?.last
        let index = self.viewControllers.indexOf(vc!)!
        
        if pagesRange ~= index {
            setTopButtonForIndex(index)
        }
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

    func setTopButtonForIndex(index: Int) {
        if pagesRange ~= index {
            if index == lastPageIndex {
                topButton?.setTitleWithoutAnimation("Login")
            } else {
                topButton?.setTitleWithoutAnimation("Skip")
            }
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pagesCount
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        let index = pageViewController.viewControllers?.count == 0 ? 0 :  viewControllers.indexOf((pageViewController.viewControllers?.first)!)!
        
        return index
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
