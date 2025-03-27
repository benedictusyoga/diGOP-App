import SwiftUI
import SwiftData

// MARK: - Accent Color
struct CustomColors {
    static let accent = Color.blue
}

// MARK: - ProfileView
struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserProfile]
    @State private var isEditingName = false

    var body: some View {
        NavigationStack {
            if let user = users.first {
                ScrollView {
                    VStack(spacing: 32) {
                        ProfileHeader()
                        ProfileDetails(user: user, isEditingName: $isEditingName)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .background(Color(.secondarySystemBackground).ignoresSafeArea())
                .sheet(isPresented: $isEditingName) {
                    EditNameView(user: user)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.large)
            } else {
                ContentUnavailableView("No User Found", systemImage: "person.fill.questionmark")
            }
        }
    }
}

// MARK: - ProfileHeader
struct ProfileHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.primary)
                .background(Circle().fill(.ultraThinMaterial))
                .clipShape(Circle())

            Text("Welcome back!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - ProfileDetails
struct ProfileDetails: View {
    @Bindable var user: UserProfile
    @Binding var isEditingName: Bool

    var body: some View {
        VStack(spacing: 16) {
            SectionCard {
                ProfileRow(title: "Name", value: user.name, showArrow: true)
                    .onTapGesture {
                        isEditingName = true
                    }
                Divider()
                ProfileRow(title: "Your current rank", value: "Global Elite")
            }

            SectionCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Experience Points")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    HStack {
                        ProgressView(value: Double(user.experiencePoints), total: 100)
                            .progressViewStyle(.linear)
                            .tint(.blue)

                        Text("\(user.experiencePoints)/100")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - ProfileRow
struct ProfileRow: View {
    var title: String
    var value: String
    var showArrow: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
            if showArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
    }
}

// MARK: - SectionCard
struct SectionCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 12) {
            content
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
}

// MARK: - EditNameView
struct EditNameView: View {
    @Bindable var user: UserProfile
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Your name", text: $user.name)
                        .autocapitalization(.words)
                }
            }
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let modelContainer = try! ModelContainer(for: UserProfile.self)
    let user = UserProfile(name: "Yogatama", experiencePoints: 22)
    modelContainer.mainContext.insert(user)

    return ProfileView()
        .modelContainer(modelContainer)
}
