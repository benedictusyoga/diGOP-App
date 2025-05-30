extension Journey {
    static var sampleJourneys: [Journey] {
        return [
            Journey(
                title: "GOP 9",
                desc: "Office Space",
                checkpoints: Checkpoint.gopCheckpoints
            ),
            Journey(
                title: "The Breeze",
                desc: "Shopping Center",
                checkpoints: Checkpoint.breezeCheckpoints
            ),
            Journey(
                title: "BSD Plaza",
                desc: "Community Hub",
                checkpoints: Checkpoint.bsdPlazaCheckpoints
            ),
            Journey(
                title: "AEON Mall",
                desc: "Retail & Dining",
                checkpoints: Checkpoint.aeonMallCheckpoints
            ),
            Journey(
                title: "Green Office Park",
                desc: "Eco-friendly Business Hub",
                checkpoints: Checkpoint.greenOfficeCheckpoints
            )
        ]
    }
}

extension Checkpoint {
    static var gopCheckpoints: [Checkpoint] {
        return [
            Checkpoint(title: "Main Lobby", desc: "Entry point of GOP 9.", imageName: "Checkpoint1", latitude: -6.3026, longitude: 106.6527),
            Checkpoint(title: "Conference Hall", desc: "Big meeting space.", imageName: "Checkpoint2", latitude: -6.3025, longitude: 106.6528),
            Checkpoint(title: "Rooftop Garden", desc: "Relaxing green space.", imageName: "Checkpoint3", latitude: -6.3024, longitude: 106.6529),
            Checkpoint(title: "Executive Office", desc: "Where decisions are made.", imageName: "Checkpoint4", latitude: -6.3023, longitude: 106.6530),
            Checkpoint(title: "Innovation Lab", desc: "Creative workspace for ideas.", imageName: "Checkpoint5", latitude: -6.3022, longitude: 106.6531),
            Checkpoint(title: "Cafeteria", desc: "Grab a coffee and recharge.", imageName: "Checkpoint6", latitude: -6.3021, longitude: 106.6532),
            Checkpoint(title: "Meeting Room", desc: "Collaborative space for teams.", imageName: "Checkpoint7", latitude: -6.3020, longitude: 106.6533),
            Checkpoint(title: "Lounge Area", desc: "Relax and network with colleagues.", imageName: "Checkpoint8", latitude: -6.3019, longitude: 106.6534),
            Checkpoint(title: "Fitness Center", desc: "Stay healthy and active.", imageName: "Checkpoint9", latitude: -6.3018, longitude: 106.6535),
            Checkpoint(title: "Parking Area", desc: "Convenient access to your vehicle.", imageName: "Checkpoint10", latitude: -6.3017, longitude: 106.6536),
            Checkpoint(title: "Security Desk", desc: "Ensuring safety for everyone.", imageName: "Checkpoint11", latitude: -6.3016, longitude: 106.6537)
        ]
    }

    static var breezeCheckpoints: [Checkpoint] {
        return [
            Checkpoint(title: "Main Entrance", desc: "Start your shopping journey.", imageName: "breeze1", latitude: -6.3022, longitude: 106.6540),
            Checkpoint(title: "Food Court", desc: "Enjoy a variety of cuisines.", imageName: "breeze2", latitude: -6.3021, longitude: 106.6541),
            Checkpoint(title: "Open Plaza", desc: "Outdoor seating and events.", imageName: "breeze3", latitude: -6.3020, longitude: 106.6542)
        ]
    }

    static var bsdPlazaCheckpoints: [Checkpoint] {
        return [
            Checkpoint(title: "Community Hub", desc: "Coworking & gathering space.", imageName: "bsd1", latitude: -6.3015, longitude: 106.6535),
            Checkpoint(title: "Library", desc: "Read and relax.", imageName: "bsd2", latitude: -6.3014, longitude: 106.6536),
            Checkpoint(title: "Event Hall", desc: "Hosting public events.", imageName: "bsd3", latitude: -6.3013, longitude: 106.6537)
        ]
    }

    static var aeonMallCheckpoints: [Checkpoint] {
        return [
            Checkpoint(title: "Main Entrance", desc: "Entry point of AEON Mall.", imageName: "aeon1", latitude: -6.3010, longitude: 106.6550),
            Checkpoint(title: "Cinema", desc: "Watch the latest movies.", imageName: "aeon2", latitude: -6.3009, longitude: 106.6551),
            Checkpoint(title: "Supermarket", desc: "Find fresh groceries.", imageName: "aeon3", latitude: -6.3008, longitude: 106.6552),
            Checkpoint(title: "Kids Zone", desc: "Fun place for kids.", imageName: "aeon4", latitude: -6.3007, longitude: 106.6553)
        ]
    }

    static var greenOfficeCheckpoints: [Checkpoint] {
        return [
            Checkpoint(title: "Reception", desc: "Welcome area.", imageName: "green1", latitude: -6.3005, longitude: 106.6560),
            Checkpoint(title: "Garden Walk", desc: "Enjoy the nature path.", imageName: "green2", latitude: -6.3004, longitude: 106.6561),
            Checkpoint(title: "Bike Parking", desc: "Eco-friendly transport.", imageName: "green3", latitude: -6.3003, longitude: 106.6562)
        ]
    }
}
