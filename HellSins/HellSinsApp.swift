import SwiftUI

@main
struct HellSinsApp: App {
    var body: some Scene {
        WindowGroup {
            MainViewHS()
                .environmentObject(ViewModelHS())
                .environmentObject(StoreManagerHS())
        }
    }
}
