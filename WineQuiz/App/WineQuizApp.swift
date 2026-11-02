import GoogleMobileAds
import SwiftUI

@main
struct WineQuizApp: App {
    @State private var adsPrivacy = AdsPrivacyController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(WineTheme.red)
                .preferredColorScheme(.light)
                .environment(adsPrivacy)
                .task { await adsPrivacy.prepare() }
        }
    }
}
