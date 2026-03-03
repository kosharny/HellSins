import Foundation

struct HabitModelHS: Identifiable, Codable {
    var id: UUID
    var name: String
    var sinCategory: SinTypeHS
    var streak: Int
    var isCompletedToday: Bool
    var countdownSeconds: Int
    var lastCompletedDate: Date?

    init(id: UUID = UUID(), name: String, sinCategory: SinTypeHS, streak: Int = 0, isCompletedToday: Bool = false, countdownSeconds: Int = 3600) {
        self.id = id
        self.name = name
        self.sinCategory = sinCategory
        self.streak = streak
        self.isCompletedToday = isCompletedToday
        self.countdownSeconds = countdownSeconds
        self.lastCompletedDate = nil
    }

    static var defaults: [HabitModelHS] {
        [
            HabitModelHS(name: "No social media for 2 hours", sinCategory: .sloth, countdownSeconds: 7200),
            HabitModelHS(name: "Cold shower", sinCategory: .sloth, countdownSeconds: 300),
            HabitModelHS(name: "Spend within budget", sinCategory: .greed, countdownSeconds: 86400),
            HabitModelHS(name: "15 min meditation", sinCategory: .wrath, countdownSeconds: 900),
            HabitModelHS(name: "Gratitude journal entry", sinCategory: .envy, countdownSeconds: 600),
            HabitModelHS(name: "No junk food today", sinCategory: .gluttony, countdownSeconds: 86400),
            HabitModelHS(name: "Compliment someone", sinCategory: .pride, countdownSeconds: 86400),
            HabitModelHS(name: "Read for 20 minutes", sinCategory: .sloth, countdownSeconds: 1200),
            HabitModelHS(name: "Delay one craving by 10 min", sinCategory: .lust, countdownSeconds: 600)
        ]
    }
}
