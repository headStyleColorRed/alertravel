//
//  Journey.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI

struct JourneyView: View {
    @ObservedObject var viewModel = JourneyViewModel()
    @State private var action: Int? = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: NewJourneyView(), tag: 1, selection: $action) {
                    EmptyView()
                }
                
                Color.AT.darkBackground
                    .edgesIgnoringSafeArea([.all])
                
                if viewModel.isUserTraveling() {
                    Text("No journey yet")
                } else {
                    NoJourneyView() {
                        action = 1
                    }
                }
            }
        }
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





struct Journey_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}
