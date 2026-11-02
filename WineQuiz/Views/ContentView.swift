import SwiftUI

private enum AppRoute: Hashable {
    case quiz(QuizMode)
}

struct ContentView: View {
    @State private var showSplash = true
    @State private var questions: [QuizQuestion] = []
    @State private var loadError: String?
    @State private var path: [AppRoute] = []
    @State private var store = GameStore(defaults: {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            let suite = "winequiz.ui-tests"
            let defaults = UserDefaults(suiteName: suite)!
            defaults.removePersistentDomain(forName: suite)
            return defaults
        }
        #endif
        return .standard
    }())

    var body: some View {
        if showSplash {
            SplashView(onFinish: {
                withAnimation(.easeOut(duration: 0.5)) { showSplash = false }
            })
        } else {
        NavigationStack(path: $path) {
            Group {
                if let loadError {
                    UnavailableView(message: loadError)
                } else if questions.isEmpty {
                    ProgressView("読み込み中")
                } else {
                    HomeView(
                        questionCount: questions.count,
                        reviewCount: store.reviewQuestions(from: questions).count,
                        startQuiz: { path.append(.quiz(.normal)) },
                        startReview: { path.append(.quiz(.review)) },
                        startDaily: { path.append(.quiz(.daily)) }
                    )
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case let .quiz(mode):
                    QuizView(session: makeSession(for: mode), mode: mode)
                }
            }
            .task {
                loadQuestionsIfNeeded()
            }
        }
        .environment(store)
        }
    }

    private func makeSession(for mode: QuizMode) -> QuizSession {
        switch mode {
        case .normal:
            return QuizSession(questions: questions)
        case .review:
            return QuizSession(questions: store.reviewQuestions(from: questions))
        case .daily:
            let daily = store.dailyQuestion(from: questions).map { [$0] } ?? []
            return QuizSession(questions: daily, questionLimit: 1, shuffle: false)
        }
    }

    private func loadQuestionsIfNeeded() {
        guard questions.isEmpty, loadError == nil else {
            return
        }

        do {
            questions = try QuestionRepository.loadQuestions()
        } catch {
            loadError = error.localizedDescription
        }
    }
}

#Preview {
    ContentView()
}
