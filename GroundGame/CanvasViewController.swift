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
        case Normal, Tracking, Compass
    }
    
    var locationButtonState: LocationButtonState = .Normal {
        didSet {
            switch locationButtonState {
            case .Normal:
                mapView.userTrackingMode = MKUserTrackingMode.None
                locationButton.setImage(UIImage(named: "gray-arrow"), forState: UIControlState.Normal)
            case .Tracking:
                mapView.userTrackingMode = MKUserTrackingMode.Follow
                locationButton.setImage(UIImage(named: "blue-arrow"), forState: UIControlState.Normal)
            case .Compass:
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
                locationButtonState = .Tracking
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

    @IBAction func locate(sender: UIButton) {

        switch locationButtonState {
        case .Normal:
            locationButtonState = .Tracking
        case .Tracking:
            locationButtonState = .Compass
        case .Compass:
            locationButtonState = .Tracking
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            locationButtonState = .Normal
        }
    }
    
    func didZoomMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            locationButtonState = .Normal
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
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newLocation.coordinate
        dropPin.title = "Farthest Point"
        mapView.addAnnotation(dropPin)

        print(distance, center.latitude, center.longitude)
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
//        case .Tracking:
//            centerMapOnLocation(currentLocation)
//        case .Compass:
//            centerMapOnLocation(currentLocation)
//        case .Normal:
//            break
//        }
//    }
}
