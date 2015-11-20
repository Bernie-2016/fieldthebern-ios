//
//  ProfileViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/1/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import KFSwiftImageLoader
import FBSDKShareKit
import MessageUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CellButtonDelegate, FBSDKAppInviteDialogDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var rankings: [Ranking] = []
    var loadingRankings = false
    var imagePicker = UIImagePickerController()
    var user: User? {
        didSet {
            if let user = user {
                updateProfileUI(user)
            }
        }
    }

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var doorsLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"

        // Set the navigation elements
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!], forState: UIControlState.Normal)

        // Set the fonts for the segmented control
        let medium = [NSFontAttributeName: UIFont(name: "Lato-Medium", size: 13.0)!]
        let heavy = [NSFontAttributeName: UIFont(name: "Lato-Heavy", size: 13.0)!]
        UISegmentedControl.appearance().setTitleTextAttributes(medium, forState: .Normal)
        UISegmentedControl.appearance().setTitleTextAttributes(heavy, forState: .Selected)
        
        // Set the styles for the leaderboard table view
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 160.0
        
        // Set the table view's data source and delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Set profile image view to be rounded photo
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImageView.layer.cornerRadius = 30
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getLeaderboardWithSegmentedControl(segmentedControl)
        getUser()
    }
    
    func getUser() {
        UserService().me { (user, success, error) -> Void in
            if success {
                if let user = user {
                    self.updateProfileUI(user)
                }
            } else {
                if let apiError = error {
                    self.handleError(apiError)
                }
            }
        }
    }
    
    func updateProfileUI(user: User) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let name = user.name {
                self.navigationItem.title = name
            }
            if let points = user.totalPointsString {
                self.pointsLabel.text = points
            }
            if let doors = user.visitsCountString {
                self.doorsLabel.text = doors
            }
            if let url = user.photoLargeURL {
                self.profileImageView.loadImageFromURLString(url)
            }
        }
    }
    
    func getLeaderboardWithSegmentedControl(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            getLeaderboard("friends")
        case 1:
            getLeaderboard("state")
        case 2:
            getLeaderboard("everyone")
        default:
            break
        }
    }
    
    func getLeaderboard(type: String) {
        loadingRankings = true
        rankings = []
        tableView.reloadData()
        tableViewLoadingIndicator.hidden = false
        tableViewLoadingIndicator.startAnimating()
        LeaderboardService().get(type, callback: { (leaderboard) -> Void in
            if let leaderboard = leaderboard {
                self.rankings = leaderboard.rankings
                self.loadingRankings = false
                self.tableView.reloadData()
                self.tableViewLoadingIndicator.stopAnimating()
                self.tableViewLoadingIndicator.hidden = true
            }
        })
    }

    @IBAction func tapPhoto() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.takePhoto()
        })
        let chooseAction = UIAlertAction(title: "Choose from Library", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.pickImage()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(chooseAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        let resizedImage = Toucan(image: image).resize(CGSize(width: 500, height: 500), fitMode: Toucan.Resize.FitMode.Crop).image
        
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.7)
        
        if let base64String = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            UserService().editMePhoto(base64String) { (user, success, error) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.profileImageView.image = resizedImage
                    })
                } else {
                    if let apiError = error {
                        self.handleError(apiError)
                    }
                }
            }
        }
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        getLeaderboardWithSegmentedControl(sender)
    }
    
    // MARK: - Table View Controller Delegate Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScoreSectionHeader")
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return rankings.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < rankings.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserScoreCell") as! UserScoreTableViewCell
            
            let ranking = rankings[indexPath.row]
            
            if let rank = ranking.rank {
                cell.rankLabel.text = "\(rank)"
            }
            if let scoreString = ranking.scoreString {
                cell.pointsLabel.text = scoreString
            }
            if let rankingUser = ranking.user {
                if let name = rankingUser.abbreviatedName {
                    cell.nameLabel.text = "\(name)"
                }
                
                // Cells that are reused preserve images from previous cells that were drawn.
                // This is needed if we are going to add views here.
                cell.imageContainer.subviews.forEach({ $0.removeFromSuperview() })
                
                if let url = rankingUser.photoThumbURL {
                    
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                    imageView.layer.borderWidth = 1
                    imageView.layer.masksToBounds = true
                    imageView.layer.borderColor = UIColor.whiteColor().CGColor
                    imageView.layer.cornerRadius = imageView.frame.height/2
                    
                    cell.imageContainer.addSubview(imageView)
                    
                    print(url)
                    
                    imageView.loadImageFromURLString(url, placeholderImage: UIImage(named: "placeholder"), completion: nil)
                }
            }
            
            return cell
        } else {
            if loadingRankings {
                let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell") as! LoadingTableViewCell
                
                cell.activityIndicator.startAnimating()
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("InviteFriendsCell") as! InviteFriendsTableViewCell
                
                cell.delegate = self
                
                return cell
            }
        }
    }
    
    // MARK: - Invite Friends
    
    func didPressButton() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let facebookAction = UIAlertAction(title: "Invite Facebook Friends", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.showFacebookInviteDialog()
        })
        let textAction = UIAlertAction(title: "Invite by Text", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.composeTextMessage()
        })
        let emailAction = UIAlertAction(title: "Invite by Email", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            self.composeEmail()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(facebookAction)
        optionMenu.addAction(textAction)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func showFacebookInviteDialog() {
        let content: FBSDKAppInviteContent = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://fb.me/835938513187372")
        FBSDKAppInviteDialog.showWithContent(content, delegate: self)
    }
    
    func composeTextMessage() {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
                
            messageVC.body = "Enter a message"
            messageVC.messageComposeDelegate = self
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
    }
    
    func composeEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            
            mailVC.setMessageBody("", isHTML: false)
            mailVC.mailComposeDelegate = self
            
            self.presentViewController(mailVC, animated: false, completion: nil)
        }
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate Methods
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate Methods
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultFailed:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultSent:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    // MARK: - FBSDKAppInviteDialogDelegate Methods
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("Complete invite without error")
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        print("Error in invite \(error)")
    }

    // MARK: - Error Handling
    
    func handleError(error: APIError) {
        let errorTitle = error.errorTitle
        let errorMessage = error.errorDescription
        
        let alert = UIAlertController.errorAlertControllerWithTitle(errorTitle, message: errorMessage)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
