import SwiftUI

struct CustomCardHS<Content: View>: View {
    var glow: Bool = false
    var padding: CGFloat = 16
    @EnvironmentObject var vm: ViewModelHS
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(
                                glow ? vm.currentTheme.primaryColor.opacity(0.5) : Color.white.opacity(0.1),
                                lineWidth: glow ? 1.5 : 0.5
                            )
                    )
            )
            .shadow(
                color: glow ? vm.currentTheme.primaryColor.opacity(0.3) : Color.black.opacity(0.3),
                radius: glow ? 12 : 6,
                y: 4
            )
    }
}

#Preview {
    CustomCardHS(glow: true) {
        Text("Hell Sins Card")
            .foregroundColor(.white)
    }
    .padding()
    .background(Color(hex: "#0F0F12"))
    .environmentObject(ViewModelHS())
}
