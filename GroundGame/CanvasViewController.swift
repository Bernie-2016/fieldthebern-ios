//
//  CanvasViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/30/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit
import Dollar

class CanvasViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
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
            let mapRect = self.mapView.visibleMapRect
            let userLocationInsideMapView = MKMapRectContainsPoint(mapRect, userPoint)

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
    
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func addLocation(sender: UIButton) {
        self.performSegueWithIdentifier("AddLocation", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddLocation" {
            if let destinationViewController = segue.destinationViewController as? AddAddressNavigationController {
                destinationViewController.location = locationManager.location
            }
        }
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up our location manager
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            if let location = locationManager.location {
                centerMapOnLocation(location)
                locationButtonState = .Follow
            }
        }
        
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
        tapRecognizer.delegate = self
        self.mapView.addGestureRecognizer(tapRecognizer)
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

            if currentTime.secondsFrom(updatedTime) >= timeThreshold { fetchAddresses() }
        } else {
            // First address fetch
            fetchAddresses()
        }
    }
    
    func fetchAddresses() {
        lastUpdated = NSDate()
        
        let distance = mapView.getFurthestDistanceFromRegionCenter()
        
        let addressService = AddressService()
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            addressService.getAddresses(self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude, radius: distance) { (addressResults) in
                
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
                    }
                }
            }
        }
    }
    
    var closestAddress: Address?
    
    func updateClosestLocation() {

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
                pinAnnotation = MKAnnotationView.init(annotation: addressAnnotation, reuseIdentifier: "Pin")
            }
            
            pinAnnotation?.image = addressAnnotation?.image
            
            pinAnnotation?.layer.anchorPoint = anchorPoint
            pinAnnotation?.canShowCallout = true
        
            return pinAnnotation

        } else {
            return nil
        }
    }
    
    func addressToPin(address: Address) -> AddressPointAnnotation {
        let dropPin = AddressPointAnnotation()

        dropPin.id = address.id
        dropPin.result = address.result
        dropPin.coordinate = address.coordinate!
        dropPin.title = address.title
        dropPin.subtitle = address.subtitle
        dropPin.image = address.image
        
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
    
    // MARK: - Location Fetching
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var lastKnownLocation: CLLocation?
    var locality: String?
    var administrativeArea: String?
    
    @IBAction func findMyLocation(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = manager.location!
        
        updateClosestLocation()
        self.animateNearestAddressViewIfNeeded()
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
            if let placemarksArray = placemarks {
                if placemarksArray.count > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    if let localityString = pm.locality,
                        let administrativeAreaString = pm.administrativeArea {
                            self.locality = localityString
                            self.administrativeArea = administrativeAreaString
                    }
                }
            }
        }
        
        // Update the last known location
        lastKnownLocation = currentLocation
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
}