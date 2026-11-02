import SwiftUI

enum WineTheme {
    static let red = Color(red: 0.529, green: 0.176, blue: 0.275)
    static let plum = Color(red: 0.239, green: 0.137, blue: 0.188)
    static let ivory = Color(red: 1, green: 0.976, blue: 0.933)
    static let rose = Color(red: 0.953, green: 0.898, blue: 0.910)
    static let gold = Color(red: 0.776, green: 0.631, blue: 0.420)
    static let success = Color(red: 0.21, green: 0.40, blue: 0.34)
}

struct WineBackdrop: View {
    var body: some View { WineTheme.ivory.ignoresSafeArea() }
}

struct WinePanel<Content: View>: View {
    var cornerRadius: CGFloat = 20
    @ViewBuilder let content: () -> Content
    var body: some View {
        content().padding(18)
            .background(.white.opacity(0.85), in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay { RoundedRectangle(cornerRadius: cornerRadius).stroke(WineTheme.rose, lineWidth: 1) }
    }
}

struct WineChip: View {
    let title: String
    let color: Color
    var body: some View {
        Text(title).font(.caption.bold()).foregroundStyle(WineTheme.plum)
            .padding(.horizontal, 13).padding(.vertical, 8)
            .background(color.opacity(0.2), in: Capsule())
    }
}

struct WinePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline.bold()).foregroundStyle(.white)
            .padding(.horizontal, 20).padding(.vertical, 18).frame(minHeight: 56)
            .background(WineTheme.red, in: RoundedRectangle(cornerRadius: 20))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct WineSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).foregroundStyle(WineTheme.red)
            .padding(.horizontal, 18).padding(.vertical, 16).frame(minHeight: 52)
            .background(WineTheme.rose, in: RoundedRectangle(cornerRadius: 20))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct WineGlassMark: View {
    var body: some View {
        Canvas { context, size in
            let transform = CGAffineTransform(scaleX: size.width / 120, y: size.height / 150)
            var bowl = Path()
            bowl.move(to: CGPoint(x: 22, y: 6))
            bowl.addQuadCurve(to: CGPoint(x: 98, y: 6), control: CGPoint(x: 60, y: 4))
            bowl.addCurve(to: CGPoint(x: 60, y: 108), control1: CGPoint(x: 130, y: 67), control2: CGPoint(x: 112, y: 103))
            bowl.addCurve(to: CGPoint(x: 22, y: 6), control1: CGPoint(x: 8, y: 103), control2: CGPoint(x: -10, y: 67))
            context.fill(bowl.applying(transform), with: .color(WineTheme.ivory))
            var wine = Path()
            wine.move(to: CGPoint(x: 12, y: 49))
            wine.addCurve(to: CGPoint(x: 108, y: 43), control1: CGPoint(x: 51, y: 68), control2: CGPoint(x: 70, y: 27))
            wine.addCurve(to: CGPoint(x: 60, y: 106), control1: CGPoint(x: 119, y: 87), control2: CGPoint(x: 91, y: 106))
            wine.addCurve(to: CGPoint(x: 12, y: 49), control1: CGPoint(x: 24, y: 106), control2: CGPoint(x: 4, y: 83))
            context.fill(wine.applying(transform), with: .color(WineTheme.red))
            var facet = Path()
            facet.move(to: CGPoint(x: 89, y: 40))
            facet.addQuadCurve(to: CGPoint(x: 108, y: 43), control: CGPoint(x: 100, y: 40))
            facet.addCurve(to: CGPoint(x: 60, y: 106), control1: CGPoint(x: 119, y: 87), control2: CGPoint(x: 91, y: 106))
            facet.addQuadCurve(to: CGPoint(x: 89, y: 40), control: CGPoint(x: 73, y: 100))
            context.fill(facet.applying(transform), with: .color(WineTheme.plum.opacity(0.65)))
            var stem = Path(roundedRect: CGRect(x: 54, y: 103, width: 12, height: 32), cornerRadius: 5)
            stem.addEllipse(in: CGRect(x: 27, y: 131, width: 66, height: 12))
            context.fill(stem.applying(transform), with: .color(WineTheme.ivory))
        }.accessibilityHidden(true)
    }
}
