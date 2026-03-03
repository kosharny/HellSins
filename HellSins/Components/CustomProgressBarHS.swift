import SwiftUI

struct CustomProgressBarHS: View {
    let value: Double
    var height: CGFloat = 8
    var showLabel: Bool = false
    var labelText: String = ""
    @EnvironmentObject var vm: ViewModelHS

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showLabel {
                HStack {
                    Text(labelText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.6))
                    Spacer()
                    Text("\(Int(value * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(vm.currentTheme.primaryColor)
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: height)

                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(
                            LinearGradient(
                                colors: [vm.currentTheme.primaryColor, vm.currentTheme.accentColor, Color(hex: "#FFD60A")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geo.size.width * min(max(value, 0), 1)), height: height)
                        .shadow(color: vm.currentTheme.primaryColor.opacity(0.6), radius: 4)
                        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: value)
                }
            }
            .frame(height: height)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomProgressBarHS(value: 0.75, showLabel: true, labelText: "Energy")
        CustomProgressBarHS(value: 0.4, height: 12)
    }
    .padding()
    .background(Color(hex: "#0F0F12"))
    .environmentObject(ViewModelHS())
}
