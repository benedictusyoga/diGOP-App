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
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            Color(.systemBackground),
                            lineWidth: 8
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
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            Color(.systemBackground),
                            lineWidth: 8
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

#Preview {
    JourneyListView()
}
