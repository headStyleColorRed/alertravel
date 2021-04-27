//
//  LocationManager.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 25/4/21.
//

import Foundation
import MapKit

protocol LocationManagerProtocol {
    func locationUpdated()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private override init() {}
    
    
    // Variables
    private let locationManager = CLLocationManager()
    private var authorisationStatus: CLAuthorizationStatus = .notDetermined
    var delegate: LocationManagerProtocol?
    
    
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
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
    
    func startLocation() {
        print("Started location manager")
        locationManager.startUpdatingLocation()
    }
    
    func stopLocation() {
        print("Stoped location manager")
        locationManager.stopUpdatingLocation()
    }
    
    
    // Delegation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated location")
        delegate?.locationUpdated()
    }
}
