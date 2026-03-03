import SwiftUI

struct ColdShockViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    @State private var timerSeconds = 0
    @State private var isRunning = false
    @State private var challengeTimer: Timer?
    @State private var phase = 0
    @State private var completed = false

    private let targetSeconds = 30

    private let benefits = [
        ("bolt.fill", "#FFD60A", "Norepinephrine +300%", "Boosts focus and energy for 3–4 hours"),
        ("brain.head.profile", "#5E5CE6", "Dopamine baseline up", "Long-term mood elevation after 1 week"),
        ("shield.fill", "#30D158", "Cold adaptation", "Wilpower pathways strengthen with exposure"),
        ("flame.fill", "#FF6A00", "Brown fat activation", "Metabolism boost via thermogenesis")
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0A0A1A"), Color(hex: "#001030"), Color(hex: "#003060")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    topBar
                    timerWidget
                    if completed { completionBlock }
                    benefitsSection
                    protocolSection
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onDisappear { challengeTimer?.invalidate() }
    }

    private var topBar: some View {
        HStack {
            Button { path.removeLast() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Cold Shock Protocol")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var timerWidget: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.05), lineWidth: 14)
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: min(CGFloat(timerSeconds) / CGFloat(targetSeconds), 1.0))
                    .stroke(
                        LinearGradient(colors: [Color(hex: "#00BFFF"), Color(hex: "#5E5CE6")], startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 200, height: 200)
                    .animation(.easeInOut(duration: 1.0), value: timerSeconds)

                VStack(spacing: 4) {
                    if completed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color(hex: "#30D158"))
                    } else {
                        Text(timeString(timerSeconds))
                            .font(.system(size: 44, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("of 30 sec")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }
            }
            .padding(.top, 8)

            HStack(spacing: 14) {
                Button {
                    isRunning ? pauseTimer() : startTimer()
                } label: {
                    Label(isRunning ? "Pause" : (timerSeconds > 0 ? "Resume" : "Start 30s"),
                          systemImage: isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: [Color(hex: "#00BFFF"), Color(hex: "#5E5CE6")], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color(hex: "#00BFFF").opacity(0.4), radius: 10, y: 4)
                }
                .buttonStyle(PlainButtonStyle())

                if timerSeconds > 0 {
                    Button { resetTimer() } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(14)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private var completionBlock: some View {
        VStack(spacing: 8) {
            Text("🧊 30 seconds complete!")
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)
            Text("Your norepinephrine just surged. You'll feel sharper for the next 3–4 hours.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(16)
        .background(Color(hex: "#30D158").opacity(0.1))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#30D158").opacity(0.3), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
        .transition(.scale.combined(with: .opacity))
    }

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SCIENCE-BACKED BENEFITS")
                .font(.system(size: 9, weight: .black))
                .foregroundColor(.white.opacity(0.3))
                .tracking(1.5)
                .padding(.horizontal, 20)

            VStack(spacing: 10) {
                ForEach(benefits, id: \.0) { b in
                    HStack(spacing: 12) {
                        Image(systemName: b.0)
                            .foregroundColor(Color(hex: b.1))
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 36, height: 36)
                            .background(Color(hex: b.1).opacity(0.15))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 2) {
                            Text(b.2).font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                            Text(b.3).font(.system(size: 11, weight: .regular)).foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var protocolSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("HOW TO DO IT")
                .font(.system(size: 9, weight: .black))
                .foregroundColor(.white.opacity(0.3))
                .tracking(1.5)
                .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 8) {
                protocolStep("1", "Turn shower to cold only")
                protocolStep("2", "Step in and start timer")
                protocolStep("3", "Keep shoulders under the water")
                protocolStep("4", "Breathe through the discomfort")
                protocolStep("5", "Build to 3 min over 2 weeks")
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func protocolStep(_ num: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            Text(num)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(Color(hex: "#00BFFF"))
                .frame(width: 24, height: 24)
                .background(Color(hex: "#00BFFF").opacity(0.15))
                .clipShape(Circle())
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
    }

    private func startTimer() {
        isRunning = true
        challengeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timerSeconds < targetSeconds {
                timerSeconds += 1
                if timerSeconds >= targetSeconds {
                    pauseTimer()
                    withAnimation { completed = true }
                }
            }
        }
    }

    private func pauseTimer() {
        isRunning = false
        challengeTimer?.invalidate()
        challengeTimer = nil
    }

    private func resetTimer() {
        pauseTimer()
        timerSeconds = 0
        completed = false
    }

    private func timeString(_ s: Int) -> String {
        String(format: "%02d", s)
    }
}

#Preview {
    ColdShockViewHS(path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
