import SwiftUI
import SwiftData

struct CheckpointProgressDot: View {
    let isActive: Bool
    let isCompleted: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isActive ? Color.red : (isCompleted ? Color.blue : Color.gray))
                .frame(width: 12, height: 12)
            
            if isActive {
                Circle()
                    .stroke(Color.red.opacity(0.3), lineWidth: 2)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct JourneyProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var journey: Journey
    @Bindable var user: UserProfile
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Vertical Progress Tracker
            VStack(spacing: 0) {
                ForEach(0..<journey.checkpoints.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        CheckpointProgressDot(
                            isActive: index == currentIndex,
                            isCompleted: index < currentIndex
                        )
                        
                        if index < journey.checkpoints.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 2, height: 50)
                        }
                    }
                }
            }
            .padding(.top, 100)
            
            // Main Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start Here")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Find this checkpoint to kick off your Journey!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if currentIndex < journey.checkpoints.count {
                        let checkpoint = journey.checkpoints[currentIndex]
                        
                        // Checkpoint Card
                        VStack(spacing: 0) {
                            // Graphic Area
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 300)
                                .cornerRadius(12, corners: [.topLeft, .topRight])
                                .overlay(
                                    Text("Graphic")
                                        .foregroundColor(.gray)
                                )
                            
                            // Details Area
                            VStack(alignment: .leading, spacing: 16) {
                                // Name
                                HStack {
                                    Text("Name")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(checkpoint.title)
                                }
                                
                                // XP
                                HStack {
                                    Text("XP")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("+\(journey.xpReward) XP")
                                }
                                
                                Divider()
                                
                                // Hint
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Hint")
                                        .foregroundColor(.secondary)
                                    Text(checkpoint.desc)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Helper extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
