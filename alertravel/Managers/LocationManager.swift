//
//  LocationManager.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 25/4/21.
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    
    private override init() {}
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
    
    func getUserLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func distanceTo(_ destiny: CLLocation) -> CLLocationDistance? {
        let coordinates = destiny.coordinate
        return locationManager.location?.distance(from: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
    }
}
