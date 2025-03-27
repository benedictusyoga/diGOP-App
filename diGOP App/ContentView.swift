//
//  ContentView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isNameSet: Bool = false

    var body: some View {
        Group{
            if isNameSet{
                MainTabView()
            }else{
                SplashScreenView()
            }
        }
        .onAppear(){
            checkUserProfile()
        }
    }
    
    private func checkUserProfile(){
        if let user = try? modelContext.fetch(FetchDescriptor<UserProfile>()).first{
            isNameSet = !user.name.isEmpty
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
