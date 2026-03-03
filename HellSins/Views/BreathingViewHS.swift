import SwiftUI

struct BreathingViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    enum BreathPhaseHS: String, CaseIterable {
        case inhale = "Inhale"
        case holdIn = "Hold In"
        case exhale = "Exhale"
        case holdOut = "Hold Out"
    }

    @State private var phase: BreathPhaseHS = .inhale
    @State private var circleScale: CGFloat = 0.5
    @State private var countdown: Int = 4
    @State private var cyclesCompleted: Int = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var phaseTimer: Timer?
    @State private var secondsInPhase: Int = 0

    private let phaseDuration = 4
    private let phases: [BreathPhaseHS] = [.inhale, .holdIn, .exhale, .holdOut]
    private var phaseIndex: Int { phases.firstIndex(of: phase) ?? 0 }

    private var phaseColor: Color {
        switch phase {
        case .inhale: return vm.currentTheme.primaryColor
        case .holdIn: return Color(hex: "#FFD60A")
        case .exhale: return Color(hex: "#5E5CE6")
        case .holdOut: return Color.white.opacity(0.4)
        }
    }

    var body: some View {
        ZStack {
            InfernoBackgroundHS()
            VStack(spacing: 0) {
                topBar
                Spacer()
                breathingOrb
                Spacer()
                phaseLabel
                sessionInfo
                bottomControls
            }
        }
        .navigationBarHidden(true)
        .onDisappear { stopBreathing() }
    }

    private var topBar: some View {
        HStack {
            Button { stopBreathing(); path.removeLast() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Box Breathing")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Text("\(cyclesCompleted) cycles")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 70, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var breathingOrb: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { ring in
                Circle()
                    .stroke(phaseColor.opacity(0.06 - Double(ring) * 0.01), lineWidth: 1)
                    .frame(width: CGFloat(180 + ring * 35), height: CGFloat(180 + ring * 35))
                    .scaleEffect(circleScale * (1.0 + CGFloat(ring) * 0.05))
                    .animation(.easeInOut(duration: Double(phaseDuration)), value: circleScale)
            }

            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [phaseColor.opacity(0.35), phaseColor.opacity(0.02)], center: .center, startRadius: 0, endRadius: 100))
                    .frame(width: 200, height: 200)
                    .scaleEffect(circleScale)
                    .animation(.easeInOut(duration: Double(phaseDuration)), value: circleScale)

                VStack(spacing: 8) {
                    Text("\(max(0, phaseDuration - secondsInPhase))")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    Text(isRunning ? phase.rawValue.uppercased() : "READY")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(phaseColor)
                        .tracking(2)
                        .animation(.none, value: phase)
                }
            }
        }
    }

    private var phaseLabel: some View {
        HStack(spacing: 0) {
            ForEach(Array(phases.enumerated()), id: \.offset) { idx, p in
                VStack(spacing: 6) {
                    Text(p == .holdIn ? "Hold In" : p == .holdOut ? "Hold Out" : p.rawValue)
                        .font(.system(size: 10, weight: idx == phaseIndex && isRunning ? .black : .medium))
                        .foregroundColor(idx == phaseIndex && isRunning ? phaseColor : .white.opacity(0.25))
                    Capsule()
                        .fill(idx == phaseIndex && isRunning ? phaseColor : Color.white.opacity(0.1))
                        .frame(height: 3)
                }
                .frame(maxWidth: .infinity)
                .animation(.spring(response: 0.3), value: phase)
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 24)
    }

    private var sessionInfo: some View {
        VStack(spacing: 8) {
            Text("Box Breathing: 4-4-4-4 technique")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            Text("Inhale 4s → Hold 4s → Exhale 4s → Hold 4s")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.3))
            if cyclesCompleted > 0 {
                Text("Cortisol reduced · Nervous system reset")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "#30D158"))
                    .transition(.opacity)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 24)
    }

    private var bottomControls: some View {
        Button {
            isRunning ? stopBreathing() : startBreathing()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 16, weight: .bold))
                Text(isRunning ? "Pause" : (cyclesCompleted > 0 ? "Resume" : "Begin Session"))
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(colors: [phaseColor, phaseColor.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: phaseColor.opacity(0.4), radius: 12, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }

    private func startBreathing() {
        isRunning = true
        secondsInPhase = 0
        setPhase(.inhale)
        phaseTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            secondsInPhase += 1
            if secondsInPhase >= phaseDuration {
                secondsInPhase = 0
                let nextIndex = (phaseIndex + 1) % phases.count
                if nextIndex == 0 { cyclesCompleted += 1 }
                setPhase(phases[nextIndex])
            }
        }
    }

    private func stopBreathing() {
        isRunning = false
        phaseTimer?.invalidate()
        phaseTimer = nil
        withAnimation { circleScale = 0.5 }
    }

    private func setPhase(_ newPhase: BreathPhaseHS) {
        withAnimation(.easeInOut(duration: Double(phaseDuration))) {
            phase = newPhase
            switch newPhase {
            case .inhale: circleScale = 1.0
            case .holdIn: circleScale = 1.0
            case .exhale: circleScale = 0.5
            case .holdOut: circleScale = 0.5
            }
        }
    }
}

#Preview {
    BreathingViewHS(path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
