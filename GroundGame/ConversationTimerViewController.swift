//
//  ConversationTimerViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class ConversationTimerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var savedGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    var location: CLLocation?
    var placemark: CLPlacemark?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)        
    }
    
    override func viewWillAppear(animated: Bool) {
        savedGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let backButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancel(sender: UINavigationItem) {

        let alert = UIAlertController(title: "Cancel Visit", message: "You'll lose all your progress with this visit and go back to the map.", preferredStyle: UIAlertControllerStyle.Alert)

        let cancelAction = UIAlertAction(title: "Undo", style: .Cancel) { (_) in
            
        }
        let OKAction = UIAlertAction(title: "Back to Map", style: .Destructive) { (action) in
            // Return to map
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(OKAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer {
        case self.navigationController!.interactivePopGestureRecognizer!:
            return false
        default:
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if(identifier == "ConversationTableEmbedSegue") {
                let conversationTableViewController = segue.destinationViewController as? ConversationTableViewController
                conversationTableViewController?.location = self.location
                conversationTableViewController?.placemark = self.placemark
            }
        }
    }
    
}
