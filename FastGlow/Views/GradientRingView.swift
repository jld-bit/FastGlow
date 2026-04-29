import SwiftUI

struct GradientRingView: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.15), lineWidth: 18)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [.pink, .purple, .blue, .mint, .pink],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}

#Preview {
    GradientRingView(progress: 0.72)
        .frame(width: 220, height: 220)
        .padding()
        .background(Color.black)
}
