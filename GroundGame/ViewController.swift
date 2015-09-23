//
//  ViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

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
            let maxPages = pages.count - 1
            return 0...maxPages
        }
    }
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red:0.22, green:0.56, blue:0.85, alpha:1.0)
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
        self.pageViewController.dataSource = self
        
        let initialContentViewController = self.pageAtIndex(0) as PageContentViewController
        let viewControllers = [initialContentViewController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    
    func pageAtIndex(index: Int) -> PageContentViewController {
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        
        print(index)
        
        if (pagesRange ~= index) {
            pageContentViewController.pageIndex = index
            pageContentViewController.titleText = pages[index]["title"]
            pageContentViewController.descriptionText = pages[index]["description"]
            pageContentViewController.imageName = pages[index]["image"]
        }
        
        return pageContentViewController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PageContentViewController
        var index = viewController.pageIndex!
        
        index--

        if pagesRange ~= index {
            return self.pageAtIndex(index)
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PageContentViewController
        var index = viewController.pageIndex!
        
        index++
        
        if pagesRange ~= index {
            return self.pageAtIndex(index)
        } else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

