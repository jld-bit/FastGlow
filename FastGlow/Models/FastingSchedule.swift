import Foundation

enum FastingSchedule: Equatable, Identifiable, CaseIterable {
    case schedule12
    case schedule14
    case schedule16
    case custom(fastingHours: Double, eatingHours: Double)

    var id: String { title }

    var fastingHours: Double {
        switch self {
        case .schedule12: return 12
        case .schedule14: return 14
        case .schedule16: return 16
        case let .custom(fastingHours, _): return fastingHours
        }
    }

    var eatingHours: Double {
        switch self {
        case .schedule12: return 12
        case .schedule14: return 10
        case .schedule16: return 8
        case let .custom(_, eatingHours): return eatingHours
        }
    }

    var title: String {
        "\(Int(fastingHours)):\(Int(eatingHours))"
    }

    static var defaults: [FastingSchedule] {
        [.schedule12, .schedule14, .schedule16]
    }

    static var allCases: [FastingSchedule] {
        defaults
    }
}
