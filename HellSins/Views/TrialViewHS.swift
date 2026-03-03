import SwiftUI

struct TrialViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    struct ScenarioHS: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let sin: SinTypeHS
        let situation: String
        let imageName: String
    }

    let scenarios: [ScenarioHS] = [
        ScenarioHS(title: "The Late Reply", subtitle: "Read 3 days ago, no response", sin: .wrath,
                   situation: "Your close friend read your message 72 hours ago and hasn't replied. They've been active on social media. The silence feels deliberate. What do you do?",
                   imageName: "trial_wrath_test"),
        ScenarioHS(title: "Flash Sale", subtitle: "$800 item, now $200, 2 hrs left", sin: .greed,
                   situation: "You've had this wishlisted for a year. You don't urgently need it but the deal feels like now or never. Your card details are saved. One tap to purchase.",
                   imageName: "trial_greed_test"),
        ScenarioHS(title: "The Comparison Trap", subtitle: "Colleague got the promotion", sin: .envy,
                   situation: "You've worked side by side for 2 years. They get the promotion. Your boss says 'timing.' You feel the unfairness physically. What happens inside you next?",
                   imageName: "trial_envy_test"),
        ScenarioHS(title: "Midnight Craving", subtitle: "It's 1AM and the fridge is calling", sin: .gluttony,
                   situation: "You're stressed, slightly bored, and fully aware that eating right now is emotional not physical hunger. The urge feels overwhelming. What do you do?",
                   imageName: "trial_gluttony_test"),
        ScenarioHS(title: "The Shortcut", subtitle: "Half-effort vs. 3 more hours", sin: .sloth,
                   situation: "A report is due tomorrow. You can submit a half-effort version or work 3 more hours on something genuinely excellent. No one will likely notice the difference.",
                   imageName: "trial_sloth_test")
    ]

    @State private var scenarioIndex = 0
    @State private var sliderValue: Double = 0.5

    private var sliderIntValue: Int { Int((sliderValue * 9).rounded()) + 1 }
    private var sliderLabel: String {
        switch sliderIntValue {
        case 1...2: return "Complete surrender"
        case 3...4: return "Mostly give in"
        case 5...6: return "Mixed reaction"
        case 7...8: return "Mostly controlled"
        case 9...10: return "Full discipline"
        default: return ""
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CustomHeaderHS(title: "Trial", path: $path)
                scenarioSimulator
                sinMasteryGrid
                archiveSection
                Spacer(minLength: 120)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: — Scenario Simulator
    private var scenarioSimulator: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "theatermasks.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(vm.currentTheme.primaryColor)
                Text("SCENARIO SIMULATOR")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(vm.currentTheme.primaryColor)
                    .tracking(1.5)
                Spacer()
                Text("\(scenarioIndex + 1)/\(scenarios.count)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(scenarios.enumerated()), id: \.offset) { idx, scenario in
                        scenarioChip(scenario: scenario, isActive: idx == scenarioIndex)
                            .onTapGesture { withAnimation(.spring(response: 0.35)) { scenarioIndex = idx } }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }

            CustomCardHS {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: scenarios[scenarioIndex].sin.icon)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: scenarios[scenarioIndex].sin.color))
                        Text(scenarios[scenarioIndex].sin.rawValue.uppercased())
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(Color(hex: scenarios[scenarioIndex].sin.color))
                            .tracking(1)
                        Spacer()
                    }

                    Image(scenarios[scenarioIndex].imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .clipped()

                    Text(scenarios[scenarioIndex].situation)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(5)

                    VStack(spacing: 8) {
                        HStack {
                            Text("Your reaction:")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                            Spacer()
                            Text("\(sliderIntValue)/10 — \(sliderLabel)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(sliderColor)
                                .animation(.none, value: sliderIntValue)
                        }
                        Slider(value: $sliderValue, in: 0...1)
                            .tint(sliderColor)
                        HStack {
                            Text("Give in")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.3))
                            Spacer()
                            Text("Full control")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "#30D158"))
                        }
                    }

                    Button {
                        let score = Int(sliderValue * 100)
                        vm.completeSinTest(sin: scenarios[scenarioIndex].sin, score: score, total: 100)
                        withAnimation { scenarioIndex = (scenarioIndex + 1) % scenarios.count }
                        sliderValue = 0.5
                    } label: {
                        HStack {
                            Text("Submit Response")
                                .font(.system(size: 14, weight: .bold))
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 13)
                        .background(LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .environmentObject(vm)
        }
    }

    private var sliderColor: Color {
        switch sliderIntValue {
        case 1...3: return Color(hex: "#FF3B30")
        case 4...6: return Color(hex: "#FFD60A")
        default: return Color(hex: "#30D158")
        }
    }

    @ViewBuilder
    private func scenarioChip(scenario: ScenarioHS, isActive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: scenario.sin.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isActive ? Color(hex: scenario.sin.color) : .white.opacity(0.3))
                Spacer()
            }
            Text(scenario.title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isActive ? .white : .white.opacity(0.45))
                .lineLimit(1)
            Text(scenario.subtitle)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.3))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(width: 148, height: 108)
        .background(isActive ? vm.currentTheme.primaryColor.opacity(0.18) : Color.white.opacity(0.05))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(isActive ? vm.currentTheme.primaryColor.opacity(0.5) : Color.white.opacity(0.08), lineWidth: isActive ? 1.5 : 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: — Sin Mastery Grid
    private var sinMasteryGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SIN MASTERY")
                .font(.system(size: 9, weight: .black))
                .foregroundColor(.white.opacity(0.3))
                .tracking(1.5)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(vm.sins) { sin in
                    Button {
                        path.append(NavigationDestinationHS.sinDetail(sin.id))
                    } label: {
                        sinTile(sin: sin)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    @ViewBuilder
    private func sinTile(sin: SinModelHS) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: sin.id.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(hex: sin.id.color))
                Spacer()
                if sin.masteryLevel > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            Image(systemName: "flame.fill")
                                .font(.system(size: 8))
                                .foregroundColor(i < sin.masteryLevel ? Color(hex: "#FF6A00") : Color.white.opacity(0.1))
                        }
                    }
                } else {
                    Text("NEW")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(vm.currentTheme.primaryColor)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(vm.currentTheme.primaryColor.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            Text(sin.id.rawValue)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            Text(sin.id.tagline)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.white.opacity(0.4))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minHeight: 28, alignment: .top)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.08)).frame(height: 4)
                    RoundedRectangle(cornerRadius: 3).fill(Color(hex: sin.id.color)).frame(width: geo.size.width * sin.progress, height: 4)
                }
            }
            .frame(height: 4)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(Color.white.opacity(0.05))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: sin.id.color).opacity(0.2), lineWidth: 0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: — Archive
    private var archiveSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("VICTORY ARCHIVE")
                .font(.system(size: 9, weight: .black))
                .foregroundColor(.white.opacity(0.3))
                .tracking(1.5)

            let completed = vm.sins.filter { $0.masteryLevel > 0 }
            if completed.isEmpty {
                CustomCardHS {
                    HStack(spacing: 12) {
                        Image(systemName: "shield.slash")
                            .font(.system(size: 28)).foregroundColor(.white.opacity(0.15))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("No victories yet")
                                .font(.system(size: 14, weight: .semibold)).foregroundColor(.white.opacity(0.4))
                            Text("Complete scenarios above to build your psychological profile.")
                                .font(.system(size: 12)).foregroundColor(.white.opacity(0.3)).lineSpacing(3)
                        }
                    }
                }
                .environmentObject(vm)
            } else {
                ForEach(completed) { sin in
                    CustomCardHS {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle().fill(Color(hex: sin.id.color).opacity(0.2)).frame(width: 44, height: 44)
                                Image(systemName: sin.id.icon).font(.system(size: 18, weight: .semibold)).foregroundColor(Color(hex: sin.id.color))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sin.id.rawValue)
                                    .font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                                Text("Mastery Lvl \(sin.masteryLevel) · \(Int(sin.progress * 100))% control")
                                    .font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.4))
                            }
                            Spacer()
                            Image(systemName: "shield.fill").font(.system(size: 16)).foregroundColor(Color(hex: "#FFD60A"))
                        }
                    }
                    .environmentObject(vm)
                }
            }
        }
    }
}



#Preview {
    ZStack {
        InfernoBackgroundHS()
        TrialViewHS(path: .constant(NavigationPath()))
    }
    .environmentObject(ViewModelHS())
}
