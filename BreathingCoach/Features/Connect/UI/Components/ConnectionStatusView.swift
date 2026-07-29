import SwiftUI

struct ConnectionStatusView: View {
    enum Status {
        case succeeded
        case failed
    }
    
    private let status: Status
    
    init(status: Status) {
        self.status = status
    }

    var body: some View {
        switch status {
        case .succeeded:
            SucceededView()
        case .failed:
            FailedView()
        }
    }
}

private struct SucceededView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
            Text("Connected")
        }
        .font(.title2)
        .foregroundStyle(Color.bcPositive)
    }
}

private struct FailedView: View {
    var body: some View {
        HStack {
            Image(systemName: "x.circle")
            Text("Failed")
        }
        .font(.title2)
        .foregroundStyle(Color.bcNegative)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(alignment: .leading, spacing: 8.0) {
        ConnectionStatusView(status: .succeeded)
        ConnectionStatusView(status: .failed)
    }
    .padding()
}
