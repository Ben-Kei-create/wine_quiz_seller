# 検証記録

検証日：2026年11月2日。

## 環境と構成

- Xcode 27.2 (27B52)
- Deployment Target：iOS 17.0、Swift language mode：5.0
- Google Mobile Ads SDK：13.3.0、Google User Messaging Platform：3.1.0（Package.resolved固定）
- アプリ／テストターゲット：WineQuiz、WineQuizTests、WineQuizUITests
- Bundle ID：io.github.benkeicreate.winequiz
- Debug／Release：バージョン1.0.0、ビルド番号1、Google公式のテスト広告IDのみ

## 機能テスト

単体テスト15件は、125問の読み込み・難易度配分・4択・出典URL・重複の排除・10問抽出・難易度別制限時間・採点・連打防止・誤答と時間切れの復習保存・正解時の復習解除・永続化・ハイスコア・日替わり出題・リセット・ビール版保存キーとの分離を確認します。

UIテスト2件は、通常10問→結果→共有画面→ホーム→復習、および今日の1問→完了→ホームで挑戦済み表示→設定→バージョン→プライバシー説明を確認します。共有画面は開閉までで、実際の送信は行いません。

| 最終実行端末 | OS | 単体 | UI | 結果 |
|---|---|---:|---:|---|
| iPhone 18 Pro Simulator | iOS 27.0 | 15件 | 2件 | 全17件成功 |
| iPad Pro 11-inch (M5) Simulator | iOS 27.0 | 15件 | 2件 | 全17件成功 |

17種類のテストを各端末で実行し、合計34回成功・失敗0件。`WineQuiz-final.xcresult`で両端末の結果を確認済みです。テスト後の最新問題データでReleaseビルドも成功しました。

## ビルド・データ検証

- Releaseのgeneric iOSデバイス向けビルド：成功（CODE_SIGNING_ALLOWED=NO）
- Debug／Releaseの生成app双方でBundle ID、バージョン、125問の同梱と最新データとの一致、PrivacyInfo.xcprivacyの同梱を確認
- アイコン：1024×1024、アルファチャンネルなし
- Info.plist／PrivacyInfo.xcprivacy／project.pbxproj：plutil構文検証成功
- 125問すべてに日本語の問題・正解・解説、相異なる4択、出典タイトル・HTTPS URLを確認
- 問題の確認記録に125行あることを確認
- Google公式ガイドに合わせてSKAdNetwork IDリストを更新
- 参照元BeerQuizSwiftの開始時ハッシュと照合し、元ファイルの変更なしを確認

実機向けビルドは署名なしのコンパイル確認です。物理端末へのインストールとApp Store提出は行っていません。実広告へ切り替えるまではテスト広告設定を維持してください。

## 外部SDKの警告

Releaseビルドでは、GoogleMobileAds 13.3.0のumbrella headerに一部Betaヘッダーが含まれない旨の警告が出ます。ビルドは成功し、アプリ側のコンパイルエラーはありません。AppIntentsを使用しないため、メタデータ抽出スキップの警告も出ます。

## 証跡

シミュレーター画面は`Documentation/Screenshots/`、xcresultとビルドログはGit対象外の`.build/Validation/`に保存します。検証用の初期成績は専用UserDefaultsスイートに隔離し、通常起動時の成績とは分離しています。
