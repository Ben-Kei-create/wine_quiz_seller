import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GameStore.self) private var store

    @AppStorage(SoundPlayer.soundEnabledKey) private var soundEnabled = true
    @AppStorage(SoundPlayer.hapticsEnabledKey) private var hapticsEnabled = true
    @State private var showResetConfirmation = false

    private var versionText: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("サウンド") {
                    Toggle("効果音", isOn: $soundEnabled)
                    Toggle("触覚フィードバック", isOn: $hapticsEnabled)
                }

                Section("成績") {
                    Button("成績をリセット", role: .destructive) {
                        showResetConfirmation = true
                    }
                }

                Section("アプリについて") {
                    LabeledContent("バージョン", value: versionText)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("バージョン")
                        .accessibilityValue(versionText)
                        .accessibilityIdentifier("app_version")
                    NavigationLink("プライバシーポリシー") { PrivacyView() }
                    Text("お酒は20歳になってから。")
                        .font(.caption)

                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") { dismiss() }
                }
            }
            .confirmationDialog("ハイスコア・累計成績・復習リスト・今日の挑戦状況を消去します。", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                Button("リセットする", role: .destructive) {
                    store.resetStats()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(GameStore())
}

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("ワイン雑学クイズ").font(.title2.bold())
                Text("成績・復習対象・今日の挑戦状況・効果音と触覚の設定は端末内に保存します。アプリ独自のサーバーへの送信やアカウント登録はありません。成績は設定からリセットできます。")
                Text("広告にはGoogle Mobile Ads SDKを利用しています。現在はGoogle公式のテスト広告のみを使用します。SDKは広告の取得や不正防止のため、IPアドレス、端末情報、診断情報などをGoogleへ送信することがあります。")
                Link("Googleのプライバシーポリシー", destination: URL(string: "https://policies.google.com/privacy")!)
                Text("結果のシェアは操作したときだけ共有画面を開きます。送信先と送信内容は共有画面で選択できます。出典リンクは外部サイトを開きます。")
                Text("最終更新：2026年11月2日").font(.caption)
            }.padding(24)
        }.navigationTitle("プライバシー").navigationBarTitleDisplayMode(.inline)
    }
}
