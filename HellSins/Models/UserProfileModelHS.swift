import Foundation

struct UserProfileHS: Codable {
    var streakDays: Int
    var energy: Double
    var dailyPurificationPct: Double
    var globalScore: Int
    var sinLevels: [String: Double]
    var onboardingDone: Bool
    var selectedTheme: AppThemeHS

    init() {
        streakDays = 0
        energy = 0.6
        dailyPurificationPct = 0.0
        globalScore = 0
        sinLevels = Dictionary(uniqueKeysWithValues: SinTypeHS.allCases.map { ($0.rawValue, Double.random(in: 0.1...0.8)) })
        onboardingDone = false
        selectedTheme = .ember
    }

    var dominantSin: SinTypeHS? {
        guard let topEntry = sinLevels.max(by: { $0.value < $1.value }) else { return nil }
        return SinTypeHS(rawValue: topEntry.key)
    }

    var radarValues: [Double] {
        SinTypeHS.allCases.map { sinLevels[$0.rawValue] ?? 0.0 }
    }
}

struct DailyActivityHS: Codable {
    var date: Date
    var score: Int
    var habitsCompleted: Int
}
