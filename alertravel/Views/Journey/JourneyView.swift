//
//  Journey.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI

struct JourneyView: View, NewJourneyViewProtocol {
    @ObservedObject var viewModel = JourneyViewModel()
    @State private var action: Int? = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: NewJourneyView(delegate: self), tag: 1, selection: $action) {
                    EmptyView()
                }
                
                Color.AT.darkBackground
                    .edgesIgnoringSafeArea([.all])
                
                switch viewModel.journeyStatus {
                case .noJourney:
                    NoJourneyView() { action = 1 }
                case .traveling:
                    CurrentJourneyView(distanceToDestiny: $viewModel.distanceToDestiny,
                                       warningDistance: viewModel.warningDistance,
                                       stopJourney: stopJourney)
                case .inDestination:
                    DestinationReached() {
                        viewModel.stopSound()
                        action = 1
                    }
                }
            }
        }
        .navigationBarTitle("Traveling", displayMode: .inline)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            viewModel.appWentBackground()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            viewModel.appBecameActive()
        }
    }
    
    
    func userHasADestination() {
        viewModel.startJourney()
    }
    
    func stopJourney() {
        viewModel.endJourney()
    }
}

struct CurrentJourneyView: View {
    @Binding var distanceToDestiny: Int
    @State var warningDistance: Int?
    @State private var distanceArray = [0, 0, 0, 0, 0]
    @State var stopJourney: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Text("Relax and enjoy the journey 😎 \n\n You'll be alerted once you are within \(warningDistance ?? 0) meters of your destination")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                HStack {
                    ForEach(distanceArray.indices) { index in
                        CustomPicker(selectedNumber: $distanceArray[index])
                    }
                    Text("Meters")
                        .foregroundColor(.white)
                }
                Spacer()
            }.onChange(of: distanceToDestiny, perform: { value in
                distanceArray = splitDistance(value)
            })
            
            VStack {
                Spacer()
                Button(action: {
                    stopJourney()
                }) {
                    Text("Stop")
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.black)
                        .background(Color.AT.orangeDetail)
                        .clipShape(Circle())
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func splitDistance(_ distance: Int) -> [Int] {
        guard distance < 100000, distance > 0 else { return [0, 0, 0, 0, 0] }
        
        let stringedDistance = String(distance)
        var splittedDistance = stringedDistance.compactMap{ $0.wholeNumberValue }
        for _ in 0...(4 - splittedDistance.count) {
            splittedDistance.insert(0, at: 0)
        }
        return splittedDistance
    }
}


struct CustomPicker: View {
    @Binding var selectedNumber: Int
    var numbers = 0...9
    
    var body: some View {
        Picker("Please choose a color", selection: $selectedNumber) {
            ForEach(numbers, id: \.self) {
                Text(String($0))
                    .foregroundColor(.white)
            }
        }
        .disabled(true)
        .frame(width: 50)
        .clipped()
    }
}

struct NoJourneyView: View {
    var showScreen: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("YOU HAVE \n\n NO \n\n TRIPS YET")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                showScreen()
            }) {
                Text("New Journey")
                    .frame(width: UIScreen.main.bounds.width / 2, height: 40, alignment: .center)
                    .background(Color.AT.orangeDetail)
                    .foregroundColor(.white)
                    .padding()
            }
            Spacer()
        }
    }
}

struct DestinationReached: View {
    var showScreen: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("YOU HAVE \n\n ARRIVED \n\n TO YOUR DESTINATION")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                showScreen()
            }) {
                Text("New Journey")
                    .frame(width: UIScreen.main.bounds.width / 2, height: 40, alignment: .center)
                    .background(Color.AT.orangeDetail)
                    .foregroundColor(.white)
                    .padding()
            }
            Spacer()
        }
    }
}




struct Journey_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}
