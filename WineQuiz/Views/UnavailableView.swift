import SwiftUI

struct UnavailableView: View {
    let message: String

    var body: some View {
        ZStack {
            WineBackdrop()

            WinePanel {
                ContentUnavailableView(
                    "読み込めませんでした",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
                .foregroundStyle(WineTheme.plum)
            }
            .padding()
        }
    }
}
