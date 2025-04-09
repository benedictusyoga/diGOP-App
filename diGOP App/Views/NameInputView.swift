//
//  NameInputView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI
import SwiftData

struct NameInputView: View {
    @State private var name: String = ""
    @State private var isNameSaved = false
    @State private var showSkipAlert = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            VStack(spacing: 20){
                LogoView(offset: -20)
                VStack{
                    Text("Hey there! Before starting your journey,")
                        .font(.subheadline)
                    Text("What can we call you?")
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color(.systemBlue))
                }
                
                TextField("Nickname", text: $name)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .autocorrectionDisabled(true)
                
                VStack(spacing: 12) {
                    Button(action: saveName) {
                        HStack {
                            Image(systemName: "figure.run")
                            Text("Start Your Journey")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(name.isEmpty ? Color.gray.opacity(0.4) : Color.accentColor)
                        .cornerRadius(10)
                    }
                    .disabled(name.isEmpty)

                    Button(action: {
                            showSkipAlert = true
                        }) {
                            Text("Skip for now")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .underline()
                        }
                }
                .padding(.horizontal)
                .alert("Are You Sure?", isPresented: $showSkipAlert) {
                    Button("Continue", role: .destructive, action: skipName)
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("The system will assign a default name for you. You may change it later.")
                }

            }
            .padding()
            .onAppear{
                if let user = try? modelContext.fetch(FetchDescriptor<UserProfile>()).first{
                    name = user.name
                    isNameSaved = true
                }
            }
            .fullScreenCover(isPresented: $isNameSaved) {
                JourneyListView()
            }
        }
        
    }
    
    
    private func saveName() {
        let user = UserProfile(name: name)
        modelContext.insert(user)
        
        do {
            try modelContext.save()
            isNameSaved = true
        } catch {
            print("❌ Error saving name: \(error.localizedDescription)")
        }
    }
    
    private func skipName() {
        let user = UserProfile(name: "GOP Explorer")
        modelContext.insert(user)
        
        do {
            try modelContext.save()
            isNameSaved = true
        } catch {
            print("Error Saving Default Name!")
        }
    }

}

#Preview {
    NameInputView()
}
