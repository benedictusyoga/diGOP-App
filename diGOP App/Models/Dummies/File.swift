extension Journey {
    static var sampleJourneys: [Journey] {
        return [
            Journey(
                title: "GOP 9",
                desc: "Office Space",
                completedCheckpoints: 2,
                checkpoints: Checkpoint.sampleCheckpoints
            ),
            Journey(
                title: "The Breeze",
                desc: "Shopping Center",
                completedCheckpoints: 3,
                checkpoints: Checkpoint.sampleCheckpoints
            ),
            Journey(
                title: "BSD Plaza",
                desc: "Community Hub",
                completedCheckpoints: 1,
                checkpoints: Checkpoint.sampleCheckpoints
            )
        ]
    }
}

extension Checkpoint {
    static var sampleCheckpoints: [Checkpoint] {
        return [
            Checkpoint(
                title: "Main Entrance",
                desc: "Start your journey here!",
                imageName: "checkpoint1",
                latitude: -6.3026,
                longitude: 106.6527
            ),
            Checkpoint(
                title: "Lobby",
                desc: "Main lobby area.",
                imageName: "checkpoint2",
                latitude: -6.3025,
                longitude: 106.6528
            ),
            Checkpoint(
                title: "Meeting Room",
                desc: "The central meeting spot.",
                imageName: "checkpoint3",
                latitude: -6.3024,
                longitude: 106.6529
            ),
            Checkpoint(
                title: "Rooftop Garden",
                desc: "Beautiful garden with a view.",
                imageName: "checkpoint4",
                latitude: -6.3023,
                longitude: 106.6530
            ),
            Checkpoint(
                title: "Cafe",
                desc: "Relax and unwind here.",
                imageName: "checkpoint5",
                latitude: -6.3022,
                longitude: 106.6531
            )
        ]
    }
}
