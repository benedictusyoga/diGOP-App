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
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            VStack(spacing: 20){
                LogoView(offset: -20)
                VStack{
                    Text("We'd love to address you properly")
                        .font(.subheadline)
                    Text("What's your preferred name?")
                        .font(.title3)
                }
                
                TextField("Nickname", text: $name)
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .autocorrectionDisabled(true)
                
                Button(action: saveName) {
                    HStack{
                        Image(systemName: "figure.run")
                        Text("Start Your Journey")
                            .font(.title3)
                            .cornerRadius(10)
                    }
                }
                .buttonStyle(.borderless)
                .disabled(name.isEmpty)
            }
            .padding()
            .onAppear{
                if let user = try? modelContext.fetch(FetchDescriptor<UserProfile>()).first{
                    name = user.name
                    isNameSaved = true
                }
            }
            .fullScreenCover(isPresented: $isNameSaved) {
                MainTabView()
            }
        }
        
    }
    
    
    private func saveName(){
        let user = UserProfile(name: name)
        modelContext.insert(user)
        
        do{
            try modelContext.save()
            isNameSaved = true
        }catch{
            print("Error Saving Name!")
        }
        
    }
}

#Preview {
    NameInputView()
}
