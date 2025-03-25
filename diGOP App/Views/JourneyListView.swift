//
//  JourneyListView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import SwiftData

struct JourneyListView: View {
    @Environment(\.modelContext) private var modelContext
    //    @Query var journeys: [Journey]
    var journeys = Journey.sampleJourneys
    @State private var searchText: String = ""
    @State private var selectedJourney: Journey?
    @State private var showDetailSheet = false
    @Query var userProfile: [UserProfile]
    @State private var timer: Timer?
    
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
                HStack(spacing: 2) {
                    Image("diGOP Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40) // Slightly bigger logo
                    
                    VStack(alignment: .leading) {
                        Text("Hi, Yoga.")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Choose Your First Journey!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                List{
                    ForEach(filteredJourneys) { journey in
                        Button(action:{
                            showDetailSheet.toggle()
                            selectedJourney = journey
                        }){
                            JourneyCardView(journey: journey)
                                .padding(.vertical, 0)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .sensoryFeedback(.success, trigger: showDetailSheet)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Journeys")
                .searchable(text: $searchText, prompt: "Search for a Journey!")
                .sheet(item: $selectedJourney) { journey in
                    JourneyDetailSheets(journey: journey)
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }
    
}

#Preview {
    JourneyListView()
}
