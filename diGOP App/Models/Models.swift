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

@Model
class UserProfile{
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

@Model
class Journey{
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var completedCheckpoints: Int
    @Relationship var checkpoints: [Checkpoint] = []
    
    init(title: String, desc: String, completedCheckpoints: Int = 0, checkpoints: [Checkpoint] = []) {
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.completedCheckpoints = completedCheckpoints
        self.checkpoints = checkpoints
    }
    
    var progress: Double{
        guard !checkpoints.isEmpty else {return 0.0}
        return Double(completedCheckpoints) / Double(checkpoints.count)
    }
    
    var routeCoordinates: [CLLocationCoordinate2D]{
        checkpoints.map{$0.coordinate}
    }
}

@Model
class Checkpoint{
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var imageName: String
    var latitude: Double
    var longitude: Double
    
    init(title: String, desc: String, imageName: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.imageName = imageName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


