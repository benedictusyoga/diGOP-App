import SwiftUI
import SwiftData

struct JourneyProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var journey: Journey
    @Bindable var user: UserProfile

    @State private var currentIndex: Int = 0
    @State private var isCompleted: Bool = false
    @State private var didGainRank: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ProgressView(value: journey.progress)
                    .progressViewStyle(.linear)
                    .padding()

                if currentIndex < journey.checkpoints.count {
                    let checkpoint = journey.checkpoints[currentIndex]

                    VStack(spacing: 16) {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)

                        Text(checkpoint.title)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(checkpoint.desc)
                            .font(.body)
                            .multilineTextAlignment(.center)

                        Spacer()

                        Button("Next Checkpoint") {
                            advanceCheckpoint()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 16)
                    }
                    .padding()
                } else if isCompleted {
                    completionView
                }

                Spacer()
            }
            .navigationTitle(journey.title)
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }

    private var completionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.green)

            Text("Journey Completed!")
                .font(.title)
                .fontWeight(.bold)

            Text("You've earned \(journey.xpReward) XP.")
                .font(.body)

            Image(user.rank.avatarImageName)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .shadow(radius: 6)

            Text("Rank: \(user.rank.rawValue.capitalized)")
                .font(.headline)
                .foregroundColor(.blue)

            if didGainRank {
                Text("🎉 You ranked up!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
        }
    }

    private func advanceCheckpoint() {
        journey.completedCheckpoints += 1
        currentIndex += 1

        if currentIndex >= journey.checkpoints.count {
            isCompleted = true
            grantXPForCompletion()
        }
    }

    private func grantXPForCompletion() {
        let xpReward = journey.xpReward
        let previousRank = user.rank

        user.gainXP(xpReward)
        modelContext.insert(user)

        // Check if user gained a new rank
        if user.rank != previousRank {
            didGainRank = true
        }
    }
}
