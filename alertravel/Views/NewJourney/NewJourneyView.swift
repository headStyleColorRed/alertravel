//
//  NewJourney.swift
//  alertravel
//
//  Created by Rodrigo Labrador Serrano on 23/4/21.
//

import SwiftUI
import MapKit

protocol NewJourneyViewProtocol {
    func userHasADestination()
}

struct NewJourneyView: View {
    @ObservedObject var viewModel = NewJourneyViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var selectedDistance = "1000"
    @State var location = CLLocationCoordinate2D()
    var distance = ["50", "100", "200", "500", "750", "1000", "1500", "2000", "5000"]
    var delegate: NewJourneyViewProtocol
    
    var body: some View {
        ZStack {
            Color.AT.darkBackground
                .edgesIgnoringSafeArea([.all])

            ScrollView {
                VStack {
                    Text("Hi! Choose a destination")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                    MapView(destiny: $location)
                        .frame(width: UIScreen.main.bounds.width, height: 250, alignment: .center)
                    Group {
                        Text("Choose a distance to be warned:")
                            .foregroundColor(.white)
                            .font(.headline)
                        Picker("", selection: $selectedDistance) {
                            ForEach(distance, id: \.self) {
                                Text("\($0)m")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 200)
                        .clipped()
                    }
                    Button(action: {
                        guard location.latitude != 0.0 else { return }
                        let finalLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        TravelManager.shared.setDestiny(Destiny(coordinates: finalLocation, warnDistance: Int(selectedDistance) ?? 0))
                        self.mode.wrappedValue.dismiss()
                        delegate.userHasADestination()
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
        .navigationBarTitleDisplayMode(.inline)
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
            
            guard let center = LocationManager.shared.getUserLocation()?.coordinate else { return }
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let userRegion = MKCoordinateRegion(center: center, span: span)
            self.parent.mapView.setRegion(userRegion, animated: true)
            self.parent.mapView.showsUserLocation = true
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
            parent.destiny = marker.coordinate
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
        NewJourneyView(delegate: self as! NewJourneyViewProtocol)
    }
}
