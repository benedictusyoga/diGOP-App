//
//  JourneyListView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import SwiftData
import MapKit

struct JourneyListView: View {
    @State private var searchText: String = ""
    @State private var expandedJourney: Journey?
    var journeys = Journey.sampleJourneys
    
    var filteredJourneys: [Journey]{
        if searchText.isEmpty{
            return journeys
        }else{
            return journeys.filter{$0.title.lowercased().contains(searchText.lowercased())}
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 8){
                
                
                ScrollView{
                    VStack(spacing: 8){
                        ForEach(filteredJourneys) { journey in
                            JourneyCardView(journey: journey,
                                            isExpanded: expandedJourney == journey,
                                            onToggleExpand:{
                                withAnimation{
                                    expandedJourney = (expandedJourney == journey) ? nil : journey
                                }
                            }
                            )
                        }
                    }
                    .padding()
                }
                .searchable(text: $searchText, prompt: "Search for Journeys")
            }
            .navigationTitle("Journeys")
        }
    }
}

struct JourneyCardView: View{
    var journey: Journey
    var isExpanded: Bool
    var onToggleExpand: () -> Void
    
    var body: some View{
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Image(systemName: "map.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                VStack(alignment: .leading){
                    Text(journey.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(journey.desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack{
                        Label("\(journey.checkpoints.count) Checkpoints", systemImage: "flag.fill")
                            .foregroundColor(.blue)
                    }
                    .font(.caption)
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .onTapGesture {
                withAnimation {
                    onToggleExpand()
                }
            }
            .sensoryFeedback(.selection, trigger: isExpanded)

            
            if isExpanded{
                VStack(alignment: .leading, spacing: 8){
                    MapViewPreview(journey: journey)
                        .frame(height: 120)
                        .cornerRadius(10)
                    VStack(alignment: .leading){
                        ForEach(journey.checkpoints) { checkpoint in
                            HStack{
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.blue)
                                Text(checkpoint.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                .zIndex(-1.0)
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MapViewPreview: View {
    var journey: Journey
    @State private var region: MKCoordinateRegion

    init(journey: Journey) {
        self.journey = journey
        if let firstCheckpoint = journey.checkpoints.first {
            _region = State(initialValue: MKCoordinateRegion(
                center: firstCheckpoint.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            ))
        } else {
            _region = State(initialValue: MKCoordinateRegion()) // Default region
        }
    }

    var body: some View {
        Map(initialPosition: .region(region)) {
            ForEach(journey.checkpoints) { checkpoint in
                Annotation(checkpoint.title, coordinate: checkpoint.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    JourneyListView()
}
