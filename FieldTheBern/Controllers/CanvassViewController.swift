//
//  CanvassViewController.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/30/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit
import Dollar
import SwiftyJSON
import SCLAlertView

class CanvassViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Nearest Address View

    @IBOutlet weak var nearestAddressLabel: UILabel!
    @IBOutlet weak var nearestAddressSubtitleLabel: UILabel!
    
    @IBOutlet weak var nearestAddressImage: UIImageView!
    
    @IBOutlet weak var nearestAddressView: UIView! {
        didSet {
            nearestAddressView.layer.cornerRadius = 8.0
            
            let gesture = UITapGestureRecognizer(target: self, action: "tappedNearestAddressView:")
            nearestAddressView.addGestureRecognizer(gesture)
            
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: "swipedNearestAddressView:")
            nearestAddressView.addGestureRecognizer(swipeGesture)

            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: "swipedNearestAddressView:")
            leftSwipeGesture.direction = .Left
            nearestAddressView.addGestureRecognizer(leftSwipeGesture)
        }
    }
    
    @IBOutlet weak var nearestAddressViewTopConstraint: NSLayoutConstraint! {
        didSet {
            nearestAddressViewTopConstraint.constant = -90
        }
    }
    
    func animateNearestAddressViewIfNeeded() {
        if let userCoordinate = self.mapView.userLocation.location?.coordinate {
            let userPoint = MKMapPointForCoordinate(userCoordinate)
            if let address = self.closestAddress,
                let coordinate = address.coordinate {
                    let closestAddressPoint = MKMapPointForCoordinate(coordinate)
                    let mapRect = self.mapView.visibleMapRect
                    let userLocationInsideMapView = MKMapRectContainsPoint(mapRect, userPoint) && MKMapRectContainsPoint(mapRect, closestAddressPoint)
                    
                    self.mapView.annotations
                    
                    
                    if userLocationInsideMapView {
                        if self.nearbyAddresses.count > 0 {
                            // We have addresses to show, show the address view
                            animateNearestAddressViewIn()
                        } else {
                            // No addresses, hide the address view
                            animateNearestAddressViewOut()
                        }
                        
                    } else {
                        // The user's location isn't visible, don't show nearest address view
                        animateNearestAddressViewOut()
                    }
            } else {
                animateNearestAddressViewOut()
            }
        } else {
            // We don't have the user's location
            animateNearestAddressViewOut()
        }
    }
    
    func animateNearestAddressViewIn() {
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(Double(0.3), delay: Double(0.0), usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
                    self.nearestAddressViewTopConstraint.constant = 5
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateNearestAddressViewOut() {
        dispatch_async(dispatch_get_main_queue()) {
            UIView.animateWithDuration(Double(0.1), animations: { () -> Void in
                self.nearestAddressViewTopConstraint.constant = -90
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func tappedNearestAddressView(sender: UITapGestureRecognizer) {
        for annotation in self.mapView.annotations {
            if let addressAnnotation = annotation as? AddressPointAnnotation {
                if self.closestAddress?.id == addressAnnotation.id {
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func swipedNearestAddressView(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            nearestAddressView.layer.backgroundColor = Color.TransparentBlue.CGColor
        } else if sender.direction == .Right {
            nearestAddressView.layer.backgroundColor = Color.Blue.CGColor
        }
    }
    
    // MARK: - Location Button
    
    enum LocationButtonState {
        case None, Follow, FollowWithHeading
    }
    
    struct LocationButtonImage {
        static let GrayArrow = UIImage(named: "gray-arrow")
        static let BlueArrow = UIImage(named: "blue-arrow")
        static let BlueCompass = UIImage(named: "blue-compass")
    }
    
    var locationButtonState: LocationButtonState = .None {
        didSet {
            switch locationButtonState {
            case .None:
                mapView.userTrackingMode = MKUserTrackingMode.None
                locationButton.setImage(LocationButtonImage.GrayArrow, forState: UIControlState.Normal)
            case .Follow:
                mapView.userTrackingMode = MKUserTrackingMode.Follow
                locationButton.setImage(LocationButtonImage.BlueArrow, forState: UIControlState.Normal)
            case .FollowWithHeading:
                mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
                locationButton.setImage(LocationButtonImage.BlueCompass, forState: UIControlState.Normal)
            }
        }
    }
    
    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            locationButton.setImage(UIImage(named: "blue-arrow"), forState: UIControlState.Selected)
        }
    }
    
    // MARK: - Add Location Button
    
    var previousLocation: CLLocation?
    var previousPlacemark: CLPlacemark?
    
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func addLocation(sender: UIButton) {

        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
            
            displayLocationServicesAlert()
        }
        
        self.performSegueWithIdentifier("AddLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddLocation" {
            if let destinationViewController = segue.destinationViewController as? AddAddressNavigationController {
                
                if let rootController = destinationViewController.viewControllers[0] as? AddAddressViewController {
                    let currentLocation = locationManager.location
                    rootController.location = currentLocation
                    rootController.previousLocation = previousLocation
                    rootController.previousPlacemark = previousPlacemark
                    rootController.userLocation = currentLocation
                    
                    // Reset the previous location
                    self.previousLocation = currentLocation
                }
            }
        }
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map view
        mapView.delegate = self
        mapView?.showsUserLocation = true
        
        // Track pan gestures
        let panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didDragMap:")
        panRecognizer.delegate = self
        self.mapView.addGestureRecognizer(panRecognizer)
        
        // Track pinch gestures
        let pinchRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "didZoomMap:")
        pinchRecognizer.delegate = self
        self.mapView.addGestureRecognizer(pinchRecognizer)

        // Track tap gestures
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didZoomMap:")
        tapRecognizer.numberOfTapsRequired = 2;
        tapRecognizer.delegate = self
        self.mapView.addGestureRecognizer(tapRecognizer)
        
        // Susbcribe to should reload notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shouldReloadMap:", name: "shouldReloadMap", object: nil)
        
        // Subscribe to placemark updated notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shouldUpdatePlacemark:", name: "placemarkUpdated", object: nil)
        
        findMyLocation()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(CLLocationManager.authorizationStatus() == .AuthorizedAlways ||
        CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse)
        {
            // introduce alert here. 
            
            let campaignOfficeLocationFilePath = NSBundle.mainBundle().URLForResource("field_offices_geocoded", withExtension: "json")
            let campaignOfficeLocationStringPath = campaignOfficeLocationFilePath?.absoluteString
            
            let campaignOfficeLocationData = NSData(contentsOfURL: NSURL(string: campaignOfficeLocationStringPath!)!);
            
            let campaignOfficeLocationJSON = JSON(data: campaignOfficeLocationData!)
            
            // First check if we are not in an early state. 
            
            if let location = locationManager.location
            {
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    
                    if error != nil {
                        print("Reverse geocoder failed with error" + error!.localizedDescription)
                        return
                    }
                    
                    if placemarks!.count > 0 {
                        let placemark = placemarks![0] 
                        
                        if(!((placemark.administrativeArea! == "AR" || placemark.administrativeArea! == "Arkansas") ||
                        (placemark.administrativeArea! == "AZ" || placemark.administrativeArea! == "Arizona") ||
                        (placemark.administrativeArea! == "IA" || placemark.administrativeArea! == "Iowa") ||
                        (placemark.administrativeArea! == "CO" || placemark.administrativeArea! == "Colorado") ||
                        (placemark.administrativeArea! == "MA" || placemark.administrativeArea! == "Massachusetts") ||
                        (placemark.administrativeArea! == "ME" || placemark.administrativeArea! == "Maine") ||
                        (placemark.administrativeArea! == "MN" || placemark.administrativeArea! == "Minnesota") ||
                        (placemark.administrativeArea! == "NH" || placemark.administrativeArea! == "New Hampshire") ||
                        (placemark.administrativeArea! == "NV" || placemark.administrativeArea! == "Nevada") ||
                        (placemark.administrativeArea! == "SC" || placemark.administrativeArea! == "South Carolina") ||
                        (placemark.administrativeArea! == "VA" || placemark.administrativeArea! == "Virginia") ||
                        (placemark.administrativeArea! == "TX" || placemark.administrativeArea! == "Texas")))
                        {
                            // we're not in an early state, show the alert. 
                            // We should also time-restrict this. 
                            
                            let alert = SCLAlertView()
                            alert.addButton("Take me there!")
                                {
                                    let url:NSURL = NSURL(string: "http://www.berniesanders.com/phonebank")!;
                                    
                                    if(!UIApplication.sharedApplication().openURL(url))
                                    {
                                        print("Failed to open URL: " + "http://www.berniesanders.com/phonebank")
                                    }
                            }
                            
                            alert.addButton("Thanks for letting me know")
                            {
                                
                            }
                            
                            alert.showCloseButton = false
                            alert.showInfo("Hey!", subTitle:"Want to make an even bigger impact for the campaign? \n\n We're getting all hands on deck to phonebank into crucial early states and build momentum for the political revolution. \n\n Press on \"Take me there!\" to make some phone calls for Bernie and get the movement going. \n\nThanks for supporting the campaign!");
                        }
                        else
                        {
                            // find closest campaign office
                            
                            self.closestCampaignOffice(placemark.location!, database: campaignOfficeLocationJSON.arrayObject as! [NSDictionary], onCompletion: { (closestCampaignOfficeAndDistance) -> Void in
                                
                                if(closestCampaignOfficeAndDistance!.1 <= 80467.2) // if we're less than or equal to 50 miles (80467.2 meters) to the campaign office
                                {
                                    let alert = SCLAlertView()
                                    alert.addButton("Take me there!")
                                        {
                                            let place = MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: nil)
                                            let destination = MKMapItem(placemark: place)
                                            destination.name = "Bernie Sanders Campaign Office"
                                            
                                            let items = [destination]
                                            let options = [MKLaunchOptionsDirectionsModeDriving:MKLaunchOptionsDirectionsModeKey]
                                            
                                            MKMapItem.openMapsWithItems(items, launchOptions: options)
                                    }
                                    alert.addButton("Thanks for letting me know") {
                                    }
                                    alert.showCloseButton = false
                                    
                                    var officeLocation = (closestCampaignOfficeAndDistance!.0.objectForKey("address") as! String)
                                    officeLocation = officeLocation +  " \n"
                                    officeLocation = officeLocation + (closestCampaignOfficeAndDistance!.0.objectForKey("city") as! String)
                                    officeLocation = officeLocation + ", "
                                    officeLocation = officeLocation + (closestCampaignOfficeAndDistance!.0.objectForKey("state") as! String)
                                    officeLocation = officeLocation + " "
                                    officeLocation = officeLocation + (closestCampaignOfficeAndDistance!.0.objectForKey("zipCode") as! String) + "\n"
                                    
                                    officeLocation = officeLocation + (closestCampaignOfficeAndDistance!.0.objectForKey("phone") as! String)
                                    
                                    
                                    alert.showInfo("Hey!", subTitle:"It looks like you're close to one of our field offices:\n\n" + officeLocation + ". \n\nYou should stop in and volunteer to canvass with us directly. It helps us target our canvassing efforts even better, and we always love to meet our volunteers. \n\nThanks for supporting the campaign!");
                                }
                            })
                    
                        }
                    
                    }
                })
            }
        }
    }
    
    func LLAAndDistanceDatabase(location:CLLocation, address:String, count:Int, onCompletion:([String:AnyObject]? -> Void))
    {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
            if(error != nil)
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let distance = location.distanceFromLocation(placemark.location!)
                
                onCompletion(["position":count, "distance":distance as Double!])
            }
        }
    }
   
    func closestCampaignOffice(location:CLLocation, database:[NSDictionary], onCompletion:((NSDictionary, Double)? -> Void))
    {
        var arrayOfLLA:[[String:AnyObject]] = Array()
        var count = -1
        
        for anEntry in database // compose array based on distance
        {
            count = count + 1
        
            var addressString = (anEntry.objectForKey("address") as! String) + ", "
            
            addressString = addressString + (anEntry["city"] as! String) + ", " + (anEntry["state"] as! String)
            
            self.LLAAndDistanceDatabase(location, address: addressString, count: count, onCompletion: { (result) -> Void in
                arrayOfLLA.append(result!)
                
                if(arrayOfLLA.count == database.count)
                {
                    arrayOfLLA.sortInPlace {
                        item1, item2 in
                        let distance1 = (item1["distance"] as! NSNumber).doubleValue
                        let distance2 = (item2["distance"] as! NSNumber).doubleValue
                        return distance1 < distance2
                    }
                    let closest = arrayOfLLA[0]
                   
                    onCompletion((database[closest["position"] as! Int], closest["distance"] as! Double))
                }
            })
        }
        

    }
    
    func shouldReloadMap(sender: AnyObject) {
        fetchAddresses()
    }
    
    func shouldUpdatePlacemark(notification: NSNotification) {
        self.previousPlacemark = notification.userInfo?["placemark"] as? CLPlacemark
    }
    
    
    // MARK: - Map Interactions
    
    let regionRadius: CLLocationDistance = 500
    
    var lastUpdated: NSDate?
    var nearbyAddresses: [Address] = []
    
    @IBAction func changeLocationButtonState(sender: UIButton) {

        switch locationButtonState {
        case .None:
            locationButtonState = .Follow
        case .Follow:
            locationButtonState = .FollowWithHeading
        case .FollowWithHeading:
            locationButtonState = .Follow
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            locationButtonState = .None
        }
    }
    
    func didZoomMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            locationButtonState = .None
        }
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let currentTime = NSDate()

        if let updatedTime = lastUpdated {
            // Already fetched
            var timeThreshold = 0

            switch mapView.userTrackingMode {
            case .None:
                timeThreshold = 0 // User initiated region changes should call the API no matter what
            case .Follow:
                timeThreshold = 2 // This will update often enough while walking that we can do 2 seconds
            case .FollowWithHeading:
                timeThreshold = 4 // We need to really throttle this because of the compass
            }

            if currentTime.secondsFrom(updatedTime) >= timeThreshold
            {
                fetchAddresses()
            
            }
        } else {
            // First address fetch
            fetchAddresses()
        }
    }
    
    func fetchAddresses(onSuccess: ((success: Bool, errorTitle:String?, errorMessage:String?) -> Void)? = nil)  {
        lastUpdated = NSDate()
        
        let distance = mapView.getFurthestDistanceFromRegionCenter()
        
        let addressService = AddressService()
        
        addressService.getAddresses(self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude, radius: distance) { (addressResults, success, error) in
            
            if success {
                if let addresses = addressResults {
                    
                    var annotationsToAdd: [MKAnnotation] = []
                    var annotationsToRemove: [MKAnnotation] = []
                    var annotationsToKeep: [MKAnnotation] = []
                    
                    self.nearbyAddresses = addresses
                    
                    for address in addresses {
                        let result = self.annotationsContainAddress(address)
                        if result.success {
                            annotationsToKeep.append(result.annotation!)
                        } else {
                            let annotation = self.addressToPin(address)
                            annotationsToKeep.append(annotation)
                            annotationsToAdd.append(annotation)
                        }
                    }
                    
                    self.updateClosestLocation()
                    self.animateNearestAddressViewIfNeeded()
                    
                    annotationsToRemove = self.differenceBetweenAnnotations(self.mapView.annotations, secondArray: annotationsToKeep)
                    
                    // Update UI
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapView.removeAnnotations(annotationsToRemove)
                        self.mapView.addAnnotations(annotationsToAdd)
                        
                        if(onSuccess != nil)
                        {
                            onSuccess!(success: true, errorTitle: nil, errorMessage: nil)
                        }
                    }
                }
            } else {
                // API error
                if let apiError = error {
                    self.handleError(apiError)
                    if(onSuccess != nil)
                    {
                    onSuccess!(success: false, errorTitle: "API Error", errorMessage: "An API Error has ocurred")
                    }
                }
            }
        }
    }
    
    var closestAddress: Address?
    
    func updateClosestLocation()  {

        dispatch_async(dispatch_get_main_queue()) {

            var closestLocations: [(distance: CLLocationDistance?, address: Address)] = []

            for address in self.nearbyAddresses {

                let location = CLLocation(latitude: address.coordinate!.latitude, longitude: address.coordinate!.longitude)
                let distanceFrom = self.locationManager.location?.distanceFromLocation(location)
                closestLocations.append(distance: distanceFrom, address: address)

                // Sort by the nearest locations
                closestLocations.sortInPlace({ $0.distance < $1.distance })
                
                if let closestLocation = closestLocations.first {
                    self.closestAddress = closestLocation.address
                    self.nearestAddressLabel.text = closestLocation.address.title
                    self.nearestAddressSubtitleLabel.text = closestLocation.address.subtitle
                    self.nearestAddressImage.image = closestLocation.address.image
                }

            }
        }
    }
    
    func differenceBetweenAnnotations(firstArray: [MKAnnotation], secondArray: [MKAnnotation]) -> [MKAnnotation] {
        var map: [MKAnnotation] = []
        
        outerLoop: for elem in firstArray {
            if elem.isKindOfClass(MKUserLocation) {
                continue
            }
            map.append(elem)
            for secondElem in secondArray {
                if elem.coordinate.latitude == secondElem.coordinate.latitude
                && elem.coordinate.longitude == secondElem.coordinate.longitude
                && elem.title! == secondElem.title!
                && elem.subtitle! == secondElem.subtitle! {
                    map.removeLast()
                    continue outerLoop
                }
            }
        }
        
        return map
    }
    
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        
        // When the compass is tapped in iOS 9, change the button state back to tracking
        if mode == .Follow {
            if locationButtonState != .Follow {
                locationButtonState = .Follow
            }
        }
    }
    
    let anchorPoint = CGPointMake(0.5, 1.0)
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isKindOfClass(AddressPointAnnotation) {
            let addressAnnotation = annotation as? AddressPointAnnotation
            
            var pinAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")

            if pinAnnotation == nil {
                pinAnnotation = AddressPointPinAnnotation.init(annotation:annotation)
                
                // if you want to use a button, you'll need to pass in a delegate and modify the hitTest calls -nick D.
                
//                pinAnnotation?.leftCalloutAccessoryView = customView

            }
            
            pinAnnotation?.image = addressAnnotation?.image
            
            pinAnnotation?.layer.anchorPoint = anchorPoint
            pinAnnotation?.canShowCallout = false
        
            return pinAnnotation

        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if let mapPin = view as? AddressPointPinAnnotation {
            
            mapPin.setSelected(false, animated: true)
           /* if mapPin.preventDeselection {
                mapView.selectAnnotation(view.annotation!, animated: false)
            } */
        }
    }
    
    func addressToPin(address: Address) -> AddressPointAnnotation {
        let dropPin = AddressPointAnnotation()

        dropPin.id = address.id
        dropPin.result = address.displayedResult
        dropPin.coordinate = address.coordinate!
        dropPin.title = address.title
        dropPin.subtitle = address.subtitle
        dropPin.image = address.image
        dropPin.lastVisited = address.visitedAtString
        
        return dropPin
    }
    
    func annotationsContainAddress(address: Address) -> (success: Bool, annotation: AddressPointAnnotation?) {
        for existingAnnotation in self.mapView.annotations {
            if let existingAddressAnnotation = existingAnnotation as? AddressPointAnnotation {
                if existingAddressAnnotation.coordinate.latitude == address.latitude
                    && existingAddressAnnotation.coordinate.longitude == address.longitude
                    && existingAddressAnnotation.title == address.title
                    && existingAddressAnnotation.subtitle == address.subtitle
                {
                    return (true, existingAddressAnnotation)
                }
            }
        }
        return (false, nil)
    }
    

    func displayLocationServicesAlert() {
        
        let alert = UIAlertController(title: "Location Services", message: "Please press OK to be taken to the Settings page so that you can enable Location Services for Field the Bern", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            (_) in UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)}
        
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Location Fetching
    
    let locationManager = CLLocationManager()
    
    var lastKnownLocation: CLLocation?
    var locality: String?
    var administrativeArea: String?
    
    func findMyLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10.0
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            
            if let location = locationManager.location {
                centerMapOnLocation(location)
                locationButtonState = .Follow
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            findMyLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        updateClosestLocation()
        self.animateNearestAddressViewIfNeeded()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {

        var region:MKCoordinateRegion = self.mapView.region
        region.center = newLocation.coordinate
        region.span.longitudeDelta = 0.15
        region.span.latitudeDelta = 0.15
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        
        if error.domain == kCLErrorDomain && CLError(rawValue: error.code) == CLError.Denied {
            
            displayLocationServicesAlert()
        }
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        if(fullyRendered)
        {
            self.fetchAddresses({ (success, errorTitle, errorMessage) -> Void in
                if(success)
                {
                    self.updateClosestLocation()
                    self.animateNearestAddressViewIfNeeded()

                }
            })

        }
    }
    
    // MARK: - Error Handling
    
    func handleError(error: APIError) {
        NSLog("\(error.errorTitle) - \(error.errorDescription)");
    }
}