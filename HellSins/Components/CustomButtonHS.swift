import SwiftUI

struct CustomButtonHS: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var style: ButtonStyleHS = .primary

    @EnvironmentObject var vm: ViewModelHS
    @State private var isPressed = false

    enum ButtonStyleHS {
        case primary, secondary, danger, ghost
    }

    var gradientColors: [Color] {
        switch style {
        case .primary: return [vm.currentTheme.primaryColor, vm.currentTheme.accentColor]
        case .secondary: return [Color.white.opacity(0.12), Color.white.opacity(0.06)]
        case .danger: return [Color(hex: "#FF3B30"), Color(hex: "#C0392B")]
        case .ghost: return [Color.clear, Color.clear]
        }
    }

    var textColor: Color {
        switch style {
        case .ghost: return vm.currentTheme.primaryColor
        default: return .white
        }
    }

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.15, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.2)) {
                    isPressed = false
                }
            }
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(style == .ghost ? vm.currentTheme.primaryColor.opacity(0.5) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .shadow(color: style == .primary ? vm.currentTheme.primaryColor.opacity(0.4) : .clear, radius: 8, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButtonHS(title: "Continue", icon: "arrow.right", action: {})
        CustomButtonHS(title: "Cancel", icon: nil, action: {}, style: .secondary)
        CustomButtonHS(title: "Danger", icon: "flame.fill", action: {}, style: .danger)
    }
    .padding()
    .background(Color(hex: "#0F0F12"))
    .environmentObject(ViewModelHS())
}
