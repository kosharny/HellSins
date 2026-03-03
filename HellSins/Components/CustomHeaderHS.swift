import SwiftUI

struct CustomHeaderHS: View {
    let title: String
    var showSettings: Bool = true
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, vm.currentTheme.primaryColor.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Spacer()

            if showSettings {
                Button {
                    path.append(NavigationDestinationHS.settings)
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(vm.currentTheme.primaryColor.opacity(0.35), lineWidth: 1)
                            )
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

#Preview {
    CustomHeaderHS(title: "Inferno", path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
        .background(Color(hex: "#0F0F12"))
}
