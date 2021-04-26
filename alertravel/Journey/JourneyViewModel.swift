//
//  JourneyViewModel.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI

class JourneyViewModel: ObservableObject {
    @Published var currentJourney: JourneyModel?
    
    init() {
        print("Initialized JourneyViewModel")
    }
    
    
    func isUserTraveling() -> Bool {
        return currentJourney != nil
    }
    
}
