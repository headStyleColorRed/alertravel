//
//  JourneyViewModel.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI

class JourneyViewModel: ObservableObject {
    @Published var distanceToDestiny: Int = 0
    @Published var isUserTraveling: Bool = false
    private var currentJourney: Destiny?
    private var timer: Timer?
    var warningDistance: Int? {
        return currentJourney?.warnDistance
    }
    
    init() {
        print("Initialized JourneyViewModel")
    }
    
    deinit {
        stopTimer()
    }
    
    
    func startJourney() {
        currentJourney = TravelManager.shared.getDestiny()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        isUserTraveling = true
    }
    
    @objc func runTimedCode() {
        if let location = currentJourney?.coordinates {
            distanceToDestiny = Int(LocationManager.shared.distanceTo(location) ?? 0)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        print("Timer stopped")
    }
    
}
