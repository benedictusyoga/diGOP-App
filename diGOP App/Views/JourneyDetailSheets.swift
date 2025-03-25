//
//  JourneyDetailView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import MapKit

struct JourneyDetailSheets: View {
    var journey: Journey
    @State private var region = MKCoordinateRegion()
    @State private var route: MKPolyline?
    @State private var isCheckpointsExpanded: Bool = false
    
    var body: some View {
        VStack {
            Text(journey.title)
                .font(.title)
                .fontWeight(.bold)
            
            // Map with route
            Map(coordinateRegion: $region, annotationItems: journey.checkpoints) { checkpoint in
                MapAnnotation(coordinate: checkpoint.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                        Text(checkpoint.title)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
            .overlay(RouteOverlay(route: route), alignment: .center)
            .onAppear {
                setupMap()
            }
            .frame(height: 300)
            
            DisclosureGroup("View Checkpoints", isExpanded: $isCheckpointsExpanded) {
                            VStack(alignment: .leading) {
                                ForEach(journey.checkpoints) { checkpoint in
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.blue)
                                        VStack(alignment: .leading) {
                                            Text(checkpoint.title)
                                                .font(.headline)
                                            Text(checkpoint.desc)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
        }
        .padding()
    }
    
    private func setupMap(){
        if let firstCheckpoint = journey.checkpoints.first{
            region = MKCoordinateRegion(
                center: firstCheckpoint.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        let coordinates = journey.checkpoints.map{$0.coordinate}
        route = MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}

struct RouteOverlay: UIViewRepresentable{
    var route: MKPolyline?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if let route = route{
            mapView.addOverlay(route)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteOverlay
        
        init(_ parent: RouteOverlay) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
