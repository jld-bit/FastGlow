import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("FastGlow Premium")
                    .font(.largeTitle.bold())
                Text("Unlock deeper insights and personalization while keeping a clean, original FastGlow experience.")
                    .foregroundStyle(.secondary)

                ForEach(PremiumFeature.allCases) { feature in
                    Label(feature.rawValue, systemImage: "star.fill")
                        .font(.headline)
                        .foregroundStyle(.purple)
                }

                Spacer()

                Button {
                    Task { await purchaseManager.purchasePremium() }
                } label: {
                    Text(purchaseManager.premiumProduct?.displayPrice ?? "Try Premium")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)

                Button("Not now") { dismiss() }
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .navigationTitle("Upgrade")
            .task {
                await purchaseManager.bootstrap()
            }
        }
    }
}

#Preview {
    PaywallView()
        .environmentObject(PurchaseManager())
}
