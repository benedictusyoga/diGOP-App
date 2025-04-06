//
//  Models.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

enum Rank: String, CaseIterable, Codable {
    case novice
    case explorer
    case adventurer
    case master
    case legend
    
    var minXP: Int {
        switch self {
        case .novice: return 0
        case .explorer: return 100
        case .adventurer: return 250
        case .master: return 500
        case .legend: return 1000
        }
    }
    
    var requiredXP: Int {
        guard let nextXP = nextRankMinXP else {
            return 0 // Legend has no progression
        }
        return nextXP - minXP
    }
    
    var nextRankMinXP: Int? {
        let allRanks = Rank.allCases
        guard let currentIndex = allRanks.firstIndex(of: self),
              currentIndex + 1 < allRanks.count else {
            return nil // No next rank for legend
        }
        return allRanks[currentIndex + 1].minXP
    }
    
    var avatarImageName: String {
        switch self {
        case .novice: return "avatar_novice"
        case .explorer: return "avatar_explorer"
        case .adventurer: return "avatar_adventurer"
        case .master: return "avatar_master"
        case .legend: return "avatar_legend"
        }
    }
    
    var nextRank: Rank? {
        let all = Rank.allCases
        guard let currentIndex = all.firstIndex(of: self),
              currentIndex < all.count - 1 else { return nil }
        return all[currentIndex + 1]
    }
    
    static func rank(for xp: Int) -> Rank {
        return Self.allCases.reversed().first { xp >= $0.minXP } ?? .novice
    }
}



@Model
class UserProfile {
    @Attribute var name: String
    @Attribute var experiencePoints: Int
    @Attribute var totalXP: Int
    
    init(name: String, totalXP: Int = 0, experiencePoints: Int = 0) {
        self.name = name
        self.totalXP = totalXP
        self.experiencePoints = experiencePoints
    }
    
    /// Dynamically computed rank — no persistence!
    var rank: Rank {
        Rank.rank(for: totalXP)
    }
    
    /// Associated avatar name
    var avatarName: String {
        rank.avatarImageName
    }
    
    /// XP progression logic
    func gainXP(_ points: Int) {
        totalXP += points
        var remainingXP = experiencePoints + points
        
        var currentRank = rank
        var nextRank = currentRank.nextRank
        
        while let next = nextRank,
              remainingXP >= currentRank.requiredXP {
            remainingXP -= currentRank.requiredXP
            currentRank = next
            nextRank = currentRank.nextRank
        }
        
        experiencePoints = remainingXP
    }
}



@Model
class Journey: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var completedCheckpoints: Int
    var xpReward: Int
    var isCompleted: Bool = false
    
    @Relationship var checkpoints: [Checkpoint] = []
    
    init(title: String, desc: String, completedCheckpoints: Int = 0, checkpoints: [Checkpoint] = []) {
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.completedCheckpoints = completedCheckpoints
        self.checkpoints = checkpoints
        self.xpReward = checkpoints.count * 10  // 10 XP per checkpoint
    }
    
    
    var progress: Double {
        guard !checkpoints.isEmpty else { return 0.0 }
        return Double(completedCheckpoints) / Double(checkpoints.count)
    }
    
    var routeCoordinates: [CLLocationCoordinate2D] {
        checkpoints.map { $0.coordinate }
    }
    
    func updateProgress(user: UserProfile) {
        self.completedCheckpoints = checkpoints.count
        if !isCompleted {
            isCompleted = true
            user.gainXP(xpReward)
        }
    }
}



@Model
class Checkpoint {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var imageName: String
    var latitude: Double
    var longitude: Double
    var isCompleted: Bool  // ✅ NEW PROPERTY
    
    init(title: String, desc: String, imageName: String, latitude: Double, longitude: Double, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.imageName = imageName
        self.latitude = latitude
        self.longitude = longitude
        self.isCompleted = isCompleted
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}



