//
//  NewJourneyViewModel.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI
import MapKit

class NewJourneyViewModel: ObservableObject {
    
    init() {
        print("Initialized NewJourneyViewModel")
    }
    
    func viewDidLoad() {
        let locationManager = LocationModel()
        locationManager.requ
    }
    
}

class LocationModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    public func requestAuthorisation(always: Bool = false) {
        if always {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
}
