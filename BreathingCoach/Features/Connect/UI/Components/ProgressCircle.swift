import SwiftUI

struct ProgressCircle: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let angle = timeline.date.timeIntervalSinceReferenceDate * 300 // degrees/sec

            ZStack {
                Circle()
                    .strokeBorder(.gray, lineWidth: 3)

                Circle()
                    .inset(by: 1.5)
                    .trim(from: 0, to: 0.2)
                    .stroke(
                        Color.bcAccent,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}

#Preview {
    ProgressCircle()
        .padding()
}
