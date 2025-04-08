//
//  JourneyImageLoader.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 05/04/25.
//

import SwiftUI

struct JourneyImageLoader: View {
    var imageName: String
    var placeholder: String = "photo.artframe.circle.fill"
    var isExpanded: Bool
    
    var body: some View {
        if let uiIMage = UIImage(named: imageName) {
            Image(uiImage: uiIMage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue, Color.indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                )
            
                .background(Circle().fill(Color(.tertiarySystemBackground)))
                .rotationEffect(.degrees(isExpanded ? -20 : 0))
                .animation(.easeInOut(duration: 0.3), value: isExpanded)
                .zIndex(1)
        } else {
            Image(systemName: placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue, Color.indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                )
            
                .background(Circle().fill(Color(.tertiarySystemBackground)))
                .rotationEffect(.degrees(isExpanded ? -20 : 0))
                .animation(.easeInOut(duration: 0.3), value: isExpanded)
                .zIndex(1)
                .foregroundColor(Color(.systemGray2))
        }
    }
}
