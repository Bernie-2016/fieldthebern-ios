//
//  ConversationTimerViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/5/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class ConversationTimerViewController: UIViewController, UIGestureRecognizerDelegate, SubmitButtonDelegate {
    
    var savedGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    var location: CLLocation?
    var placemark: CLPlacemark?
    var people: [Person]?
    var address: Address?
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Set submit button's submitting state
        submitButton.setTitle("Submitting Visit Details".uppercaseString, forState: UIControlState.Disabled)
        submitButton.setBackgroundImage(UIImage.imageFromColor(Color.Gray), forState: UIControlState.Disabled)
        
        startTimer()
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
    
    var startTime = NSTimeInterval()
    var cachedElapsedTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    
    var queue: dispatch_queue_t?
    var asyncTimer: dispatch_source_t?
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        elapsedTime = currentTime - startTime
        cachedElapsedTime = elapsedTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        dispatch_async(dispatch_get_main_queue()) {
//            self.timerLabel.text = "\(strMinutes):\(strSeconds)"
        }
        
    }
    
    func startTimer() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        queue = dispatch_queue_create("myTimer", nil)
        asyncTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        dispatch_source_set_timer(asyncTimer!, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(asyncTimer!) {
            self.updateTime()
        }
        
        dispatch_resume(asyncTimer!)
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
    
    var conversationTableViewController: ConversationTableViewController?

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if(identifier == "ConversationTableEmbedSegue") {
                conversationTableViewController = segue.destinationViewController as? ConversationTableViewController
                conversationTableViewController?.location = self.location
                conversationTableViewController?.placemark = self.placemark
                conversationTableViewController?.people = self.people ?? []
                conversationTableViewController?.address = self.address
                conversationTableViewController?.delegate = self
            }
        }
    }
    
    @IBAction func pressSubmitButton(sender: UIButton) {
        conversationTableViewController?.submitForm()
    }
    
    func isSubmitting() {
        submitButton.enabled = false
    }
    
    func finishedSubmittingWithError(errorMessage: String) {
        submitButton.enabled = true
    }
}
