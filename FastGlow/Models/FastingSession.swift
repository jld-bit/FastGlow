import Foundation
import SwiftData

@Model
final class FastingSession {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var scheduleFastingHours: Double
    var scheduleEatingHours: Double

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date? = nil,
        scheduleFastingHours: Double,
        scheduleEatingHours: Double
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.scheduleFastingHours = scheduleFastingHours
        self.scheduleEatingHours = scheduleEatingHours
    }

    var duration: TimeInterval {
        (endDate ?? Date()).timeIntervalSince(startDate)
    }

    var isComplete: Bool {
        endDate != nil
    }

    var dayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: startDate)
    }
}
