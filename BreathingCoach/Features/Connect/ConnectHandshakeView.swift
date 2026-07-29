import SwiftUI

/// Shown during the handshake, streaming the protocol exchange into the console so a failure is
/// diagnosable rather than silent.
struct ConnectHandshakeView: View {
    let logs: [ConnectConsoleLog]

    init(logs: [ConnectConsoleLog]) {
        self.logs = logs
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("Handshake")
                .font(.body)
                .fontDesign(.monospaced)
                .fontWeight(.thin)
            ConnectConsoleView(logs: logs)
        }
        .padding()
        .background {
            Color.bcGroupedBackground
        }
        .outline(cornerRadius: 12.0, lineWidth: 1.0, color: Color.accentColor)
    }
}

#Preview {
    ConnectHandshakeView(logs: [
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "Opening /dev/cu.usbserial-A5069RR4 @ 9600 baud"
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "→ Enable Communication Protocol (0x16)",
            highlightColor: Color.bcAccent
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "→ retry 1/10 - awaiting"
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "← Device ID: CAPNOSTREAM20 SW",
            highlightColor: Color.bcPositive
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "→ Start Realtime Communication (0x09)",
            highlightColor: Color.bcAccent
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "← Streaming C02 Wave (code 0) @ ~20 Hz",
            highlightColor: Color.bcPositive
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "← Streaming Numerics (code 1) @ 1 Hz",
            highlightColor: Color.bcPositive
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "Connected.",
            highlightColor: Color.bcPositive
        )
    ])
}
