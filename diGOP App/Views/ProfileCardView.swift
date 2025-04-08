import SwiftUI

enum InfoType: Identifiable {
    case avatar, lifetimeXP, nextRankXP
    
    var id: Int {
        hashValue
    }
}

struct ProfileCardView: View {
    @Bindable var user: UserProfile
    @Binding var isEditingName: Bool
    @State private var selectedInfo: InfoType? = nil
    
    
    
    var body: some View {
        VStack(spacing: 28) {
            // MARK: - Avatar, Name & Rank
            HStack(alignment: .center, spacing: 20) {
                Image(user.avatarName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedInfo = .avatar
                    }
                
                VStack(alignment: .leading, spacing: 6) {
                    Button {
                        isEditingName = true
                    } label: {
                        HStack(spacing: 6) {
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    HStack{
                        Text("Rank:")
                            .font(.caption)
                        Text(user.rank.rawValue.capitalized)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(6)
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // MARK: - XP Stat Cards
            HStack(spacing: 16) {
                // Lifetime XP Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Lifetime XP")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("\(user.totalXP) XP")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(minHeight: 60, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                )
                .onTapGesture {
                    selectedInfo = .lifetimeXP
                }
                
                // XP to Next Rank Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("To Next Rank")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    
                    let progress = user.totalXP - user.rank.minXP
                    let required = user.rank.requiredXP
                    let progressRatio = min(Double(progress) / Double(required), 1.0)
                    
                    Text("\(progress) / \(required) XP")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(height: 6)
                            .foregroundColor(Color.white.opacity(0.25))
                        
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 6)
                                .frame(width: geometry.size.width * CGFloat(progressRatio), height: 6)
                                .foregroundColor(.white)
                                .animation(.easeOut(duration: 0.4), value: progressRatio)
                        }
                        .frame(height: 6)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 60)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                )
                .onTapGesture{
                    selectedInfo = .nextRankXP
                }
            }
            .padding(.horizontal)
            
        }
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
        .sheet(item: $selectedInfo) { infoType in
            ProfileInfoSheet(infoType: infoType)
        }
        
    }
}

struct ProfileInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    var infoType: InfoType
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Icon Header
                    iconHeader
                    
                    // Content Card
                    contentCard
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
            .navigationTitle("More Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Icon Header View
    var iconHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(iconColor)
                .padding()
                .background(iconColor.opacity(0.1))
                .clipShape(Circle())
            
            Text(titleText)
                .font(.title2.bold())
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Content Card View
    var contentCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(contentSections, id: \.title) { section in
                VStack(alignment: .leading, spacing: 8) {
                    Text(section.title)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    
                    Text(section.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                
            }
            // Add this below contentSections.forEach
            if infoType == .nextRankXP || infoType == .avatar{
                VStack(alignment: .leading, spacing: 16) {
                    Text("Available Ranks")
                        .font(.headline)
                        .padding(.top, 4)
                        .foregroundColor(.accentColor)

                    ForEach(Rank.allCases, id: \.self) { rank in
                        HStack(spacing: 16) {
                            Image(rank.avatarImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(rank.displayName)
                                    .font(.subheadline.bold())

                                Text("\(rank.minXP) XP")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }

            
        }
    }
    
    // MARK: - Content & Icons by Info Type
    var titleText: String {
        switch infoType {
        case .avatar:
            return "This is Your Badge"
        case .lifetimeXP:
            return "Lifetime EXP"
        case .nextRankXP:
            return "EXP to Next Rank"
        }
    }
    
    var iconName: String {
        switch infoType {
        case .avatar:
            return "shield.lefthalf.filled"
        case .lifetimeXP:
            return "star.circle.fill"
        case .nextRankXP:
            return "chart.bar.xaxis"
        }
    }
    
    var iconColor: Color {
        switch infoType {
        case .avatar:
            return .blue
        case .lifetimeXP:
            return .yellow
        case .nextRankXP:
            return .green
        }
    }
    
    var contentSections: [(title: String, description: String)] {
        switch infoType {
        case .avatar:
            return [
                (
                    "What Is It?",
                    "Your badge shows your progress in all of the journeys. It changes corespondingly to your rank progression in diGOP."
                ),
                (
                    "Purpose",
                    "It shows how much of the GOP area you have explored. You can also compare badges with your friends and brag about how much better of an explorer you are!"
                )
            ]
            
        case .lifetimeXP:
            return [
                (
                    "What Is It?",
                    "Lifetime XP is the total amount of experience you have accumulated across all your journeys."
                ),
                (
                    "How to Earn?",
                    "Each time you complete a journey, earn XP based on the number of checkpoints there are. The more you explore, the more XP you'll earn!"
                )
            ]
            
        case .nextRankXP:
            return [
                (
                    "What Is It?",
                    "This section shows how much EXP you have to earn before reaching the next rank!"
                )
            ]
        }
        
    }
    
}


