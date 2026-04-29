import Foundation

enum PremiumFeature: String, CaseIterable, Identifiable {
    case customSchedules = "Custom schedules"
    case widgets = "Widgets"
    case trends = "Advanced trends"
    case themes = "Themes"

    var id: String { rawValue }
}
