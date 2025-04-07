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

struct EditNameView: View {
    @Bindable var user: UserProfile
    @Binding var isPresented: Bool
    @State private var tempName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Your name", text: $tempName)
                        .autocapitalization(.words)
                }
            }
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        user.name = tempName
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            tempName = user.name // Pre-fill with current name when sheet appears
        }
    }
}
#Preview {
    
}


struct JourneyListView: View {
    @State private var selectedSortOption: JourneySortOption = .alphabetical
    @State private var searchText: String = ""
    @State private var expandedJourney: Journey?
    var journeys = Journey.sampleJourneys
    @Query private var userProfiles: [UserProfile]
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @State private var showWelcomeAlert: Bool = false
    @State private var isEditingName: Bool = false
    
    
    
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
                    if let user = userProfiles.first {
                        ProfileCardView(user: user, isEditingName: $isEditingName)
                            .sheet(isPresented: $isEditingName) {
                                EditNameView(user: user, isPresented: $isEditingName)
                                    .presentationDetents([.medium])
                                    .presentationDragIndicator(.visible)
                            }
                            .padding(.top, 12)
                    }
                    
                    HStack {
                        Image("diGOP Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Journeys")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Where do we feel like exploring today?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                        
                    }
                    .padding(.horizontal, 24)
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
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                                    withAnimation {
                                                        proxy.scrollTo(journey.id, anchor: .top)
                                                    }
                                                }
                                            }
                                        }
                                    },
                                    user: userProfiles.first // 👈 Pass current user
                                )
                                
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24) // This ensures the content has horizontal padding
                }
                .searchable(text: $searchText, prompt: "Search for Journeys")
                .navigationTitle("diGOP")
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
    var user: UserProfile?  // Still optional
    @State private var showCheckpoints = false
    
    @State private var showExpandedContent: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 24) {
                        Spacer().frame(width: 70)
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
                    .padding(16)
                    
                    if isExpanded && showExpandedContent {
                        VStack(alignment: .leading, spacing: 12) {
                            MapViewPreview(journey: journey)
                                .frame(height: 120)
                                .cornerRadius(10)
                            
                            
                            VStack(alignment: .leading, spacing: 16) {
                                DisclosureGroup(
                                    isExpanded: $showCheckpoints,
                                    content: {
                                        VStack(alignment: .leading, spacing: 0) {
                                            ForEach(Array(journey.checkpoints.enumerated()), id: \.1.id) { index, checkpoint in
                                                HStack(alignment: .top, spacing: 2) {
                                                    // Dot and line
                                                    VStack(spacing: 0) {
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
                                                                .padding(.top, 2)
                                                        }
                                                    }
                                                    .frame(width: 16)
                                                    .padding(.top, 2)
                                                    
                                                    // Checkpoint title
                                                    Text(checkpoint.title)
                                                        .font(.caption)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(checkpoint.isCompleted ? .gray : .primary)
                                                        .strikethrough(checkpoint.isCompleted, color: .gray)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 14)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color(.secondarySystemBackground))
                                                        )
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(Color(.separator), lineWidth: 0.5)
                                                        )
                                                }
                                                .padding(.bottom, 2)
                                                
                                            }
                                            
                                        }
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                        .padding(.horizontal)
                                        .padding(.top, 24)
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
                            .padding(.horizontal)
                            
                            
                            
                            // ✅ Conditionally show the button only if `user` is not nil
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
                
                JourneyImageLoader(imageName: journey.title, isExpanded: isExpanded)
                    .offset(x: -8, y: -24)
                    .zIndex(1)
            }
            .padding(.bottom, isExpanded ? 16 : 4)
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
