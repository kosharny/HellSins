import SwiftUI
import Combine

struct PenanceViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath
    @State private var selectedDayIndex: Int = 0
    @State private var now = Date()
    private let ticker = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var weekDays: [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let weekday = cal.component(.weekday, from: today)
        let mondayOffset = (weekday == 1 ? -6 : 2 - weekday)
        return (0..<7).compactMap { cal.date(byAdding: .day, value: mondayOffset + $0, to: today) }
    }

    private var dayLabels: [String] { ["M", "T", "W", "T", "F", "S", "S"] }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CustomHeaderHS(title: "Penance", path: $path)
                disciplineHeader
                weekCalendar
                todayProgressCard
                habitsSection
                Spacer(minLength: 120)
            }
            .padding(.horizontal, 20)
        }
        .onReceive(ticker) { t in now = t }
        .onAppear {
            let weekday = Calendar.current.component(.weekday, from: Date())
            selectedDayIndex = (weekday + 5) % 7
        }
    }

    // MARK: — Discipline Header Quote
    private var disciplineHeader: some View {
        CustomCardHS(glow: true) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .top, endPoint: .bottom))
                    Text("DAILY DISCIPLINE")
                        .font(.system(size: 9, weight: .black)).foregroundColor(vm.currentTheme.primaryColor).tracking(1.5)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill").font(.system(size: 11)).foregroundColor(Color(hex: "#FF6A00"))
                        Text("\(vm.profile.streakDays)d streak")
                            .font(.system(size: 11, weight: .bold)).foregroundColor(Color(hex: "#FF6A00"))
                    }
                }
                Text("\"We are what we repeatedly do. Discipline is not a personality trait — it is a behavioral habit.\"")
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(4)
                    .italic()
                Text("— Aristotle")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.35))
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Week Calendar
    private var weekCalendar: some View {
        CustomCardHS {
            VStack(spacing: 14) {
                HStack {
                    Text("THIS WEEK")
                        .font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.3)).tracking(1.5)
                    Spacer()
                    let completedDays = weekDays.filter { vm.activityScore(for: $0) > 0 }.count
                    Text("\(completedDays)/7 active days")
                        .font(.system(size: 11, weight: .semibold)).foregroundColor(vm.currentTheme.primaryColor)
                }

                HStack(spacing: 4) {
                    ForEach(Array(weekDays.enumerated()), id: \.offset) { idx, day in
                        let isToday = Calendar.current.isDateInToday(day)
                        let isSelected = idx == selectedDayIndex
                        let score = vm.activityScore(for: day)

                        Button { selectedDayIndex = idx } label: {
                            VStack(spacing: 6) {
                                Text(dayLabels[idx])
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(isSelected ? .white : .white.opacity(0.3))

                                ZStack {
                                    Circle()
                                        .fill(isSelected
                                              ? vm.currentTheme.primaryColor
                                              : (score > 0 ? Color(hex: "#FF6A00").opacity(0.25) : Color.white.opacity(0.06)))
                                        .frame(width: 36, height: 36)

                                    if score > 0 && !isSelected {
                                        Image(systemName: "flame.fill")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "#FF6A00"))
                                    } else {
                                        Text("\(Calendar.current.component(.day, from: day))")
                                            .font(.system(size: 13, weight: isToday ? .black : .medium))
                                            .foregroundColor(isSelected ? .white : (isToday ? .white : .white.opacity(0.45)))
                                    }
                                }

                                if isToday {
                                    Circle().fill(vm.currentTheme.primaryColor).frame(width: 4, height: 4)
                                } else {
                                    Circle().fill(Color.clear).frame(width: 4, height: 4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Today Progress
    private var todayProgressCard: some View {
        let done = vm.habits.filter { $0.isCompletedToday }.count
        let total = max(1, vm.habits.count)
        let pct = Double(done) / Double(total)

        return CustomCardHS {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TODAY'S PROGRESS")
                            .font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.3)).tracking(1.5)
                        Text("\(done) of \(total) habits complete")
                            .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                    }
                    Spacer()
                    ZStack {
                        Circle().stroke(Color.white.opacity(0.06), lineWidth: 6).frame(width: 56, height: 56)
                        Circle()
                            .trim(from: 0, to: pct)
                            .stroke(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#30D158")], startPoint: .leading, endPoint: .trailing),
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 56, height: 56)
                        Text("\(Int(pct * 100))%")
                            .font(.system(size: 12, weight: .black)).foregroundColor(.white)
                    }
                }
                CustomProgressBarHS(value: pct)
                    .environmentObject(vm)
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Habits by Sin
    private var habitsSection: some View {
        VStack(spacing: 18) {
            ForEach(SinTypeHS.allCases) { sinType in
                let habits = vm.habits.filter { $0.sinCategory == sinType }
                if !habits.isEmpty {
                    sinGroup(sinType: sinType, habits: habits)
                }
            }
        }
    }

    @ViewBuilder
    private func sinGroup(sinType: SinTypeHS, habits: [HabitModelHS]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                ZStack {
                    Capsule().fill(Color(hex: sinType.color).opacity(0.15)).frame(height: 24)
                    HStack(spacing: 5) {
                        Image(systemName: sinType.icon).font(.system(size: 10, weight: .bold)).foregroundColor(Color(hex: sinType.color))
                        Text(sinType.rawValue.uppercased()).font(.system(size: 9, weight: .black)).foregroundColor(Color(hex: sinType.color)).tracking(1)
                    }
                    .padding(.horizontal, 10)
                }
                Spacer()
                Text("\(habits.filter { $0.isCompletedToday }.count)/\(habits.count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: sinType.color))
            }

            ForEach(habits) { habit in
                habitCard(habit: habit, sinColor: Color(hex: sinType.color))
            }
        }
    }

    @ViewBuilder
    private func habitCard(habit: HabitModelHS, sinColor: Color) -> some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(habit.isCompletedToday ? Color(hex: "#30D158") : sinColor.opacity(0.6))
                .frame(width: 4)
                .padding(.vertical, 0)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) { vm.toggleHabitCompletion(habit) }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(habit.isCompletedToday ? Color(hex: "#30D158").opacity(0.2) : Color.white.opacity(0.05))
                                .frame(width: 32, height: 32)
                            if habit.isCompletedToday {
                                Image(systemName: "checkmark").font(.system(size: 13, weight: .bold)).foregroundColor(Color(hex: "#30D158"))
                            } else {
                                Circle().stroke(Color.white.opacity(0.25), lineWidth: 1.5).frame(width: 20, height: 20)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    VStack(alignment: .leading, spacing: 3) {
                        Text(habit.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(habit.isCompletedToday ? Color(hex: "#30D158") : .white)
                            .strikethrough(habit.isCompletedToday, color: Color(hex: "#30D158"))
                        if habit.streak > 0 {
                            Label("\(habit.streak) day streak", systemImage: "flame.fill")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Color(hex: "#FF6A00"))
                        }
                    }
                    Spacer()
                    if habit.isCompletedToday {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .top, endPoint: .bottom))
                            .shadow(color: Color(hex: "#FF6A00").opacity(0.6), radius: 6)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                if !habit.isCompletedToday && habit.countdownSeconds > 0 {
                    timerPill(habit: habit)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .background(Color.white.opacity(habit.isCompletedToday ? 0.07 : 0.04))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(habit.isCompletedToday ? Color(hex: "#30D158").opacity(0.3) : Color.white.opacity(0.06), lineWidth: 0.8))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private func timerPill(habit: HabitModelHS) -> some View {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let elapsed = Int(now.timeIntervalSince(startOfDay))
        let remaining = max(0, habit.countdownSeconds - elapsed)
        let hh = remaining / 3600
        let mm = (remaining % 3600) / 60
        let label = remaining > 0 ? (hh > 0 ? "\(hh)h \(mm)m until window closes" : "\(mm)m until window closes") : "Window expired"
        let color: Color = remaining > 3600 ? Color(hex: "#FFD60A") : remaining > 0 ? Color(hex: "#FF6A00") : Color(hex: "#FF3B30")

        HStack(spacing: 6) {
            Image(systemName: remaining > 0 ? "timer" : "xmark.circle.fill")
                .font(.system(size: 10)).foregroundColor(color)
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(color)
        }
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
}

#Preview {
    ZStack {
        InfernoBackgroundHS()
        PenanceViewHS(path: .constant(NavigationPath()))
    }
    .environmentObject(ViewModelHS())
}
