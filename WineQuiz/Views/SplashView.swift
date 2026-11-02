import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void
    var body: some View {
        ZStack {
            WineTheme.red.ignoresSafeArea()
            VStack(spacing: 24) {
                WineGlassMark().frame(width: 120, height: 150)
                Text("ワイン雑学クイズ").font(.title.bold()).foregroundStyle(WineTheme.ivory)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(650))
            guard !Task.isCancelled else { return }
            onFinish()
        }
    }
}
