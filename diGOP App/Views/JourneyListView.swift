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
    case alphabetical = "Default (Alphabetical)"
    case checkpointCount = "Challenge Me!"
    
    var id: String { self.rawValue }
}

struct JourneyListView: View {
    @State private var searchText: String = ""
    @State private var selectedSortOption: JourneySortOption = .alphabetical
    
    @State private var showWelcomeAlert: Bool = false
    @State private var profileHide: Bool = false
    @State private var isEditingName: Bool = false
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    
    @Query private var userProfiles: [UserProfile]
    
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView{
                    VStack (spacing: 24){
                        if !isSearching{
                            ProfileCardView(user: userProfiles.first ?? UserProfile(name: "PLC"), isEditingName: $isEditingName)
                                .sheet(isPresented: $isEditingName) {
                                    EditNameView(user: userProfiles.first ?? UserProfile(name: "PLC"), isPresented: $isEditingName)
                                        .presentationDetents([.medium])
                                        .presentationDragIndicator(.visible)
                                }
                                .padding(.top, 12)
                                .padding(.horizontal, 12)
                        }
                        
                        JourneysView(
                            scrollToJourney: { id in
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .top)
                                }
                            },
                            searchText: $searchText,
                            selectedSortOption: $selectedSortOption
                        )
                        .id("journeys")
                    }
                }
                .navigationTitle("diGOP")
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

struct JourneysView: View {
    var scrollToJourney: ((UUID) -> Void)? = nil
    
    @Query private var userProfiles: [UserProfile]
    @State private var expandedJourney: Journey?
    var journeys = Journey.sampleJourneys
    
    @Binding var searchText: String
    @Binding var selectedSortOption: JourneySortOption
    
    var filteredJourneys: [Journey] {
        var result = journeys
        
        if !searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            result = result.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        switch selectedSortOption {
        case .alphabetical:
            result = result.sorted { $0.title < $1.title }
        case .checkpointCount:
            result = result.sorted { $0.checkpoints.count > $1.checkpoints.count }
        }
        
        return result
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("diGOP Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Journeys")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.systemBlue))
                        .fontDesign(.rounded)
                    Text("Where do we feel like exploring today?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontDesign(.rounded)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 32)
            .padding(.bottom, 8)
            
            Divider()
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            
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
                                        scrollToJourney?(journey.id)
                                    }
                                }
                            },
                            user: userProfiles.first
                        )
                        
                    }
                    
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 8)
        }
        .searchable(text: $searchText, prompt: "Search for Journeys")
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 12)
    }
}



struct JourneyCardView: View {
    var journey: Journey
    
    var isExpanded: Bool
    var onToggleExpand: () -> Void
    var user: UserProfile?
    @State private var showCheckpoints = false
    @State private var showExpandedContent: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 16) {
                        Spacer().frame(width: 90)
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(journey.title)
                                    .font(.headline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(.systemBackground))
                                    .fontDesign(.rounded)

                                Text(journey.desc)
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray5))
                            }
                            
                            HStack(alignment: .center, spacing: 6){
                                Image(systemName: "figure.run.square.stack.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                Text("\(journey.checkpoints.count) Checkpoints")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(Color(.systemBlue))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .font(.caption)
                            .fontWeight(.semibold)
                            
                            
                            
                            
                        }
                        Spacer()
                    }
                    .padding(16)

                    if isExpanded && showExpandedContent {
                        VStack(alignment: .leading, spacing: 16) {
                            MapViewPreview(journey: journey)
                                .frame(height: 120)
                                .cornerRadius(12)

                            VStack(alignment: .leading, spacing: 12) {
                                DisclosureGroup(
                                    isExpanded: $showCheckpoints,
                                    content: {
                                        VStack(alignment: .leading, spacing: 8) {
                                            ForEach(Array(journey.checkpoints.enumerated()), id: \.1.id) { index, checkpoint in
                                                HStack(alignment: .top, spacing: 8) {
                                                    VStack(spacing: 2) {
                                                        ZStack {
                                                            Circle()
                                                                .fill(checkpoint.isCompleted ? Color.green : Color.gray)
                                                                .frame(width: 7, height: 7)

                                                            Circle()
                                                                .stroke(checkpoint.isCompleted ? Color.green.opacity(0.4) : Color.gray.opacity(0.3), lineWidth: 2)
                                                                .frame(width: 12, height: 12)
                                                        }

                                                        if index < journey.checkpoints.count - 1 {
                                                            Rectangle()
                                                                .fill(Color.gray.opacity(0.3))
                                                                .frame(width: 1.2, height: 20)
                                                        }
                                                    }
                                                    .frame(width: 16)

                                                    Text(checkpoint.title)
                                                        .font(.caption)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(checkpoint.isCompleted ? .gray : .primary)
                                                        .strikethrough(checkpoint.isCompleted, color: .gray)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 12)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color(.secondarySystemBackground))
                                                        )
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color(.separator), lineWidth: 0.5)
                                                        )
                                                }
                                            }
                                        }
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                        .padding(.top, 12)
                                    },
                                    label: {
                                        Label {
                                            Text("Checkpoints")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                        } icon: {
                                            Image(systemName: showCheckpoints ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                                        }
                                        .foregroundColor(.accentColor)
                                    }
                                )
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                )
                            }

                            if let user = user {
                                NavigationLink(destination: JourneyProgressView(journey: journey, user: user)) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                        Text("Start Journey")
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                }
                            } else {
                                Text("Unable to start: user not found")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                        }
                        .transition(.opacity.combined(with: .scale(0.95, anchor: .top)))
                        .animation(.easeOut(duration: 0.2), value: showExpandedContent)
                        .padding([.horizontal, .bottom], 16)
                        .padding(.top, 8)
                        
                    }
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black, radius: 6, x: 0, y: 4)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
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
                

                JourneyImageLoader(imageName: journey.title, isExpanded: isExpanded)
                    .offset(x: -15, y: -10)
                    .zIndex(1)
            }
            .padding(.bottom, isExpanded ? 16 : 0)
            
        }
        .padding(.top, 0)
        

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
            _region = State(initialValue: MKCoordinateRegion())
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
