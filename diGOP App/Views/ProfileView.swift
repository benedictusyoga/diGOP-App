import SwiftUI

struct CustomColors {
    static let blue = Color(red: 75/255, green: 179/255, blue: 255/255)
}

struct ProfileView: View {
    @State private var isEditingName = false
    @State private var name = "User Name"
    
    var body: some View {
        VStack(spacing: 20) {
            ProfileHeader()
            ProfileDetails(name: $name, isEditingName: $isEditingName)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isEditingName) {
            EditNameView(name: $name)
                .presentationDetents([.medium])
        }
    }
}

struct ProfileHeader: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.black)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

struct ProfileDetails: View {
    @Binding var name: String
    @Binding var isEditingName: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ProfileRow(title: "Name", value: name, isBold: false, showArrow: true)
                .onTapGesture {
                    isEditingName = true
                }
            Divider()
            ProfileRow(title: "Your current rank:", value: "Global Elite", isBold: false, showArrow: false)
            Divider()
            VStack(alignment: .leading) {
                HStack {
                    Text("Experience Points:")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    Text("22/100")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.black)
                }
                ProgressView(value: 22, total: 100)
                    .progressViewStyle(LinearProgressViewStyle())
                    .accentColor(.blue)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ProfileRow: View {
    var title: String
    var value: String
    var isBold: Bool
    var showArrow: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .fontWeight(isBold ? .bold : .regular)
                .foregroundColor(.black)
            if showArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}

struct EditNameView: View {
    @Binding var name: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Edit Name")
                    .font(.headline)
                TextField("Enter your name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Save") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
