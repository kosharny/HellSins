import SwiftUI

struct JudgementViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CustomHeaderHS(title: "Judgement", path: $path)
                personalStatsBlock
                statsGrid
                heatmapSection
                aiPredictionBlock
                sinBreakdown
                Spacer(minLength: 120)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: — Personal Stats (replaces global score)
    private var personalStatsBlock: some View {
        CustomCardHS(glow: true) {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 11, weight: .bold)).foregroundColor(vm.currentTheme.primaryColor)
                    Text("YOUR PROFILE")
                        .font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.4)).tracking(1.5)
                    Spacer()
                    rankBadge
                }

                HStack(spacing: 16) {
                    ZStack {
                        Circle().stroke(Color.white.opacity(0.05), lineWidth: 12).frame(width: 120, height: 120)
                        Circle()
                            .trim(from: 0, to: min(CGFloat(vm.profile.globalScore) / 1000.0, 1.0))
                            .stroke(
                                LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor, Color(hex: "#FFD60A")], startPoint: .leading, endPoint: .trailing),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 120, height: 120)
                            .animation(.spring(response: 0.8, dampingFraction: 0.75), value: vm.profile.globalScore)
                        VStack(spacing: 2) {
                            Text("\(vm.profile.globalScore)")
                                .font(.system(size: 28, weight: .black, design: .rounded)).foregroundColor(.white)
                            Text("pts").font(.system(size: 10, weight: .semibold)).foregroundColor(.white.opacity(0.4))
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        statLine(icon: "flame.fill", color: Color(hex: "#FF6A00"), label: "Streak", value: "\(vm.profile.streakDays) days")
                        statLine(icon: "checkmark.circle.fill", color: Color(hex: "#30D158"), label: "Habits done", value: "\(vm.habits.filter { $0.isCompletedToday }.count)/\(vm.habits.count)")
                        statLine(icon: "shield.fill", color: Color(hex: "#FFD60A"), label: "Sins tested", value: "\(vm.sins.filter { $0.masteryLevel > 0 }.count) of 7")
                        statLine(icon: "bolt.fill", color: vm.currentTheme.primaryColor, label: "Energy", value: "\(Int(vm.profile.energy * 100))%")
                    }
                }

                VStack(spacing: 6) {
                    HStack {
                        Text("Score progress to next rank")
                            .font(.system(size: 11, weight: .medium)).foregroundColor(.white.opacity(0.4))
                        Spacer()
                        let nextMilestone = nextRankThreshold
                        Text("\(nextMilestone - vm.profile.globalScore) pts to go")
                            .font(.system(size: 11, weight: .bold)).foregroundColor(vm.currentTheme.primaryColor)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.08)).frame(height: 7)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * rankProgress, height: 7)
                                .animation(.spring(response: 0.6), value: vm.profile.globalScore)
                        }
                    }
                    .frame(height: 7)
                }
            }
        }
        .environmentObject(vm)
    }

    private var nextRankThreshold: Int {
        switch vm.profile.globalScore {
        case 0..<100: return 100
        case 100..<300: return 300
        case 300..<600: return 600
        case 600..<900: return 900
        default: return 1000
        }
    }

    private var rankProgress: CGFloat {
        switch vm.profile.globalScore {
        case 0..<100: return CGFloat(vm.profile.globalScore) / 100.0
        case 100..<300: return CGFloat(vm.profile.globalScore - 100) / 200.0
        case 300..<600: return CGFloat(vm.profile.globalScore - 300) / 300.0
        case 600..<900: return CGFloat(vm.profile.globalScore - 600) / 300.0
        default: return min(CGFloat(vm.profile.globalScore - 900) / 100.0, 1.0)
        }
    }

    private var rankBadge: some View {
        let rank: (String, Color) = {
            switch vm.profile.globalScore {
            case 0..<100: return ("Sinner", Color(hex: "#8E8E93"))
            case 100..<300: return ("Penitent", Color(hex: "#FF6A00"))
            case 300..<600: return ("Disciplined", Color(hex: "#FFD60A"))
            case 600..<900: return ("Ascended", vm.currentTheme.primaryColor)
            default: return ("Inferno Lord", Color(hex: "#FFD60A"))
            }
        }()
        return HStack(spacing: 6) {
            Image(systemName: "shield.fill").font(.system(size: 10, weight: .bold)).foregroundColor(rank.1)
            Text(rank.0.uppercased()).font(.system(size: 9, weight: .black)).foregroundColor(rank.1).tracking(1)
        }
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(rank.1.opacity(0.15)).clipShape(Capsule())
    }

    @ViewBuilder
    private func statLine(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 11)).foregroundColor(color)
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(.white.opacity(0.5))
            Spacer()
            Text(value).font(.system(size: 12, weight: .bold)).foregroundColor(.white)
        }
    }

    // MARK: — Stats Grid
    private var statsGrid: some View {
        HStack(spacing: 10) {
            statPill(icon: "moon.fill", label: "Nights Sober", value: "\(vm.profile.streakDays)", color: Color(hex: "#5E5CE6"))
            statPill(icon: "calendar", label: "Missions Done", value: "\(vm.profile.globalScore / 25)", color: Color(hex: "#30D158"))
            statPill(icon: "percent", label: "Daily Avg", value: "\(Int(vm.profile.dailyPurificationPct * 100))%", color: Color(hex: "#FF6A00"))
        }
    }

    @ViewBuilder
    private func statPill(icon: String, label: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 14)).foregroundColor(color)
            Text(value).font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(.white)
            Text(label).font(.system(size: 9, weight: .semibold)).foregroundColor(.white.opacity(0.35)).tracking(0.5).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.opacity(0.1))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.2), lineWidth: 0.8))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: — Heatmap
    private var heatmapSection: some View {
        CustomCardHS {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar").font(.system(size: 11, weight: .semibold)).foregroundColor(vm.currentTheme.primaryColor)
                    Text("ACTIVITY HEATMAP").font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.4)).tracking(1.5)
                    Spacer()
                    Text(currentMonthLabel).font(.system(size: 11, weight: .semibold)).foregroundColor(.white.opacity(0.4))
                }
                HeatmapCalendarHS(month: Date())
                    .environmentObject(vm)

                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        ForEach([0.12, 0.3, 0.55, 0.75, 1.0], id: \.self) { op in
                            RoundedRectangle(cornerRadius: 2).fill(vm.currentTheme.primaryColor.opacity(op)).frame(width: 14, height: 14)
                        }
                    }
                    Text("Intensity: 0→ peak discipline")
                        .font(.system(size: 9, weight: .medium)).foregroundColor(.white.opacity(0.3))
                    Spacer()
                }
            }
        }
        .environmentObject(vm)
    }

    private var currentMonthLabel: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: Date())
    }

    // MARK: — AI Prediction
    private var aiPredictionBlock: some View {
        CustomCardHS(glow: true) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile").font(.system(size: 11, weight: .semibold)).foregroundColor(vm.currentTheme.primaryColor)
                    Text("BEHAVIORAL PREDICTION").font(.system(size: 9, weight: .black)).foregroundColor(vm.currentTheme.primaryColor).tracking(1.5)
                }
                Text(vm.predictionText)
                    .font(.system(size: 15, weight: .semibold)).foregroundColor(.white).lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 6) {
                    Image(systemName: "waveform.path.ecg").font(.system(size: 10)).foregroundColor(Color(hex: "#FFD60A"))
                    Text("Based on your behavioral patterns").font(.system(size: 10, weight: .medium)).foregroundColor(.white.opacity(0.35))
                }
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Sin Breakdown
    private var sinBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SIN BREAKDOWN")
                .font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.3)).tracking(1.5)

            ForEach(SinTypeHS.allCases) { sinType in
                let level = vm.profile.sinLevels[sinType.rawValue] ?? Double.random(in: 0.3...0.9)
                let sin = vm.sins.first(where: { $0.id == sinType })
                CustomCardHS {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color(hex: sinType.color).opacity(0.15)).frame(width: 36, height: 36)
                            Image(systemName: sinType.icon).font(.system(size: 14, weight: .semibold)).foregroundColor(Color(hex: sinType.color))
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(sinType.rawValue).font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                                Spacer()
                                Text("\(Int(level * 100))%").font(.system(size: 12, weight: .bold)).foregroundColor(Color(hex: sinType.color))
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.08)).frame(height: 5)
                                    RoundedRectangle(cornerRadius: 3).fill(Color(hex: sinType.color)).frame(width: geo.size.width * level, height: 5)
                                }
                            }.frame(height: 5)
                        }
                        if (sin?.masteryLevel ?? 0) > 0 {
                            Image(systemName: "shield.fill").foregroundColor(Color(hex: "#FFD60A")).font(.system(size: 14))
                        } else {
                            Button { path.append(NavigationDestinationHS.sinDetail(sinType)) } label: {
                                Text("Test").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                                    .padding(.horizontal, 10).padding(.vertical, 5)
                                    .background(vm.currentTheme.primaryColor.opacity(0.3))
                                    .clipShape(Capsule())
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .environmentObject(vm)
            }
        }
    }
}

#Preview {
    ZStack {
        InfernoBackgroundHS()
        JudgementViewHS(path: .constant(NavigationPath()))
    }
    .environmentObject(ViewModelHS())
}
