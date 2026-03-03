import SwiftUI

struct SinDetailViewHS: View {
    let sinType: SinTypeHS
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int? = nil
    @State private var score = 0
    @State private var showResult = false
    @State private var animateIn = false

    private var test: SinTestHS { SinTestHS.test(for: sinType) }

    var body: some View {
        ZStack {
            InfernoBackgroundHS()
            if showResult {
                resultView
            } else {
                questionView
            }
        }
        .navigationBarHidden(true)
        .onAppear { withAnimation { animateIn = true } }
    }

    private var questionView: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(vm.currentTheme.primaryColor)
                        .padding(12)
                        .background(Color.white.opacity(0.07))
                        .clipShape(Circle())
                }
                Spacer()
                Text("\(currentQuestion + 1) / \(test.questions.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color(hex: sinType.color).opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: sinType.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: sinType.color))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(sinType.rawValue.uppercased())
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(Color(hex: sinType.color))
                        .tracking(2)
                    Spacer()
                }
                CustomProgressBarHS(value: Double(currentQuestion) / Double(test.questions.count), height: 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            Spacer()

            VStack(alignment: .leading, spacing: 24) {
                Text(test.questions[currentQuestion].question)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 20)
                    .animation(.easeOut(duration: 0.4), value: animateIn)

                VStack(spacing: 10) {
                    ForEach(Array(test.questions[currentQuestion].options.enumerated()), id: \.offset) { index, option in
                        Button {
                            selectedAnswer = index
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .stroke(selectedAnswer == index ? Color(hex: sinType.color) : Color.white.opacity(0.2), lineWidth: 2)
                                        .frame(width: 22, height: 22)
                                    if selectedAnswer == index {
                                        Circle()
                                            .fill(Color(hex: sinType.color))
                                            .frame(width: 13, height: 13)
                                    }
                                }
                                Text(option)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(selectedAnswer == index ? .white : .white.opacity(0.7))
                                Spacer()
                            }
                            .padding(16)
                            .background(selectedAnswer == index ? Color(hex: sinType.color).opacity(0.15) : Color.white.opacity(0.05))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(selectedAnswer == index ? Color(hex: sinType.color).opacity(0.6) : Color.white.opacity(0.08), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                if selectedAnswer != nil {
                    Button {
                        advanceQuestion()
                    } label: {
                        HStack {
                            Text(currentQuestion == test.questions.count - 1 ? "View Results" : "Next")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(LinearGradient(colors: [Color(hex: sinType.color), Color(hex: sinType.color).opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }

    private var resultView: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color(hex: sinType.color).opacity(0.15))
                        .frame(width: 100, height: 100)
                    VStack(spacing: 2) {
                        Text("\(score)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: sinType.color))
                        Text("/ \(test.questions.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                VStack(spacing: 8) {
                    Text("\(sinType.rawValue) Assessment")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(resultMessage)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 24)

                CustomProgressBarHS(value: Double(score) / Double(test.questions.count), height: 14, showLabel: true, labelText: "Mastery Score")
                    .padding(.horizontal, 24)
                    .environmentObject(vm)

                VStack(spacing: 12) {
                    CustomButtonHS(title: "Save Results", icon: "checkmark.circle.fill", action: {
                        vm.completeSinTest(sin: sinType, score: score, total: test.questions.count)
                        path.removeLast()
                    })
                    CustomButtonHS(title: "Retake Test", icon: "arrow.clockwise", action: {
                        resetTest()
                    }, style: .secondary)
                }
                .padding(.horizontal, 24)
            }
            Spacer()
        }
    }

    private var resultMessage: String {
        let ratio = Double(score) / Double(test.questions.count)
        if ratio >= 0.8 { return "Excellent self-awareness. \(sinType.rawValue) has limited power over you." }
        else if ratio >= 0.6 { return "Good control. Continue building awareness around \(sinType.rawValue)." }
        else if ratio >= 0.4 { return "\(sinType.rawValue) shows moderate influence. Stay vigilant." }
        else { return "\(sinType.rawValue) is a strong pattern for you. Focus here first." }
    }

    private func advanceQuestion() {
        if let ans = selectedAnswer {
            if ans == test.questions[currentQuestion].correctIndex { score += 1 }
        }
        selectedAnswer = nil

        withAnimation { animateIn = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if currentQuestion < test.questions.count - 1 {
                currentQuestion += 1
                withAnimation { animateIn = true }
            } else {
                showResult = true
            }
        }
    }

    private func resetTest() {
        currentQuestion = 0
        selectedAnswer = nil
        score = 0
        showResult = false
        withAnimation { animateIn = true }
    }
}

#Preview {
    SinDetailViewHS(sinType: .pride, path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
