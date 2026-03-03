import Foundation

struct MissionModelHS: Identifiable, Codable {
    var id: UUID
    var title: String
    var timeRemainingSeconds: Int
    var isCheckedIn: Bool

    init(id: UUID = UUID(), title: String, timeRemainingSeconds: Int = 7200, isCheckedIn: Bool = false) {
        self.id = id
        self.title = title
        self.timeRemainingSeconds = timeRemainingSeconds
        self.isCheckedIn = isCheckedIn
    }

    var timeRemainingText: String {
        let hours = timeRemainingSeconds / 3600
        let minutes = (timeRemainingSeconds % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m left"
        }
        return "\(minutes) min left"
    }

    static var defaultMission: MissionModelHS {
        MissionModelHS(title: "2 hours without social media", timeRemainingSeconds: 7200)
    }
}
