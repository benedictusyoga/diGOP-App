//
//  MainTabView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 06/04/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            JourneyListView()
                .tabItem {
                    Label("Journey", systemImage: "map.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
