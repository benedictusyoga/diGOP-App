import SwiftUI
import SwiftData
import UIKit

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

struct CheckpointCard: View {
    let checkpoint: Checkpoint
    let xpReward: Int
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Graphic Area
            Image(checkpoint.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            // Details Area
            VStack(alignment: .leading, spacing: 16) {
                // Name
                HStack {
                    Text("Name")
                        .foregroundColor(.black)
                    Spacer()
                    Text(checkpoint.title)
                        .foregroundColor(.black)
                }
                
                // XP
                HStack {
                    Text("XP")
                        .foregroundColor(.black)
                    Spacer()
                    Text("+\(xpReward) XP")
                        .foregroundColor(.black)
                }
                
                Divider()
                
                // Hint
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hint")
                        .foregroundColor(.black)
                    Text(checkpoint.desc)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea())
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea())
        .cornerRadius(12)
        .shadow(radius: isActive ? 5 : 2)
        .scaleEffect(isActive ? 1.0 : 0.95)
        .opacity(isActive ? 1.0 : 0.8)
    }
}

// Add these new cell classes
class StartCard: UICollectionViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container setup
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        // Image setup
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "flag.fill")
        imageView.tintColor = .systemBlue
        
        // Labels setup
        titleLabel.text = "Start Your Journey"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Swipe up to begin exploring"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}

class EndCard: UICollectionViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let completeButton = UIButton(type: .system)
    private var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container setup
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        // Labels setup
        titleLabel.text = "Ready to Complete?"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "You've reached the end of this journey"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center
        
        // Button setup
        completeButton.setTitle("Complete Journey", for: .normal)
        completeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        completeButton.backgroundColor = .systemBlue
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 12
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, completeButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            completeButton.heightAnchor.constraint(equalToConstant: 50),
            completeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    func configure(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    @objc private func completeButtonTapped() {
        completionHandler?()
    }
}

// UICollectionView wrapper for SwiftUI
struct SnapScrollingCollectionView: UIViewRepresentable {
    let items: [Checkpoint]
    let xpReward: Int
    @Binding var currentIndex: Int?
    var onComplete: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        collectionView.register(CheckpointCell.self, forCellWithReuseIdentifier: "CheckpointCell")
        collectionView.register(StartCard.self, forCellWithReuseIdentifier: "StartCard")
        collectionView.register(EndCard.self, forCellWithReuseIdentifier: "EndCard")
        // collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        
        // Calculate insets to center first and last cards
        let screenHeight = UIScreen.main.bounds.height
        let cardHeight = screenHeight * 0.75
        let topBottomInset = (screenHeight - cardHeight) / 4  // Reduced from /2 to /4 to make top space smaller
        
        print("Debug values:")
        print("Screen height:", screenHeight)
        print("Card height:", cardHeight)
        print("Top bottom inset:", topBottomInset)
        print("Final top inset:", topBottomInset - 800)
        
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        return collectionView
    }
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        var parent: SnapScrollingCollectionView
        private var lastContentOffset: CGFloat = 0
        
        init(_ parent: SnapScrollingCollectionView) {
            self.parent = parent
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.items.count + 2 // Add 2 for start and end cards
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartCard", for: indexPath) as! StartCard
                return cell
            } else if indexPath.item == parent.items.count + 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EndCard", for: indexPath) as! EndCard
                cell.configure {
                    self.parent.onComplete()
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckpointCell", for: indexPath) as! CheckpointCell
                let checkpoint = parent.items[indexPath.item - 1]
                cell.configure(with: checkpoint, xpReward: parent.xpReward, isActive: indexPath.item - 1 == (parent.currentIndex ?? 0))
                return cell
            }
        }
        
        // func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //     if kind == UICollectionView.elementKindSectionHeader {
        //         let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        //         return headerView
        //     }
        //     return UICollectionReusableView()
        // }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 100)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenHeight = UIScreen.main.bounds.height
            let cardHeight = screenHeight * 0.75 // Card takes 75% of screen height
            return CGSize(width: collectionView.bounds.width, height: cardHeight)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            lastContentOffset = scrollView.contentOffset.y
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let screenHeight = UIScreen.main.bounds.height
            let cardHeight = screenHeight * 0.75
            let spacing = 10.0
            let fullCardHeight = cardHeight + spacing
            
            let adjustedOffset = targetContentOffset.pointee.y + scrollView.contentInset.top
            let scrollingDown = lastContentOffset < scrollView.contentOffset.y
            var targetIndex = round(adjustedOffset / fullCardHeight)
            
            if abs(velocity.y) > 0.5 {
                targetIndex = scrollingDown ? ceil(adjustedOffset / fullCardHeight) : floor(adjustedOffset / fullCardHeight)
            }
            
            targetIndex = max(0, min(targetIndex, CGFloat(parent.items.count + 1)))
            
            let finalOffset = (targetIndex * fullCardHeight) - scrollView.contentInset.top
            targetContentOffset.pointee = CGPoint(x: 0, y: finalOffset)
            
            // Adjust the currentIndex to account for the start card
            parent.currentIndex = Int(targetIndex) - 1
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // Update active state of visible cells
            guard let collectionView = scrollView as? UICollectionView else { return }
            
            let centerY = scrollView.bounds.midY + scrollView.contentOffset.y
            
            for cell in collectionView.visibleCells {
                // guard let indexPath = collectionView.indexPath(for: cell) else { continue }
                let cellCenter = cell.center.y + scrollView.contentOffset.y
                let distance = abs(centerY - cellCenter)
                
                // Update cell appearance based on distance from center
                let scale = 1 - (distance / scrollView.bounds.height * 0.2)
                cell.transform = CGAffineTransform(scaleX: scale, y: scale)
                cell.alpha = scale
            }
        }
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.parent = self
        uiView.reloadData()
    }
}

// UICollectionViewCell for checkpoints
class CheckpointCell: UICollectionViewCell {
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let detailsView = UIView()
    private let nameStackView = UIStackView()
    private let xpStackView = UIStackView()
    private let hintStackView = UIStackView()
    
    private let nameLabel = UILabel()
    private let nameValueLabel = UILabel()
    private let xpLabel = UILabel()
    private let xpValueLabel = UILabel()
    private let hintLabel = UILabel()
    private let hintValueLabel = UILabel()
    private let dividerLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container setup
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        // Image setup
        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Details view setup
        containerView.addSubview(detailsView)
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        detailsView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        
        // Setup stack views
        [nameStackView, xpStackView, hintStackView].forEach { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false
            detailsView.addSubview(stackView)
        }
        
        // Setup labels
        nameLabel.text = "Name"
        nameLabel.textColor = .black
        xpLabel.text = "XP"
        xpLabel.textColor = .black
        hintLabel.text = "Hint"
        hintLabel.textColor = .black
        
        [nameValueLabel, xpValueLabel, hintValueLabel].forEach { label in
            label.textColor = .black
        }
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameValueLabel)
        
        xpStackView.addArrangedSubview(xpLabel)
        xpStackView.addArrangedSubview(xpValueLabel)
        
        // Divider
        dividerLine.backgroundColor = .systemGray5
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        detailsView.addSubview(dividerLine)
        
        // Hint stack
        hintStackView.axis = .vertical
        hintStackView.alignment = .leading
        hintStackView.spacing = 8
        hintStackView.addArrangedSubview(hintLabel)
        hintStackView.addArrangedSubview(hintValueLabel)
        hintValueLabel.numberOfLines = 0
        
        // Layout constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6),
            
            detailsView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            detailsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            nameStackView.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 16),
            nameStackView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            nameStackView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            
            xpStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 16),
            xpStackView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            xpStackView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            
            dividerLine.topAnchor.constraint(equalTo: xpStackView.bottomAnchor, constant: 16),
            dividerLine.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            dividerLine.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            hintStackView.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 16),
            hintStackView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            hintStackView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            hintStackView.bottomAnchor.constraint(lessThanOrEqualTo: detailsView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with checkpoint: Checkpoint, xpReward: Int, isActive: Bool) {
        nameValueLabel.text = checkpoint.title
        xpValueLabel.text = "+\(xpReward) XP"
        hintValueLabel.text = checkpoint.desc
        
        if let image = UIImage(named: checkpoint.imageName) {
            imageView.image = image
        } else {
            imageView.backgroundColor = .systemGray4
            imageView.image = nil
        }
        
        // Apply active/inactive state
        alpha = isActive ? 1.0 : 0.8
        transform = isActive ? .identity : CGAffineTransform(scaleX: 0.95, y: 0.95)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = isActive ? 0.2 : 0.1
        layer.shadowRadius = isActive ? 5 : 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameValueLabel.text = nil
        xpValueLabel.text = nil
        hintValueLabel.text = nil
        transform = .identity
        alpha = 1.0
    }
}

// class HeaderView: UICollectionReusableView {
//     private let titleLabel = UILabel()
//     private let subtitleLabel = UILabel()
//     private let stackView = UIStackView()
    
//     override init(frame: CGRect) {
//         super.init(frame: frame)
//         setupUI()
//     }
    
//     required init?(coder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
//     }
    
//     private func setupUI() {
//         stackView.axis = .vertical
//         stackView.spacing = 8
//         stackView.alignment = .leading
//         stackView.translatesAutoresizingMaskIntoConstraints = false
//         addSubview(stackView)
        
//         titleLabel.text = "Start Here"
//         titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
//         subtitleLabel.text = "Find this checkpoint to kick off your Journey!"
//         subtitleLabel.font = .systemFont(ofSize: 14)
//         subtitleLabel.textColor = .systemBlue
        
//         stackView.addArrangedSubview(titleLabel)
//         stackView.addArrangedSubview(subtitleLabel)
        
//         NSLayoutConstraint.activate([
//             stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//             stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//             stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
//         ])
//     }
// }

// Add JourneyCompleteView
struct JourneyCompleteView: View {
    let journey: Journey
    let totalXP: Int
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToJourneyList = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Celebration Image/Icon
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.yellow)
                    .padding(.top, 40)
                
                // Congratulations Text
                Text("Journey Complete!")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                // XP Gained
                VStack(spacing: 8) {
                    Text("You've earned")
                        .font(.title2)
                    Text("+\(totalXP) XP")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                // Back to Journey List Button
                NavigationLink(destination: JourneyListView(), isActive: $navigateToJourneyList) {
                    HStack {
                        Text("Back to Journeys")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

// Modify JourneyProgressView to add complete button
struct JourneyProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var journey: Journey
    @Bindable var user: UserProfile
    
    @State private var currentIndex: Int? = 0
    @State private var showingCompleteView = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                // Vertical Progress Tracker
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        ForEach(0..<journey.checkpoints.count, id: \.self) { index in
                            VStack(spacing: 0) {
                                CheckpointProgressDot(
                                    isActive: index == (currentIndex ?? 0),
                                    isCompleted: index < (currentIndex ?? 0)
                                )
                                
                                if index < journey.checkpoints.count - 1 {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 2, height: 50)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(height: geometry.size.height * 0.5)
                
                // Main Content
                SnapScrollingCollectionView(
                    items: journey.checkpoints,
                    xpReward: journey.xpReward,
                    currentIndex: $currentIndex,
                    onComplete: completeJourney
                )
                .onChange(of: currentIndex) { oldValue, newValue in
                    if let newValue = newValue, let oldValue = oldValue, newValue > oldValue {
                        journey.completedCheckpoints = max(journey.completedCheckpoints, newValue)
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGray6).ignoresSafeArea())
            .fullScreenCover(isPresented: $showingCompleteView) {
                JourneyCompleteView(journey: journey, totalXP: journey.checkpoints.count * journey.xpReward)
            }
        }
    }
    
    private func completeJourney() {
        // Update user XP using the gainXP method
        journey.updateProgress(user: user)
        
        // Show completion view
        showingCompleteView = true
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
