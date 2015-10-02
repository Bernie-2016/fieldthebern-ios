//
//  CanvasViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 9/30/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import MapKit

class CanvasViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Location Button State
    
    enum LocationButtonState {
        case None, Follow, FollowWithHeading
    }
    
    var locationButtonState: LocationButtonState = .None {
        didSet {
            switch locationButtonState {
            case .None:
                mapView.userTrackingMode = MKUserTrackingMode.None
                locationButton.setImage(UIImage(named: "gray-arrow"), forState: UIControlState.Normal)
            case .Follow:
                mapView.userTrackingMode = MKUserTrackingMode.Follow
                locationButton.setImage(UIImage(named: "blue-arrow"), forState: UIControlState.Normal)
            case .FollowWithHeading:
                mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
                locationButton.setImage(UIImage(named: "blue-compass"), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            locationButton.setImage(UIImage(named: "blue-arrow"), forState: UIControlState.Selected)
        }
    }
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBAction func addLocation(sender: UIButton) {
        self.performSegueWithIdentifier("AddLocation", sender: self)
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up our location manager
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
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
    
    let regionRadius: CLLocationDistance = 1000
    
    var changedRegion: Bool = false

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
        self.changedRegion = true
        
        let region = mapView.region
        let center = mapView.centerCoordinate
        let latitudeDelta = region.span.latitudeDelta
        let longitudeDelta = region.span.longitudeDelta

        let longestDelta = max(latitudeDelta, longitudeDelta)

        let centerLocation = CLLocation.init(latitude: center.latitude, longitude: center.longitude)
        var newLocation = centerLocation
        if longestDelta == latitudeDelta {
            newLocation = CLLocation.init(latitude: center.latitude + latitudeDelta / 2, longitude: center.longitude)
        } else {
            newLocation = CLLocation.init(latitude: center.latitude, longitude: center.longitude + longitudeDelta / 2)
        }

        let distance = centerLocation.distanceFromLocation(newLocation)
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let addressService = AddressService()
        addressService.getAddresses(center.latitude, longitude: center.longitude, radius: distance) { (addresses) in
            if let addresses = addresses {
                for address in addresses {
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = address.coordinate!
                    print(address)
                    if let title = address.street1 {
                        dropPin.title = title
                    }
                    if let subtitle = address.city {
                        dropPin.subtitle = subtitle
                    }
                    mapView.addAnnotation(dropPin)
                }
            }
        }
        

        print(distance, center.latitude, center.longitude)
    }
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        
        // When the compass is tapped in iOS 9, change the button state back to tracking
        if mode == .Follow {
            if locationButtonState != .Follow {
                locationButtonState = .Follow
            }
        }
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        var pinAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin") as? MKPinAnnotationView
//
//        if pinAnnotation == nil {
//            pinAnnotation = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "Pin")
//        }
//        
//        pinAnnotation?.pinColor = MKPinAnnotationColor.Green
//        
//        return pinAnnotation
//    }
    
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
        
        // Keep the map centered if required
//        keepMapCentered(currentLocation)
        
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
    
//    private func keepMapCentered(currentLocation: CLLocation) {
//        print("Distance from last known location: \(lastKnownLocation.distanceFromLocation(currentLocation))")
//        
//        switch locationButtonState {
//        case .Follow:
//            centerMapOnLocation(currentLocation)
//        case .FollowWithHeading:
//            centerMapOnLocation(currentLocation)
//        case .None:
//            break
//        }
//    }
}
