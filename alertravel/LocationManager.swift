//
//  LocationManager.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 25/4/21.
//

import Foundation
import MapKit

class LocationManager {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    
    private init() {}
    
    private func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
}
