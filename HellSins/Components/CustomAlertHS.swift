import SwiftUI

struct CustomAlertHS: Identifiable {
    let id = UUID()
    let title: String
    let message: String

    struct AlertButtonHS {
        let title: String
        var isPrimary: Bool = false
        var action: () -> Void = {}
    }

    let primaryButton: AlertButtonHS
    let secondaryButton: AlertButtonHS?
}

struct CustomAlertModifierHS: ViewModifier {
    @Binding var isPresented: Bool
    let alert: CustomAlertHS

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {}

                alertPanel
                    .transition(.scale(scale: 0.88).combined(with: .opacity))
                    .zIndex(999)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isPresented)
    }

    private var alertPanel: some View {
        VStack(spacing: 0) {
            VStack(spacing: 14) {
                Image(systemName: iconName)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .top, endPoint: .bottom))

                Text(alert.title)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(alert.message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 24)

            Divider().background(Color.white.opacity(0.08))

            if let secondary = alert.secondaryButton {
                HStack(spacing: 0) {
                    Button {
                        withAnimation { isPresented = false }
                        secondary.action()
                    } label: {
                        Text(secondary.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white.opacity(0.45))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Divider().background(Color.white.opacity(0.08)).frame(width: 0.5, height: 52)

                    Button {
                        withAnimation { isPresented = false }
                        alert.primaryButton.action()
                    } label: {
                        Text(alert.primaryButton.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .leading, endPoint: .trailing))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                Button {
                    withAnimation { isPresented = false }
                    alert.primaryButton.action()
                } label: {
                    Text(alert.primaryButton.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .leading, endPoint: .trailing))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "#1A1A20"))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 0.8))
        )
        .shadow(color: Color.black.opacity(0.5), radius: 30, y: 10)
        .padding(.horizontal, 32)
    }

    private var iconName: String {
        let t = alert.title.lowercased()
        if t.contains("success") || t.contains("unlock") || t.contains("restored") { return "checkmark.circle.fill" }
        if t.contains("fail") || t.contains("error") { return "xmark.circle.fill" }
        if t.contains("pending") { return "clock.fill" }
        if t.contains("confirm") || t.contains("purchase") { return "crown.fill" }
        return "flame.fill"
    }
}

extension View {
    func hellAlert(isPresented: Binding<Bool>, alert: CustomAlertHS) -> some View {
        modifier(CustomAlertModifierHS(isPresented: isPresented, alert: alert))
    }
}
