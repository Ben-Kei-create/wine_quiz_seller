import SwiftUI

struct HomeView: View {
    let questionCount: Int
    let reviewCount: Int
    let startQuiz: () -> Void
    let startReview: () -> Void
    let startDaily: () -> Void
    @Environment(GameStore.self) private var store
    @Environment(\.scenePhase) private var scenePhase
    @State private var showSettings = false
    @State private var today = Date.now
    private var dailyCompleted: Bool { store.isDailyCompleted(on: today) }

    var body: some View {
        ZStack(alignment: .top) {
            WineBackdrop()
            WineTheme.red.frame(height: 240)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    hero
                    VStack(alignment: .leading, spacing: 24) {
                        stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("次の10問に挑戦").font(.largeTitle.bold())
                            Text("品種も産地も、クイズで楽しく。")
                                .font(.subheadline).foregroundStyle(WineTheme.plum.opacity(0.7))
                        }
                        Button(action: startQuiz) {
                            HStack { Text("クイズをはじめる"); Spacer(); Image(systemName: "chevron.right") }
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(WinePrimaryButtonStyle()).accessibilityIdentifier("start_quiz_button")
                        VStack(spacing: 0) {
                            Divider()
                            menuRow(title: dailyCompleted ? "今日の1問（挑戦済み）" : "今日の1問",
                                    subtitle: dailyCompleted ? "また明日、新しい知識に出会おう。" : "毎日1問、ワインの知識を深めよう。",
                                    symbol: dailyCompleted ? "checkmark" : "text.book.closed",
                                    enabled: !dailyCompleted, action: startDaily)
                                .accessibilityIdentifier("daily_quiz_button")
                            Divider()
                            menuRow(title: reviewCount > 0 ? "間違えた問題を復習（\(reviewCount)問）" : "間違えた問題を復習",
                                    subtitle: reviewCount > 0 ? "苦手な問題をもう一度解こう。" : "間違えた問題がここに集まります。",
                                    symbol: "arrow.counterclockwise", enabled: reviewCount > 0, action: startReview)
                                .accessibilityIdentifier("review_quiz_button")
                            Divider()
                        }
                        Text("全\(questionCount)問 · 初級・中級・上級 · 1回10問")
                            .font(.caption).foregroundStyle(WineTheme.plum.opacity(0.7))
                            .frame(maxWidth: .infinity)
                        Text("お酒は20歳になってから。")
                            .font(.caption).foregroundStyle(WineTheme.plum.opacity(0.7))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(24).background(WineTheme.ivory)
                }
            }.scrollIndicators(.hidden)
        }
        .foregroundStyle(WineTheme.plum)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSettings) { SettingsView() }
        .onChange(of: scenePhase) { _, phase in if phase == .active { today = .now } }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { today = $0 }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("知るほど、おいしい。")
                    .font(.subheadline.weight(.semibold)).tracking(2)
                Spacer()
                Button { showSettings = true } label: {
                    Image(systemName: "gearshape").font(.title3)
                        .foregroundStyle(WineTheme.plum).frame(width: 44, height: 44)
                        .background(WineTheme.ivory, in: Circle())
                }.accessibilityLabel("設定").accessibilityIdentifier("settings_button")
            }
            Text("ワイン雑学クイズ")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text("ひとくちの知識が、\n次の一杯を豊かに。")
                    .font(.subheadline).lineSpacing(5)
                Spacer()
                WineGlassMark().frame(width: 94, height: 118)
            }
        }.foregroundStyle(WineTheme.ivory).padding(24)
            .background(WineTheme.red)
    }

    private var stats: some View {
        HStack(spacing: 16) {
            stat("ハイスコア", value: "\(store.highScore)/10", symbol: "trophy.fill")
            Divider()
            stat("累計正答率", value: store.accuracyPercent.map { "\($0)%" } ?? "—", symbol: "chart.bar.fill")
        }.fixedSize(horizontal: false, vertical: true).padding(.vertical, 8)
    }

    private func stat(_ title: String, value: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(title).foregroundStyle(WineTheme.plum.opacity(0.75))
            } icon: { Image(systemName: symbol).foregroundStyle(WineTheme.gold) }.font(.caption)
            Text(value).font(.system(.largeTitle, design: .rounded, weight: .bold)).monospacedDigit()
        }.frame(maxWidth: .infinity, alignment: .leading)
    }

    private func menuRow(title: String, subtitle: String, symbol: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: symbol).font(.title3).foregroundStyle(WineTheme.red)
                    .frame(width: 44, height: 44).background(WineTheme.rose, in: Circle())
                VStack(alignment: .leading, spacing: 6) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.caption).foregroundStyle(WineTheme.plum.opacity(0.7))
                }.frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right").foregroundStyle(WineTheme.red)
            }.padding(.vertical, 20).contentShape(Rectangle())
        }.buttonStyle(.plain).disabled(!enabled).opacity(enabled ? 1 : 0.65)
    }
}
