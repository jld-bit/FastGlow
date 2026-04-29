import SwiftData
import SwiftUI

@main
struct FastGlowApp: App {
    @StateObject private var purchaseManager = PurchaseManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([FastingSession.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(purchaseManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
