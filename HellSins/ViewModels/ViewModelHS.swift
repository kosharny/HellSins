import Foundation
import Combine
import SwiftUI

class ViewModelHS: ObservableObject {

    @Published var profile: UserProfileHS
    @Published var habits: [HabitModelHS]
    @Published var currentMission: MissionModelHS
    @Published var libraryEntries: [LibraryEntryHS]
    @Published var sins: [SinModelHS]
    @Published var dailyActivity: [DailyActivityHS]
    @Published var purchasedThemes: Set<String>
    @Published var premiumEnabled: Bool = false
    @Published var selectedTab: Int = 0
    @Published var navigateTo: NavigationDestinationHS? = nil
    @Published var activeTestSin: SinTypeHS? = nil
    @Published var searchQuery: String = ""
    @Published var showSOS: Bool = false

    private var cancellables = Set<AnyCancellable>()


    private let profileKey = "hellsins.profile"
    private let habitsKey = "hellsins.habits"
    private let missionKey = "hellsins.mission"
    private let sinsKey = "hellsins.sins"
    private let purchasesKey = "hellsins.purchases"
    private let activityKey = "hellsins.activity"

    private var energyTimer: Timer?
    private var missionTimer: Timer?

    init() {
        profile = UserProfileHS()
        habits = HabitModelHS.defaults
        currentMission = MissionModelHS.defaultMission
        libraryEntries = LibraryEntryHS.library
        sins = SinTypeHS.allCases.map { SinModelHS(id: $0, masteryLevel: 0, progress: Double.random(in: 0.0...0.5)) }
        dailyActivity = []
        purchasedThemes = []
        loadAll()
        startEnergyRegeneration()
        startMissionCountdown()
        subscribeToStore()
    }

    private func subscribeToStore() {
        StoreManagerHS.shared.$purchasedProductIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] purchasedIDs in
                guard let self = self else { return }
                self.premiumEnabled = !purchasedIDs.isEmpty
                self.purchasedThemes = purchasedIDs
                let resolved = ViewModelHS.resolveTheme(profile: self.profile, purchasedIDs: purchasedIDs)
                if self.profile.selectedTheme != resolved {
                    self.profile.selectedTheme = resolved
                    self.saveAll()
                }
            }
            .store(in: &cancellables)
    }

    func selectTheme(_ theme: AppThemeHS) {
        if theme.isPremium && !StoreManagerHS.shared.hasAccess(to: theme) { return }
        profile.selectedTheme = theme
        saveAll()
    }

    static func resolveTheme(profile: UserProfileHS, purchasedIDs: Set<String>) -> AppThemeHS {
        let theme = profile.selectedTheme
        if theme.isPremium && !purchasedIDs.contains(theme.productID) {
            return .ember
        }
        return theme
    }


    var filteredLibrary: [LibraryEntryHS] {
        if searchQuery.isEmpty { return libraryEntries }
        return libraryEntries.filter {
            $0.feeling.localizedCaseInsensitiveContains(searchQuery) ||
            $0.title.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    var favoriteEntries: [LibraryEntryHS] {
        libraryEntries.filter { $0.isFavorite }
    }


    var currentTheme: AppThemeHS {
        profile.selectedTheme
    }

    func selectTab(_ index: Int) {
        selectedTab = index
    }

    func toggleHabitCompletion(_ habit: HabitModelHS) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].isCompletedToday.toggle()
        if habits[index].isCompletedToday {
            habits[index].streak += 1
            habits[index].lastCompletedDate = Date()
            profile.dailyPurificationPct = min(1.0, profile.dailyPurificationPct + 0.1)
            profile.globalScore += 10
        } else {
            habits[index].streak = max(0, habits[index].streak - 1)
            profile.dailyPurificationPct = max(0.0, profile.dailyPurificationPct - 0.1)
            profile.globalScore = max(0, profile.globalScore - 10)
        }
        saveAll()
    }

    func checkInMission() {
        currentMission.isCheckedIn = true
        profile.globalScore += 25
        profile.dailyPurificationPct = min(1.0, profile.dailyPurificationPct + 0.2)
        saveAll()
    }

    func completeSinTest(sin: SinTypeHS, score: Int, total: Int) {
        guard let index = sins.firstIndex(where: { $0.id == sin }) else { return }
        let ratio = Double(score) / Double(total)
        sins[index].progress = ratio
        sins[index].masteryLevel = min(5, sins[index].masteryLevel + 1)
        let sinKey = sin.rawValue
        profile.sinLevels[sinKey] = max(0.0, (profile.sinLevels[sinKey] ?? 0.5) - ratio * 0.2)
        profile.globalScore += score * 5
        saveAll()
    }

    func toggleFavorite(_ entry: LibraryEntryHS) {
        guard let index = libraryEntries.firstIndex(where: { $0.id == entry.id }) else { return }
        libraryEntries[index].isFavorite.toggle()
        saveAll()
    }

    func setTheme(_ theme: AppThemeHS) {
        profile.selectedTheme = theme
        saveAll()
    }

    func unlockTheme(productID: String) {
        purchasedThemes.insert(productID)
        if let theme = AppThemeHS.allCases.first(where: { $0.productID == productID }) {
            profile.selectedTheme = theme
        }
        saveAll()
    }

    func isThemePurchased(_ theme: AppThemeHS) -> Bool {
        if !theme.isPremium { return true }
        return purchasedThemes.contains(theme.productID)
    }

    func incrementStreak() {
        profile.streakDays += 1
        saveAll()
    }

    func recordDailyActivity() {
        let today = Calendar.current.startOfDay(for: Date())
        if let existing = dailyActivity.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyActivity[existing].score = profile.globalScore
            dailyActivity[existing].habitsCompleted = habits.filter { $0.isCompletedToday }.count
        } else {
            dailyActivity.append(DailyActivityHS(date: today, score: profile.globalScore, habitsCompleted: habits.filter { $0.isCompletedToday }.count))
        }
        saveAll()
    }

    func activityScore(for date: Date) -> Int {
        dailyActivity.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.score ?? 0
    }

    var predictionText: String {
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        if weekday == 6 || weekday == 7 {
            return "You usually relapse on weekends. Prepare a defense plan."
        }
        if let dom = profile.dominantSin {
            return "\(dom.rawValue) is peaking this week. Stay disciplined and aware."
        }
        return "Consistent patterns detected. Keep your guard up."
    }

    var radarInsightText: String {
        guard let dom = profile.dominantSin else { return "All sins balanced. Stay vigilant." }
        return "\(dom.rawValue) is peaking today. Stay aware."
    }

    private var dayIndex: Int {
        let cal = Calendar.current
        let comps = cal.dateComponents([.month, .day], from: Date())
        return ((comps.month ?? 1) - 1) * 31 + ((comps.day ?? 1) - 1)
    }

    var psychFact: String {
        let facts = [
            "Habits form in 18–254 days, not 21. Consistency matters more than speed.",
            "The brain rewards itself for planning future rewards — use this to your advantage.",
            "Self-control is like a muscle: it fatigues with use but grows with training.",
            "Anger lasts 90 seconds biologically. What extends it is your own thoughts.",
            "People who write down temptations are 3x more likely to resist them.",
            "The dopamine hit from anticipation is stronger than from receiving. This is why ads work.",
            "Cold exposure for 30 seconds raises norepinephrine by 300% — a real discipline hack.",
            "Ego depletion: the more decisions you make, the worse your self-control becomes by day's end.",
            "Sleep deprivation increases impulsive choices by 40%. Protect your sleep.",
            "The 'fresh start effect': new weeks, months, and birthdays are proven trigger points for change."
        ]
        return facts[dayIndex % facts.count]
    }

    var miniChallenge: String {
        let challenges = [
            "Go 30 minutes without checking your phone.",
            "Write 3 things you are grateful for right now.",
            "Do 10 deep breaths before your next meal.",
            "Message someone you haven't spoken to in 30 days.",
            "Spend 5 minutes in complete silence.",
            "Drink only water for the rest of today.",
            "Do not criticize anyone — including yourself — for the next 3 hours.",
            "Walk somewhere you'd normally drive or take transport.",
            "Read one page of a non-fiction book before bed tonight.",
            "Close all social media tabs for the next 2 hours."
        ]
        return challenges[dayIndex % challenges.count]
    }

    var friendActivityFeed: [String] {
        [
            "Alex just beat Gluttony — 10 days without fast food 🔥",
            "Maria scored 94% control on the Flash Sale scenario",
            "Daniel checked in his morning discipline habit",
            "Sam completed the Anger Diffusion Audio track",
            "Chris is on a 7-day clean streak 🏆"
        ]
    }


    private func startEnergyRegeneration() {
        energyTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.profile.energy = min(1.0, self.profile.energy + 0.01)
                self.saveAll()
            }
        }
    }

    private func startMissionCountdown() {
        missionTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.currentMission.timeRemainingSeconds > 0 {
                    self.currentMission.timeRemainingSeconds -= 60
                }
            }
        }
    }

    func saveAll() {
        if let d = try? JSONEncoder().encode(profile) { UserDefaults.standard.set(d, forKey: profileKey) }
        if let d = try? JSONEncoder().encode(habits) { UserDefaults.standard.set(d, forKey: habitsKey) }
        if let d = try? JSONEncoder().encode(currentMission) { UserDefaults.standard.set(d, forKey: missionKey) }
        if let d = try? JSONEncoder().encode(sins) { UserDefaults.standard.set(d, forKey: sinsKey) }
        if let d = try? JSONEncoder().encode(Array(purchasedThemes)) { UserDefaults.standard.set(d, forKey: purchasesKey) }
        if let d = try? JSONEncoder().encode(dailyActivity) { UserDefaults.standard.set(d, forKey: activityKey) }
    }

    private func loadAll() {
        if let d = UserDefaults.standard.data(forKey: profileKey), let p = try? JSONDecoder().decode(UserProfileHS.self, from: d) {
            profile = p
        }
        if let d = UserDefaults.standard.data(forKey: habitsKey), let h = try? JSONDecoder().decode([HabitModelHS].self, from: d) {
            habits = h
        }
        if let d = UserDefaults.standard.data(forKey: missionKey), let m = try? JSONDecoder().decode(MissionModelHS.self, from: d) {
            currentMission = m
        }
        if let d = UserDefaults.standard.data(forKey: sinsKey), let s = try? JSONDecoder().decode([SinModelHS].self, from: d) {
            sins = s
        }
        if let d = UserDefaults.standard.data(forKey: purchasesKey), let pt = try? JSONDecoder().decode([String].self, from: d) {
            purchasedThemes = Set(pt)
        }
        if let d = UserDefaults.standard.data(forKey: activityKey), let a = try? JSONDecoder().decode([DailyActivityHS].self, from: d) {
            dailyActivity = a
        }
    }
}

enum NavigationDestinationHS: Hashable {
    case settings
    case sinDetail(SinTypeHS)
    case grounding
    case breathing
    case coldShock
    case paywall(String)
    case webView(String)
    case about
    case libraryDetail(UUID)
}


