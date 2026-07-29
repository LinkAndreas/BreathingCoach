import SwiftUI

/// The terminal-style console. Uses a read-only `TextEditor` rather than `Text` so the log stays
/// selectable and copyable when reporting a connection problem.
struct ConnectConsoleView: View {
    let logs: [ConnectConsoleLog]

    init(logs: [ConnectConsoleLog]) {
        self.logs = logs
    }

    var body: some View {
        TextEditor(text: .constant(AttributedStringFactory.build(logs: logs)))
            .lineSpacing(4)
            .frame(minHeight: 180)
            .fixedSize(horizontal: false, vertical: true)
            .textEditorStyle(.plain)
            .padding(16.0)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.1), radius: 3)
    }
}

#Preview {
    ConnectConsoleView(logs: [
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
            message: "← CO₂ wave: 0 (~20 Hz)",
            highlightColor: Color.bcPositive
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "← Numerics: EtCO₂: 38, RR: 12, SpO₂: 98 (1 Hz)",
            highlightColor: Color.bcPositive
        ),
        ConnectConsoleLog(
            timeStamp: Date(),
            message: "Connected.",
            highlightColor: Color.bcPositive
        )
    ])
    .padding()
}
