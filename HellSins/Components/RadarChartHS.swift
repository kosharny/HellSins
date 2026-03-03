import SwiftUI

struct RadarChartHS: View {
    let values: [Double]
    let labels: [String]
    @EnvironmentObject var vm: ViewModelHS

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = size / 2 - 20
            let count = values.count
            let angleStep = (2 * Double.pi) / Double(count)

            Canvas { ctx, _ in
                for layer in stride(from: 0.2, through: 1.0, by: 0.2) {
                    var gridPath = Path()
                    for i in 0..<count {
                        let angle = angleStep * Double(i) - Double.pi / 2
                        let x = center.x + CGFloat(cos(angle) * radius * layer)
                        let y = center.y + CGFloat(sin(angle) * radius * layer)
                        if i == 0 { gridPath.move(to: CGPoint(x: x, y: y)) }
                        else { gridPath.addLine(to: CGPoint(x: x, y: y)) }
                    }
                    gridPath.closeSubpath()
                    ctx.stroke(gridPath, with: .color(.white.opacity(0.1)), lineWidth: 0.8)
                }

                for i in 0..<count {
                    let angle = angleStep * Double(i) - Double.pi / 2
                    let x = center.x + CGFloat(cos(angle) * radius)
                    let y = center.y + CGFloat(sin(angle) * radius)
                    var spokePath = Path()
                    spokePath.move(to: center)
                    spokePath.addLine(to: CGPoint(x: x, y: y))
                    ctx.stroke(spokePath, with: .color(.white.opacity(0.15)), lineWidth: 0.8)
                }

                var dataPath = Path()
                for i in 0..<count {
                    let clamped = min(max(values[i], 0), 1)
                    let angle = angleStep * Double(i) - Double.pi / 2
                    let x = center.x + CGFloat(cos(angle) * radius * clamped)
                    let y = center.y + CGFloat(sin(angle) * radius * clamped)
                    if i == 0 { dataPath.move(to: CGPoint(x: x, y: y)) }
                    else { dataPath.addLine(to: CGPoint(x: x, y: y)) }
                }
                dataPath.closeSubpath()
                ctx.fill(dataPath, with: .color(vm.currentTheme.primaryColor.opacity(0.3)))
                ctx.stroke(dataPath, with: .linearGradient(
                    Gradient(colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor]),
                    startPoint: CGPoint(x: center.x - radius, y: center.y),
                    endPoint: CGPoint(x: center.x + radius, y: center.y)
                ), lineWidth: 2)

                for i in 0..<count {
                    let clamped = min(max(values[i], 0), 1)
                    let angle = angleStep * Double(i) - Double.pi / 2
                    let x = center.x + CGFloat(cos(angle) * radius * clamped)
                    let y = center.y + CGFloat(sin(angle) * radius * clamped)
                    ctx.fill(Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6)),
                             with: .color(vm.currentTheme.primaryColor))
                }
            }

            ForEach(Array(labels.enumerated()), id: \.offset) { i, label in
                let angle = angleStep * Double(i) - Double.pi / 2
                let dist = radius + 16
                let x = center.x + CGFloat(cos(angle) * dist)
                let y = center.y + CGFloat(sin(angle) * dist)
                Text(label)
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .position(x: x, y: y)
            }
        }
    }
}

#Preview {
    RadarChartHS(
        values: [0.8, 0.4, 0.6, 0.3, 0.7, 0.5, 0.9],
        labels: SinTypeHS.allCases.map { $0.rawValue }
    )
    .frame(width: 200, height: 200)
    .background(Color(hex: "#0F0F12"))
    .environmentObject(ViewModelHS())
}
