import SwiftUI

struct ResultView: View {
    let session: QuizSession
    let restart: () -> Void
    let close: () -> Void
    var canRestart: Bool = true
    var isNewHighScore: Bool = false

    private var percentage: Int {
        guard !session.questions.isEmpty else {
            return 0
        }

        return Int((Double(session.score) / Double(session.questions.count) * 100).rounded())
    }

    private var shareText: String {
        "ワイン雑学クイズで \(session.score) / \(session.questions.count) 問正解！（正答率 \(percentage)%）🍷 #ワイン雑学クイズ"
    }

    var body: some View {
        ZStack {
            WineBackdrop()

            ScrollView {
                VStack(spacing: 22) {
                    WinePanel(cornerRadius: 28) {
                        VStack(spacing: 10) {
                            Text("\(session.score) / \(session.questions.count)")
                                .font(.system(size: 56, weight: .black, design: .rounded))
                                .foregroundStyle(WineTheme.plum)

                            Text("正答率 \(percentage)%")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(WineTheme.success)

                            if isNewHighScore {
                                Label("ハイスコア更新！", systemImage: "trophy.fill")
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(WineTheme.red)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }

                    VStack(spacing: 12) {
                        if canRestart {
                            Button(action: restart) {
                                Label("もう一度挑戦", systemImage: "arrow.clockwise")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(WinePrimaryButtonStyle())
                        }

                        ShareLink(item: shareText) {
                            Label("結果をシェア", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(WineSecondaryButtonStyle())

                        Button(action: close) {
                            Label("ホームに戻る", systemImage: "house.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(WineSecondaryButtonStyle())
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("解答履歴")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(WineTheme.plum)

                        ForEach(session.answerHistory) { answer in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(answer.isCorrect ? WineTheme.success : WineTheme.red)
                                    .padding(.top, 2)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(answer.question.question)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(WineTheme.plum)
                                    Text("あなたの答え: \(answer.selectedText)")
                                        .font(.caption)
                                        .foregroundStyle(WineTheme.plum.opacity(0.75))
                                    Text("正解: \(answer.question.correctChoice)").font(.caption.bold())
                                    Text(answer.question.trivia).font(.caption)
                                    if let title = answer.question.sourceTitle, let address = answer.question.sourceURL,
                                       let url = URL(string: address) {
                                        Link(title, destination: url).font(.caption)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(18)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("結果")
        .navigationBarBackButtonHidden()
    }
}
