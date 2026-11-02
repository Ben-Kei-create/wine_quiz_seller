import Foundation
import Observation

@Observable
final class GameStore {
    private enum Key {
        static let highScore = "winequiz.highScore"
        static let totalCorrect = "winequiz.totalCorrect"
        static let totalAnswered = "winequiz.totalAnswered"
        static let gamesPlayed = "winequiz.gamesPlayed"
        static let wrongQuestionIDs = "winequiz.wrongQuestionIDs"
        static let lastDailyDate = "winequiz.lastDailyDate"
    }

    @ObservationIgnored private let defaults: UserDefaults

    private(set) var highScore: Int
    private(set) var totalCorrect: Int
    private(set) var totalAnswered: Int
    private(set) var gamesPlayed: Int
    private(set) var wrongQuestionIDs: [String]
    private(set) var lastDailyDate: String?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        highScore = defaults.integer(forKey: Key.highScore)
        totalCorrect = defaults.integer(forKey: Key.totalCorrect)
        totalAnswered = defaults.integer(forKey: Key.totalAnswered)
        gamesPlayed = defaults.integer(forKey: Key.gamesPlayed)
        wrongQuestionIDs = defaults.stringArray(forKey: Key.wrongQuestionIDs) ?? []
        lastDailyDate = defaults.string(forKey: Key.lastDailyDate)
    }

    var accuracyPercent: Int? {
        guard totalAnswered > 0 else {
            return nil
        }

        return Int((Double(totalCorrect) / Double(totalAnswered) * 100).rounded())
    }

    // MARK: - Answers and games

    func recordAnswer(_ record: AnswerRecord) {
        let id = record.question.id
        totalAnswered += 1

        if record.isCorrect {
            totalCorrect += 1
            wrongQuestionIDs.removeAll { $0 == id }
        } else if !wrongQuestionIDs.contains(id) {
            wrongQuestionIDs.append(id)
        }

        defaults.set(totalAnswered, forKey: Key.totalAnswered)
        defaults.set(totalCorrect, forKey: Key.totalCorrect)
        defaults.set(wrongQuestionIDs, forKey: Key.wrongQuestionIDs)
    }

    /// 通常モードの1回分が終わったときに呼ぶ。ハイスコアを更新したら true。
    @discardableResult
    func recordGameFinished(score: Int) -> Bool {
        gamesPlayed += 1
        defaults.set(gamesPlayed, forKey: Key.gamesPlayed)

        guard score > highScore else {
            return false
        }

        highScore = score
        defaults.set(highScore, forKey: Key.highScore)
        return true
    }

    func resetStats() {
        highScore = 0
        totalCorrect = 0
        totalAnswered = 0
        gamesPlayed = 0
        wrongQuestionIDs = []
        lastDailyDate = nil

        for key in [Key.highScore, Key.totalCorrect, Key.totalAnswered, Key.gamesPlayed, Key.wrongQuestionIDs, Key.lastDailyDate] {
            defaults.removeObject(forKey: key)
        }
    }

    // MARK: - Review

    func reviewQuestions(from questions: [QuizQuestion]) -> [QuizQuestion] {
        questions.filter { wrongQuestionIDs.contains($0.id) }
    }

    // MARK: - Daily

    func dailyQuestion(from questions: [QuizQuestion], on date: Date = .now) -> QuizQuestion? {
        guard !questions.isEmpty else {
            return nil
        }

        let calendar = Calendar.current
        let epoch = calendar.startOfDay(for: Date(timeIntervalSinceReferenceDate: 0))
        let dayNumber = calendar.dateComponents([.day], from: epoch, to: calendar.startOfDay(for: date)).day ?? 0
        let index = ((dayNumber % questions.count) + questions.count) % questions.count
        return questions[index]
    }

    func isDailyCompleted(on date: Date = .now) -> Bool {
        lastDailyDate == Self.dayKey(for: date)
    }

    func recordDailyCompleted(on date: Date = .now) {
        lastDailyDate = Self.dayKey(for: date)
        defaults.set(lastDailyDate, forKey: Key.lastDailyDate)
    }

    private static func dayKey(for date: Date) -> String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }
}
