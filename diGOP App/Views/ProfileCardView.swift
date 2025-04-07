import SwiftUI

struct ProfileCardView: View {
    @Bindable var user: UserProfile
    @Binding var isEditingName: Bool
    

    var body: some View {
        VStack(spacing: 28) {
            // MARK: - Avatar, Name & Rank
            HStack(alignment: .center, spacing: 20) {
                Image(user.avatarName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())

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
    }
}
