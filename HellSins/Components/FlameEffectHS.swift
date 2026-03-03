import SwiftUI

struct FlameEffectHS: View {
    @EnvironmentObject var vm: ViewModelHS
    var scale: CGFloat = 1.0
    @State private var animate = false

    var body: some View {
        TimelineView(.animation) { context in
            Canvas { ctx, size in
                let t = context.date.timeIntervalSinceReferenceDate
                let cx = size.width / 2
                let baseY = size.height * 0.85

                for i in 0..<18 {
                    let fi = Double(i)
                    let x = cx + CGFloat(sin(t * 1.5 + fi * 0.8) * 28 * scale)
                    let height = CGFloat((0.45 + 0.35 * sin(t * 2.2 + fi * 0.6)) * Double(size.height) * Double(scale))
                    let width = CGFloat((0.18 + 0.12 * sin(t * 1.8 + fi * 0.9)) * Double(size.width) * Double(scale))
                    let opacity = 0.08 + 0.06 * sin(t * 1.6 + fi)

                    var flamePath = Path()
                    flamePath.move(to: CGPoint(x: x, y: baseY))
                    flamePath.addCurve(
                        to: CGPoint(x: x, y: baseY - height),
                        control1: CGPoint(x: x - width, y: baseY - height * 0.4),
                        control2: CGPoint(x: x + width * 0.8, y: baseY - height * 0.75)
                    )
                    flamePath.addCurve(
                        to: CGPoint(x: x, y: baseY),
                        control1: CGPoint(x: x + width * 0.6, y: baseY - height * 0.5),
                        control2: CGPoint(x: x - width * 0.4, y: baseY - height * 0.2)
                    )

                    let color = i % 3 == 0 ? UIColor(vm.currentTheme.primaryColor) : (i % 3 == 1 ? UIColor(vm.currentTheme.accentColor) : UIColor(Color(hex: "#FFD60A")))
                    ctx.fill(flamePath, with: .color(Color(uiColor: color).opacity(opacity * 6)))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct FlameGlowHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(vm.currentTheme.primaryColor.opacity(0.15))
                .scaleEffect(pulse ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: pulse)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [vm.currentTheme.primaryColor.opacity(0.6), vm.currentTheme.accentColor.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 60
                    )
                )

            Image(systemName: "flame.fill")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "#FFD60A"), vm.currentTheme.accentColor, vm.currentTheme.primaryColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(pulse ? 1.08 : 0.95)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear { pulse = true }
    }
}

#Preview {
    ZStack {
        Color(hex: "#0F0F12").ignoresSafeArea()
        VStack(spacing: 20) {
            FlameEffectHS()
                .frame(width: 120, height: 120)
            FlameGlowHS()
                .frame(width: 120, height: 120)
        }
    }
    .environmentObject(ViewModelHS())
}
