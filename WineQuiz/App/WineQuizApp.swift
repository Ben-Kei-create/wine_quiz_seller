import GoogleMobileAds
import SwiftUI

@main
struct WineQuizApp: App {
    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(WineTheme.red)
                .preferredColorScheme(.light)
        }
    }
}
