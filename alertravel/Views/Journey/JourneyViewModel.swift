//
//  JourneyViewModel.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI


enum JourneyState {
    case noJourney
    case traveling
    case inDestination
}

class JourneyViewModel: NSObject, ObservableObject {
    @Published var distanceToDestiny: Int = 0
    @Published var journeyStatus: JourneyState = .noJourney
    
    private var currentJourney: Destiny?
    
    var warningDistance: Int? {
        return currentJourney?.warnDistance
    }
    
    override init() {
        super.init()
        print("Initialized JourneyViewModel")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("User accepted localitation authorisation")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        LocationManager.shared.delegate = self
    }
    
    deinit {
        LocationManager.shared.stopLocation()
    }
    
    
    func startJourney() {
        LocationManager.shared.startLocation()
        currentJourney = TravelManager.shared.getDestiny()
        journeyStatus = .traveling
    }
    
    func handleDistanceLogic() {
        print("Looped Called")
        if let location = currentJourney?.coordinates, let warnDistance = currentJourney?.warnDistance {
            distanceToDestiny = Int(LocationManager.shared.distanceTo(location) ?? 0)
            print("Distance to destiny: \(distanceToDestiny)")
            if distanceToDestiny <= warnDistance {
                sendArrivalNotification()
                endJourney()
            }
        }
    }
    
    func endJourney() {
        LocationManager.shared.stopLocation()
        journeyStatus = .inDestination
        currentJourney = nil
        distanceToDestiny = 0
    }
    
    private func sendArrivalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You have arrived"
        content.subtitle = "You are already within \(getDistanceToDestiny())"
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "train-horn.mp3"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func getDistanceToDestiny() -> Int {
        guard let location = currentJourney?.coordinates else { return 0}
        return Int(LocationManager.shared.distanceTo(location) ?? 0)
    }
    
    
    // MARK: - Background Tasks
    func appWentBackground() {
        print("App went background")
    }
    
    func appBecameActive() {
        print("App became Active")
    }
}

// MARK: - Location
extension JourneyViewModel: LocationManagerProtocol {
    func locationUpdated() {
        handleDistanceLogic()
    }
    
    
}
