import Foundation

struct FastingWidgetSnapshot: Codable {
    let isFasting: Bool
    let elapsedTime: TimeInterval
    let fastingGoal: TimeInterval
    let lastUpdated: Date

    static let empty = FastingWidgetSnapshot(
        isFasting: false,
        elapsedTime: 0,
        fastingGoal: 16 * 3600,
        lastUpdated: Date()
    )
}

protocol WidgetSnapshotProviding {
    func loadSnapshot() -> FastingWidgetSnapshot
}

struct DefaultWidgetSnapshotProvider: WidgetSnapshotProviding {
    func loadSnapshot() -> FastingWidgetSnapshot {
        .empty
    }
}
