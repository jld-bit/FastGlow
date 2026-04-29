import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Query(sort: \.startDate, order: .reverse) private var sessions: [FastingSession]

    @StateObject private var viewModel = FastingViewModel()
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    timerSection
                    scheduleSection
                    cardsSection
                }
                .padding()
            }
            .background(backgroundGradient)
            .navigationTitle("FastGlow")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Premium") {
                        showPaywall = true
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(purchaseManager)
            }
        }
        .task {
            await ReminderService.shared.requestPermission()
            viewModel.bootstrap(with: sessions)
        }
    }

    private var timerSection: some View {
        VStack(spacing: 18) {
            ZStack {
                GradientRingView(progress: viewModel.fastingProgress)
                    .frame(width: 240, height: 240)

                VStack(spacing: 6) {
                    Text(viewModel.activeSession == nil ? "Ready to start" : "Fasting")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(viewModel.formattedElapsed)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
            }

            Button(viewModel.activeSession == nil ? "Start Fasting" : "End Fasting") {
                if viewModel.activeSession == nil {
                    viewModel.startFasting(context: modelContext)
                } else {
                    viewModel.endFasting(context: modelContext)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .controlSize(.large)
        }
    }

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedules")
                .font(.headline)

            Picker("Schedule", selection: $viewModel.selectedSchedule) {
                ForEach(FastingSchedule.defaults) { schedule in
                    Text(schedule.title).tag(schedule)
                }
                Text("Custom").tag(FastingSchedule.custom(fastingHours: 16, eatingHours: 8))
            }
            .pickerStyle(.segmented)

            if case .custom = viewModel.selectedSchedule {
                if purchaseManager.isPremiumUnlocked {
                    VStack(alignment: .leading) {
                        Text("Custom fasting: \(Int(viewModel.customFastingHours))h")
                        Slider(value: $viewModel.customFastingHours, in: 10...22, step: 1)
                        Text("Custom eating: \(Int(viewModel.customEatingHours))h")
                        Slider(value: $viewModel.customEatingHours, in: 2...12, step: 1)
                    }
                } else {
                    Button("Unlock Premium for Custom Schedules") {
                        showPaywall = true
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.thinMaterial)
        )
    }

    private var cardsSection: some View {
        let streak = viewModel.dailyStreak(from: sessions)

        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                ProgressCard(
                    title: "Current Fast",
                    value: String(format: "%.1f h", viewModel.currentFastingHours()),
                    detail: viewModel.eatingWindowText
                )
                ProgressCard(
                    title: "Daily Streak",
                    value: "\(streak) days",
                    detail: streak > 0 ? "Consistency streak" : "Start today"
                )
            }

            NavigationLink {
                HistoryView()
            } label: {
                Text("View History")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)

            if purchaseManager.isPremiumUnlocked {
                NavigationLink("View Premium Trends") {
                    TrendsView()
                }
                .font(.headline)
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.indigo.opacity(0.8), .purple.opacity(0.75), .cyan.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
        .modelContainer(PreviewData.previewContainer)
        .environmentObject(PurchaseManager())
}
