import Foundation
import SwiftData

enum PreviewData {
    static var previewContainer: ModelContainer {
        let schema = Schema([FastingSession.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])

        let context = container.mainContext
        let now = Date()

        let samples = [
            FastingSession(
                startDate: Calendar.current.date(byAdding: .hour, value: -18, to: now)!,
                endDate: Calendar.current.date(byAdding: .hour, value: -2, to: now)!,
                scheduleFastingHours: 16,
                scheduleEatingHours: 8
            ),
            FastingSession(
                startDate: Calendar.current.date(byAdding: .day, value: -1, to: now)!,
                endDate: Calendar.current.date(byAdding: .hour, value: -12, to: now)!,
                scheduleFastingHours: 14,
                scheduleEatingHours: 10
            ),
            FastingSession(
                startDate: Calendar.current.date(byAdding: .day, value: -2, to: now)!,
                endDate: Calendar.current.date(byAdding: .hour, value: -40, to: now)!,
                scheduleFastingHours: 12,
                scheduleEatingHours: 12
            )
        ]

        samples.forEach { context.insert($0) }
        return container
    }
}
