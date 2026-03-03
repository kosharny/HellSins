import SwiftUI

struct GroundingViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    @State private var currentStep = 0
    @State private var animateIn = false
    @State private var breatheExpand = false

    struct GroundingStep {
        let number: String
        let senses: String
        let instruction: String
        let icon: String
    }

    let steps: [GroundingStep] = [
        GroundingStep(number: "5", senses: "SEE", instruction: "Name 5 things you can see right now. Look around slowly and identify them one by one.", icon: "eye.fill"),
        GroundingStep(number: "4", senses: "TOUCH", instruction: "Name 4 things you can physically feel. The floor, your clothes, temperature, texture.", icon: "hand.raised.fill"),
        GroundingStep(number: "3", senses: "HEAR", instruction: "Name 3 things you can hear. Close your eyes and listen. Distant sounds count too.", icon: "ear.fill"),
        GroundingStep(number: "2", senses: "SMELL", instruction: "Name 2 things you can smell. Take slow, deep breaths through your nose.", icon: "wind"),
        GroundingStep(number: "1", senses: "TASTE", instruction: "Name 1 thing you can taste. Swallow gently and notice any lingering sensation.", icon: "mouth.fill")
    ]

    var body: some View {
        ZStack {
            InfernoBackgroundHS()
            VStack(spacing: 0) {
                topBar
                Spacer()
                breathingOrb
                Spacer()
                stepContent
                bottomControls
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation { animateIn = true }
            startBreathing()
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(12)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            Spacer()
            Text("SOS — Grounding")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Text("\(currentStep + 1)/5")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var breathingOrb: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { ring in
                Circle()
                    .stroke(vm.currentTheme.primaryColor.opacity(0.08 - Double(ring) * 0.02), lineWidth: 1)
                    .frame(width: CGFloat(140 + ring * 30), height: CGFloat(140 + ring * 30))
                    .scaleEffect(breatheExpand ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(Double(ring) * 0.3), value: breatheExpand)
            }

            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [vm.currentTheme.primaryColor.opacity(0.4), vm.currentTheme.primaryColor.opacity(0.05)], center: .center, startRadius: 0, endRadius: 70))
                    .frame(width: 140, height: 140)
                    .scaleEffect(breatheExpand ? 1.08 : 0.92)
                    .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: breatheExpand)

                VStack(spacing: 4) {
                    Text(steps[currentStep].number)
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), vm.currentTheme.primaryColor], startPoint: .top, endPoint: .bottom))
                    Text(breatheExpand ? "breathe in" : "breathe out")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                        .animation(.none, value: breatheExpand)
                }
            }
        }
    }

    private var stepContent: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: steps[currentStep].icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(vm.currentTheme.primaryColor)
                Text(steps[currentStep].senses)
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(vm.currentTheme.primaryColor)
                    .tracking(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(vm.currentTheme.primaryColor.opacity(0.12))
            .clipShape(Capsule())

            Text(steps[currentStep].instruction)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 32)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 16)
                .animation(.easeOut(duration: 0.4), value: animateIn)
        }
        .padding(.bottom, 24)
    }

    private var bottomControls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                ForEach(0..<steps.count, id: \.self) { i in
                    Capsule()
                        .fill(i <= currentStep ? vm.currentTheme.primaryColor : Color.white.opacity(0.15))
                        .frame(width: i == currentStep ? 24 : 8, height: 5)
                        .animation(.spring(response: 0.4), value: currentStep)
                }
            }

            Button {
                withAnimation { animateIn = false }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if currentStep < steps.count - 1 {
                        currentStep += 1
                        withAnimation { animateIn = true }
                    } else {
                        path.removeLast()
                    }
                }
            } label: {
                Text(currentStep == steps.count - 1 ? "I Feel Grounded" : "Next Step")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(LinearGradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: vm.currentTheme.primaryColor.opacity(0.4), radius: 10, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }

    private func startBreathing() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            breatheExpand = true
        }
    }
}

#Preview {
    GroundingViewHS(path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
