import SwiftUI

struct InfernoBackgroundHS: View {
    @EnvironmentObject var vm: ViewModelHS

    var body: some View {
        LinearGradient(
            colors: vm.currentTheme.gradient,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    InfernoBackgroundHS()
        .environmentObject(ViewModelHS())
}
