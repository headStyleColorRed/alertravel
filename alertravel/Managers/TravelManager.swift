//
//  TravelManager.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 26/4/21.
//
import Foundation
import MapKit

class TravelManager {
    static let shared = TravelManager()
    private var destiny: Destiny?
    private var isUserOnRoute: Bool = false
    
    private init() {}
}

// MARK: - Location
extension TravelManager {
    func getDestiny() -> Destiny? { return destiny }
    func setDestiny(_ destiny: Destiny) { self.destiny = destiny }
    
    func getUserRoute() -> Bool? { return isUserOnRoute }
    func setUserRoute(_ isUserOnRoute: Bool) { self.isUserOnRoute = isUserOnRoute }
}
