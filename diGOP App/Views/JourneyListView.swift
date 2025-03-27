//
//  JourneyListView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import SwiftData
import MapKit

enum JourneySortOption: String, CaseIterable, Identifiable {
    case alphabetical = "A-Z"
    case checkpointCount = "Most Checkpoints"
    
    var id: String { self.rawValue }
}

struct JourneyListView: View {
    @State private var selectedSortOption: JourneySortOption = .alphabetical
    @State private var searchText: String = ""
    @State private var expandedJourney: Journey?
    var journeys = Journey.sampleJourneys
    @Query private var userProfiles: [UserProfile]
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @State private var showWelcomeAlert: Bool = false
    
    var filteredJourneys: [Journey] {
        var result = journeys
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        // Apply sorting
        switch selectedSortOption {
        case .alphabetical:
            result = result.sorted { $0.title < $1.title }
        case .checkpointCount:
            result = result.sorted { $0.checkpoints.count > $1.checkpoints.count }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    HStack(alignment: .center) {
                        Image("diGOP Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Hi, \(userProfiles.first?.name ?? "NAMEERR")")
                                .font(.headline)
                            Text("Choose your first Journey!")
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    .padding() // Ensures padding inside HStack
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                    )
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(spacing: 12) {
                            ForEach(filteredJourneys) { journey in
                                JourneyCardView(
                                    journey: journey,
                                    isExpanded: expandedJourney == journey,
                                    onToggleExpand: {
                                        withAnimation {
                                            if expandedJourney == journey {
                                                expandedJourney = nil
                                            } else {
                                                expandedJourney = journey
                                                
                                                // Scroll into view
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                    withAnimation {
                                                        proxy.scrollTo(journey.id, anchor: .top)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24) // This ensures the content has horizontal padding
                }
                .searchable(text: $searchText, prompt: "Search for Journeys")
                .navigationTitle("Choose Journey")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Picker("Sort by", selection: $selectedSortOption) {
                                ForEach(JourneySortOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(.menu)
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                .background(Color(.secondarySystemBackground))
                
            }
        }
        .onAppear{
            if !hasSeenWelcome {
                showWelcomeAlert = true
                hasSeenWelcome = true // Mark as seen
            }
        }
        .alert("Welcome to diGOP", isPresented: $showWelcomeAlert){
            Button("Let's Go!", role: .cancel){}
        } message: {
            Text("Let's get started by selecting your First Journey!")
        }
    }
    
}

struct JourneyCardView: View {
    var journey: Journey
    var isExpanded: Bool
    var onToggleExpand: () -> Void
    @State private var showExpandedContent: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 24) {
                        Spacer().frame(width: 70) // reserved image space
                        VStack(alignment: .leading, spacing: 6) {
                            Text(journey.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(journey.desc)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 4) {
                                Label("\(journey.checkpoints.count) Checkpoints", systemImage: "flag.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption2)
                            }
                        }
                        Spacer()
                    }
                    .padding(16) // Equal padding on all sides of the header
                    
                    if isExpanded && showExpandedContent {
                        VStack(alignment: .leading, spacing: 12) {
                            MapViewPreview(journey: journey)
                                .frame(height: 120)
                                .cornerRadius(10)
                            
                            VStack(spacing: 8) {
                                ForEach(journey.checkpoints) { checkpoint in
                                    HStack {
                                        Image(systemName: checkpoint.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(checkpoint.isCompleted ? .green : .gray)
                                        Text(checkpoint.title)
                                            .foregroundColor(checkpoint.isCompleted ? .gray : .primary)
                                            .strikethrough(checkpoint.isCompleted, color: .gray)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding()

                        }
                        .transition(.opacity.combined(with: .scale(0.95, anchor: .top)))
                        .animation(.easeOut(duration: 0.2), value: showExpandedContent)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .padding(.top, 4)
                    }
                }
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(12)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        if isExpanded {
                            showExpandedContent = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                onToggleExpand()
                            }
                        } else {
                            onToggleExpand()
                            showExpandedContent = true
                        }
                    }
                }
                .sensoryFeedback(.selection, trigger: isExpanded)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
                
                // MARK: - Floating Image (Preserved Layout)
                JourneyImageLoader(imageName: journey.title, isExpanded: isExpanded)
                    .offset(x: -8, y: -24)
                    .zIndex(1)
            }
            .padding(.bottom, isExpanded ? 12 : 4)
        }
        .padding(.top, 8)
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
