//
//  AppDelegate.swift
//  GroundGame
//
//  Created by Josh Smith on 9/21/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import KeychainAccess
import XCGLogger
import Parse

let log: XCGLogger = {
    let log = XCGLogger.defaultInstance()
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose: .lightGrey,
        .Debug: .darkGrey,
        .Info: .darkGreen,
        .Warning: .orange,
        .Error: .red,
        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    
    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
    
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkAuthorization:", name: "appDidBecomeActive", object: nil)
        
        Heap.setAppId("12873725")
        #if Debug
            Heap.enableVisualizer()
        #endif
        
        Parse.setApplicationId("Do1Z4inNlESdLB7JsW7DVUPGlQJCkkKRyKp8h1Fv", clientKey: "Hm3Slw0OZL3D8lShBTrGLOMjxHkvJpFTL9X40bz3")
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        NSNotificationCenter.defaultCenter().postNotificationName("appDidBecomeActive", object: nil)
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation: PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
        print(deviceToken)
    }
        
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("received notification")
        PFPush.handlePush(userInfo)
    }
    
    func checkAuthorization(sender: AnyObject) {

        let session = Session.sharedInstance

        session.attemptAuthorizationFromKeychain { (success) -> Void in

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if success {
                
                if let rootViewController = self.window!.rootViewController {
                    if rootViewController.isKindOfClass(OnboardingViewController) {
                        let rootController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        
                        self.window!.rootViewController = rootController
                    }
                }
            } else {
                if let rootViewController = self.window!.rootViewController {
                    if !rootViewController.isKindOfClass(OnboardingViewController) {
                        let onboardingViewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as! OnboardingViewController
                        self.window!.rootViewController = onboardingViewController
                    }
                }
            }
        }
    }
}

