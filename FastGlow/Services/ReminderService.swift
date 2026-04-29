import Foundation
import UserNotifications

@MainActor
final class ReminderService {
    static let shared = ReminderService()

    private init() {}

    func requestPermission() async {
        do {
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("Failed to request notification permission: \(error)")
        }
    }

    func scheduleReminders(for session: FastingSession) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let startReminder = UNMutableNotificationContent()
        startReminder.title = "Eating window open"
        startReminder.body = "Great job fasting! Time to refuel."

        let endReminder = UNMutableNotificationContent()
        endReminder.title = "Fasting window starts"
        endReminder.body = "Ready for your next FastGlow session?"

        let fastingEndDate = session.startDate.addingTimeInterval(session.scheduleFastingHours * 3600)
        let eatingEndDate = fastingEndDate.addingTimeInterval(session.scheduleEatingHours * 3600)

        let fastingTrigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(5, fastingEndDate.timeIntervalSinceNow),
            repeats: false
        )

        let eatingTrigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(10, eatingEndDate.timeIntervalSinceNow),
            repeats: false
        )

        let fastingRequest = UNNotificationRequest(identifier: "fasting-end", content: startReminder, trigger: fastingTrigger)
        let eatingRequest = UNNotificationRequest(identifier: "eating-end", content: endReminder, trigger: eatingTrigger)

        UNUserNotificationCenter.current().add(fastingRequest)
        UNUserNotificationCenter.current().add(eatingRequest)
    }
}
