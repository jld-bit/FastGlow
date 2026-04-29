import Foundation
import SwiftData
import SwiftUI

@MainActor
final class FastingViewModel: ObservableObject {
    @Published var selectedSchedule: FastingSchedule = .schedule16
    @Published var customFastingHours: Double = 16
    @Published var customEatingHours: Double = 8
    @Published private(set) var activeSession: FastingSession?
    @Published private(set) var elapsedTime: TimeInterval = 0

    private var timer: Timer?
    private let reminderService = ReminderService.shared

    var fastingHours: Double {
        scheduleInUse.fastingHours
    }

    var eatingHours: Double {
        scheduleInUse.eatingHours
    }

    var scheduleInUse: FastingSchedule {
        if case .custom = selectedSchedule {
            return .custom(fastingHours: customFastingHours, eatingHours: customEatingHours)
        }
        return selectedSchedule
    }

    var fastingProgress: Double {
        min(elapsedTime / (fastingHours * 3600), 1)
    }

    var formattedElapsed: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }

    var eatingWindowText: String {
        "\(Int(eatingHours)) hour eating window"
    }

    func bootstrap(with sessions: [FastingSession]) {
        activeSession = sessions.first(where: { !$0.isComplete })
        if let activeSession {
            elapsedTime = Date().timeIntervalSince(activeSession.startDate)
        }
        startTimerIfNeeded()
    }

    func startFasting(context: ModelContext) {
        let schedule = scheduleInUse
        let newSession = FastingSession(
            startDate: Date(),
            scheduleFastingHours: schedule.fastingHours,
            scheduleEatingHours: schedule.eatingHours
        )
        context.insert(newSession)
        activeSession = newSession
        elapsedTime = 0
        startTimerIfNeeded()
        reminderService.scheduleReminders(for: newSession)
    }

    func endFasting(context: ModelContext) {
        guard let activeSession else { return }
        activeSession.endDate = Date()
        elapsedTime = activeSession.duration
        self.activeSession = nil
        timer?.invalidate()
        timer = nil
    }

    func currentFastingHours() -> Double {
        elapsedTime / 3600
    }

    func dailyStreak(from sessions: [FastingSession]) -> Int {
        let calendar = Calendar.current
        let completeDays = Set(
            sessions
                .filter(\.isComplete)
                .map { calendar.startOfDay(for: $0.startDate) }
        )

        var streak = 0
        var cursor = calendar.startOfDay(for: Date())

        while completeDays.contains(cursor) {
            streak += 1
            guard let prior = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prior
        }

        return streak
    }

    private func startTimerIfNeeded() {
        timer?.invalidate()
        guard let activeSession else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime = Date().timeIntervalSince(activeSession.startDate)
        }
    }
}
