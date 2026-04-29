import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \.startDate, order: .reverse) private var sessions: [FastingSession]

    var body: some View {
        List {
            ForEach(sessions) { session in
                VStack(alignment: .leading, spacing: 6) {
                    Text(session.startDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.headline)
                    Text(session.endDate == nil ? "In progress" : "Ended: \(session.endDate!.formatted(date: .omitted, time: .shortened))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(String(format: "Duration: %.1f hours", session.duration / 3600))
                        .font(.footnote)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
            .modelContainer(PreviewData.previewContainer)
    }
}
