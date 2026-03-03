import SwiftUI

struct InfernoViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CustomHeaderHS(title: "Inferno", path: $path)
                statusBlock
                heartOfFlameBlock
                currentMissionCard
                shadowProfileBlock
                dailyFeedBlock
                disciplineTools
                Spacer(minLength: 120)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: — Block 1: Status
    private var statusBlock: some View {
        HStack(spacing: 14) {
            CustomCardHS {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill").font(.system(size: 12, weight: .bold)).foregroundColor(Color(hex: "#FF6A00"))
                        Text("CLEAN DAYS").font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.4)).tracking(1.2)
                    }
                    Text("\(vm.profile.streakDays)")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .top, endPoint: .bottom))
                    Text(vm.profile.streakDays == 1 ? "day in control" : "days in control")
                        .font(.system(size: 11, weight: .medium)).foregroundColor(.white.opacity(0.4))
                }
            }
            .environmentObject(vm)
            .frame(maxWidth: .infinity)

            CustomCardHS {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill").font(.system(size: 12, weight: .bold)).foregroundColor(vm.currentTheme.primaryColor)
                        Text("ENERGY").font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.4)).tracking(1.2)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.08))
                            Capsule()
                                .fill(LinearGradient(colors: [vm.currentTheme.accentColor, vm.currentTheme.primaryColor], startPoint: .leading, endPoint: .trailing))
                                .frame(width: max(8, geo.size.width * CGFloat(vm.profile.energy)))
                                .animation(.spring(response: 0.5), value: vm.profile.energy)
                        }
                    }
                    .frame(height: 8)
                    Text("\(Int(vm.profile.energy * 100))% charged")
                        .font(.system(size: 11, weight: .medium)).foregroundColor(.white.opacity(0.4))
                    Spacer(minLength: 0)
                    Text("Regen: +1%/min")
                        .font(.system(size: 9, weight: .regular)).foregroundColor(.white.opacity(0.25))
                }
            }
            .environmentObject(vm)
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: — Block 2: Heart of Flame + SOS
    private var heartOfFlameBlock: some View {
        CustomCardHS(glow: true) {
            VStack(spacing: 16) {
                Text("HEART OF FLAME")
                    .font(.system(size: 10, weight: .black)).foregroundColor(.white.opacity(0.4)).tracking(1.5)

                HStack(spacing: 32) {
                    Spacer()
                    ZStack {
                        Circle().stroke(Color.white.opacity(0.06), lineWidth: 14).frame(width: 130, height: 130)
                        Circle()
                            .trim(from: 0, to: vm.profile.dailyPurificationPct)
                            .stroke(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00"), vm.currentTheme.primaryColor], startPoint: .leading, endPoint: .trailing),
                                    style: StrokeStyle(lineWidth: 14, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 130, height: 130)
                            .animation(.spring(response: 0.8, dampingFraction: 0.75), value: vm.profile.dailyPurificationPct)
                        VStack(spacing: 2) {
                            Image(systemName: "flame.fill").font(.system(size: 24, weight: .black))
                                .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .top, endPoint: .bottom))
                            Text("\(Int(vm.profile.dailyPurificationPct * 100))%")
                                .font(.system(size: 22, weight: .black, design: .rounded)).foregroundColor(.white)
                            Text("purified").font(.system(size: 9, weight: .semibold)).foregroundColor(.white.opacity(0.4))
                        }
                    }
                    Spacer()

                    VStack(spacing: 12) {
                        Button { path.append(NavigationDestinationHS.grounding) } label: {
                            VStack(spacing: 6) {
                                ZStack {
                                    Image("inferno_sos_flame")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipShape(Circle())
                                }
                                Text("SOS").font(.system(size: 10, weight: .black)).foregroundColor(Color(hex: "#FF3B30")).tracking(1.5)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        Text("Grounding\ntechnique").font(.system(size: 9, weight: .medium)).foregroundColor(.white.opacity(0.3)).multilineTextAlignment(.center)
                    }
                    Spacer()
                }

                HStack(spacing: 0) {
                    let done = vm.habits.filter { $0.isCompletedToday }.count
                    let total = max(1, vm.habits.count)
                    ForEach(0..<total, id: \.self) { i in
                        Capsule().fill(i < done ? Color(hex: "#30D158") : Color.white.opacity(0.1)).frame(height: 3)
                        if i < total - 1 { Spacer(minLength: 2) }
                    }
                }
                Text("\(vm.habits.filter { $0.isCompletedToday }.count) of \(vm.habits.count) habits complete today")
                    .font(.system(size: 11, weight: .medium)).foregroundColor(.white.opacity(0.4))
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Block 3: Current Mission
    private var currentMissionCard: some View {
        CustomCardHS(glow: vm.currentMission.isCheckedIn) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "target").font(.system(size: 11, weight: .semibold)).foregroundColor(vm.currentTheme.primaryColor)
                    Text("CURRENT MISSION").font(.system(size: 9, weight: .black)).foregroundColor(vm.currentTheme.primaryColor).tracking(1.5)
                    Spacer()
                    if !vm.currentMission.isCheckedIn {
                        Text(vm.currentMission.timeRemainingText)
                            .font(.system(size: 11, weight: .semibold)).foregroundColor(Color(hex: "#FFD60A"))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color(hex: "#FFD60A").opacity(0.12)).clipShape(Capsule())
                    }
                }
                Text(vm.currentMission.title).font(.system(size: 16, weight: .bold)).foregroundColor(.white).lineSpacing(3)

                if vm.currentMission.isCheckedIn {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#30D158"))
                        Text("Mission complete. +25 pts earned").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: "#30D158"))
                    }
                } else {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { vm.checkInMission() }
                    } label: {
                        HStack {
                            Image(systemName: "checkmark").font(.system(size: 13, weight: .bold))
                            Text("Check In Now").font(.system(size: 14, weight: .bold))
                            Spacer()
                            Text("+25 pts").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16).padding(.vertical, 13)
                        .background(LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Block 4: Shadow Profile
    private var shadowProfileBlock: some View {
        CustomCardHS {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "eye.fill").font(.system(size: 11, weight: .semibold)).foregroundColor(vm.currentTheme.primaryColor)
                    Text("SHADOW PROFILE").font(.system(size: 9, weight: .black)).foregroundColor(vm.currentTheme.primaryColor).tracking(1.5)
                }
                HStack(spacing: 16) {
                    RadarChartHS(values: vm.profile.radarValues, labels: SinTypeHS.allCases.map { String($0.rawValue.prefix(3)) })
                        .frame(width: 120, height: 120)
                        .environmentObject(vm)

                    VStack(alignment: .leading, spacing: 8) {
                        if let dom = vm.profile.dominantSin {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Image(systemName: dom.icon).foregroundColor(Color(hex: dom.color))
                                    Text(dom.rawValue.uppercased()).font(.system(size: 11, weight: .black)).foregroundColor(Color(hex: dom.color)).tracking(1)
                                }
                                Text("is peaking").font(.system(size: 11, weight: .semibold)).foregroundColor(.white.opacity(0.6))
                            }
                        }
                        Text(vm.radarInsightText)
                            .font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.7)).lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                        Button {
                            if let dom = vm.profile.dominantSin { path.append(NavigationDestinationHS.sinDetail(dom)) }
                        } label: {
                            Text("Take the test →").font(.system(size: 11, weight: .bold)).foregroundColor(vm.currentTheme.primaryColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .environmentObject(vm)
    }

    // MARK: — Block 5: Daily Feed (psych fact + mini challenge)
    private var dailyFeedBlock: some View {
        VStack(spacing: 12) {
            Text("DAILY FEED")
                .font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.3)).tracking(1.5)
                .frame(maxWidth: .infinity, alignment: .leading)

            CustomCardHS {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color(hex: "#FFD60A").opacity(0.15)).frame(width: 40, height: 40)
                        Image(systemName: "brain.head.profile").font(.system(size: 16, weight: .semibold)).foregroundColor(Color(hex: "#FFD60A"))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PSYCH FACT").font(.system(size: 8, weight: .black)).foregroundColor(Color(hex: "#FFD60A").opacity(0.8)).tracking(1.2)
                        Text(vm.psychFact).font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.85)).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .environmentObject(vm)

            CustomCardHS {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color(hex: "#30D158").opacity(0.15)).frame(width: 40, height: 40)
                        Image(systemName: "bolt.fill").font(.system(size: 16, weight: .semibold)).foregroundColor(Color(hex: "#30D158"))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("MINI CHALLENGE").font(.system(size: 8, weight: .black)).foregroundColor(Color(hex: "#30D158").opacity(0.8)).tracking(1.2)
                        Text(vm.miniChallenge).font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.85)).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .environmentObject(vm)
        }
    }

    // MARK: — Discipline Tools (new feature cards)
    private var disciplineTools: some View {
        VStack(spacing: 12) {
            Text("DISCIPLINE TOOLS")
                .font(.system(size: 9, weight: .black)).foregroundColor(.white.opacity(0.3)).tracking(1.5)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button { path.append(NavigationDestinationHS.breathing) } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Image("inferno_breathing_chamber")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Box Breathing")
                            .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                        Text("4-4-4-4 cortisol reset · 3 min")
                            .font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.3))
                }
                .padding(16)
                .background(Color(hex: "#5E5CE6").opacity(0.15))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#5E5CE6").opacity(0.3), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(PlainButtonStyle())

            Button { path.append(NavigationDestinationHS.coldShock) } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Image("inferno_cold_shock")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Cold Shock Protocol")
                            .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                        Text("30-second exposure · norepinephrine +300%")
                            .font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.3))
                }
                .padding(16)
                .background(Color(hex: "#00BFFF").opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#00BFFF").opacity(0.25), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(PlainButtonStyle())

            Button { path.append(NavigationDestinationHS.grounding) } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Image("inferno_sos_breathe")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("5-4-3-2-1 Grounding")
                            .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                        Text("Crisis moment · bring yourself back")
                            .font(.system(size: 12, weight: .regular)).foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.3))
                }
                .padding(16)
                .background(Color(hex: "#30D158").opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#30D158").opacity(0.25), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    ZStack {
        InfernoBackgroundHS()
        InfernoViewHS(path: .constant(NavigationPath()))
    }
    .environmentObject(ViewModelHS())
}
