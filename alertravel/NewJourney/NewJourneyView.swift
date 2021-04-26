//
//  NewJourney.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI
import MapKit

struct NewJourneyView: View {
    @ObservedObject var viewModel = NewJourneyViewModel()
    @State private var selectedDistance = "1000"
    @State var location = CLLocationCoordinate2D()
    var distance = ["50", "100", "200", "500", "750", "1000", "1500", "2000", "5000"]
    
    var body: some View {
        ZStack {
            Color.AT.darkBackground
                .edgesIgnoringSafeArea([.all])
            VStack {
                Text("Hi! Choose a destination")
                    .foregroundColor(.white)
                    .font(.headline)
                MapView(destiny: $location)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                Group {
                    Text("Please choose a distance to be warned")
                        .foregroundColor(.white)
                        .font(.headline)
                    Picker("", selection: $selectedDistance) {
                        ForEach(distance, id: \.self) {
                            Text("\($0)m")
                                .foregroundColor(.white)
                        }
                    }
                }
                Button(action: {
                    print("setted")
                }) {
                    Text("Begin")
                        .frame(width: UIScreen.main.bounds.width / 2, height: 30, alignment: .center)
                        .background(Color.AT.orangeDetail)
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var destiny: CLLocationCoordinate2D
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        
        var gRecognizer = UILongPressGestureRecognizer()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }
        
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            let marker = Marker(coordinate: coordinate, title: "", subtitle: "")
            //Remove last marker
            let lastMarker = parent.mapView.annotations
            parent.mapView.removeAnnotations(lastMarker)
            parent.mapView.addAnnotation(marker)
        }
    }
}

class Marker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}








struct NewJourney_Previews: PreviewProvider {
    static var previews: some View {
        NewJourneyView()
    }
}
