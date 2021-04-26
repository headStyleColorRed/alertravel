//
//  ContentView.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            JourneyView()
                .tabItem {
                    Image(systemName: "tram")
                        .padding(.bottom, 20)
                    Text("Journey")
            }
            Text("Historic")
                .tabItem {
                    Image(systemName: "clock")
                    Spacer()
                    Text("Historic")
                }
        }.accentColor(.white)
    }
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "DarkBackground")
        LocationManager.shared.requestLocation()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
