//
//  MKMapView.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/3/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func getFurthestDistanceFromRegionCenter() -> CLLocationDistance {
        let region = self.region
        let center = self.centerCoordinate
        
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
        return distance
    }
}