import SwiftData
import SwiftUI

struct TrendsView: View {
    @Query(sort: \.startDate, order: .reverse) private var sessions: [FastingSession]

    var averageDuration: Double {
        let complete = sessions.filter(\.isComplete)
        guard !complete.isEmpty else { return 0 }
        let total = complete.map { $0.duration }.reduce(0, +)
        return total / Double(complete.count) / 3600
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressCard(
                title: "Average Fast",
                value: String(format: "%.1f h", averageDuration),
                detail: "Premium trends overview"
            )

            Text("More premium trend cards can be added here as the app grows.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Trends")
    }
}

#Preview {
    NavigationStack {
        TrendsView()
            .modelContainer(PreviewData.previewContainer)
    }
}
