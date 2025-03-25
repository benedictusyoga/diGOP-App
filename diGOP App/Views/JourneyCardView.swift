//
//  JourneyCardView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import SwiftData

struct JourneyCardView: View {
    var journey: Journey
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            Image(systemName: "map.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 4){
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
        .shadow(radius: 2)
    }
}

#Preview {
    JourneyCardView(journey: Journey(title: "GOP 9", desc: "Office Space", checkpoints: Array(repeating: Checkpoint(title: "Sample", desc: "Sample", imageName: "diGOP Logo", latitude: -2.1231, longitude: 10.23913), count: 5)))
}
