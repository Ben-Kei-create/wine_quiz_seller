# ワイン雑学クイズ 1.0.0

SwiftUI製のiOSアプリです。ビール版の4択・10問・制限時間・解説・復習・成績保存の構成を引き継ぎ、独立したワインアプリとして実装しました。

## 開く

`WineQuiz.xcodeproj` をXcodeで開き、`WineQuiz` schemeを選んで実行してください。初回はSwift Package ManagerがGoogle Mobile Ads SDKを取得します。

- iOS 17.0以降、iPhone／iPad
- アプリ名：ワイン雑学クイズ
- ターゲット／モジュール：WineQuiz
- Bundle ID：`com.fumiaki.wineryQuiz`
- バージョン：1.0.0、ビルド番号：1
- 保存キー：`winequiz.` 接頭辞。ビール版の保存データは読み込みません。

実機で実行する際はSigning & Capabilitiesで利用する開発チームと署名を設定してください。プロジェクトは参照元で使われている開発チーム設定を引き継いでいます。

## 機能

- 通常モード：125問からランダムに重複なしの10問。初級25秒・中級20秒・上級18秒。アプリが非アクティブの間はタイマーを停止。
- 復習モード：間違えた問題・時間切れを保存し、1回最大10問。正解した問題は復習対象から外れます。
- 今日の1問：端末の暦日で毎日更新。同じ日は同じ問題で、解答後は挑戦済みになります。
- 成績：ハイスコア、累計正答数・解答数、通常モード完了回数を端末内に保存。
- 結果：解答履歴・正解・解説・資料リンク、OSの共有画面による結果シェア。
- 設定：効果音・触覚、確認付きの成績リセット、プライバシー説明。

リセットすると成績・復習対象・今日の挑戦状況を消去します。サウンド設定は維持します。通常モードの「もう一度挑戦」は同じ10問を並べ替えて再挑戦します。新しい10問を選ぶ場合はホームから開始します。

## 問題と資料

日本語125問（初級45・中級45・上級35）。各問に4択・正解・解説・出典タイトル・HTTPSの出典URLを格納しています。

- [全125問の正解と確認資料](Documentation/QUESTION_VERIFICATION.md)
- [資料一覧と確認日](Documentation/sources.json)
- 問題本体：`WineQuiz/Resources/wine_quiz.json`

WSET・Comité Champagne・BIVB・各産地公式団体・大学・国税庁などの資料を2026年11月2日に確認しました。法定期間などの数値は規則本文を優先しています。問題はオリジナルの文章であり、各団体の公式試験問題や監修を意味しません。

## デザイン

提供されたhome-3案を基調に、バーガンディ・アイボリー・淡いローズ・ゴールドで構成。ホームの文字・ボタンはネイティブSwiftUI、グラスはCanvasで描画しています。アプリアイコンは提供素材の`Design/wine-icon-1024.png`を使用。スクリーン画像をUIとして貼り込んでいません。

## 広告

DebugはGoogle公式のテストバナー、Releaseはワイン版専用の本番バナーを使用します。UMPの同意メッセージに対応するため、アプリIDは両構成ともワイン版です。

起動時にUMPで同意情報を更新し、必要なフォームを表示します。`canRequestAds` が有効な場合だけSDKを開始して広告を要求します。必要な場合は設定から広告の選択を変更できます。通信失敗時もクイズは利用できます。

広告のパーソナライズとPublisher First-Party IDを無効にし、各リクエストで非パーソナライズ広告を指定します。ATTは要求しません。AdMob管理画面のメッセージ設定と実機での同意・拒否・変更・広告表示の確認、App Storeのプライバシー申告との照合は公開前に本人が実施してください。非パーソナライズ広告でもSDKの通信やデータ処理は発生します。

## ビルドとテスト

```sh
xcodebuild test -project WineQuiz.xcodeproj -scheme WineQuiz \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro,OS=27.0' \
  -derivedDataPath .build CODE_SIGNING_ALLOWED=NO

xcodebuild build -project WineQuiz.xcodeproj -scheme WineQuiz \
  -configuration Release -destination 'generic/platform=iOS' \
  -derivedDataPath .buildRelease CODE_SIGNING_ALLOWED=NO
```

`project.yml`は再生成用の設定です。通常は同梱のXcodeプロジェクトをそのまま利用できます。

[検証結果](Documentation/VALIDATION.md)に実行環境・テスト結果を記載しています。自動UIテストは専用UserDefaultsスイートを使用し、通常利用の成績を変更しません。
