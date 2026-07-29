import SwiftUI

enum AttributedStringFactory {
    static func build(
        logs: [ConnectConsoleLog]
    ) -> AttributedString {
        var fullLog = AttributedString()
        for (index, log) in logs.enumerated() {
            fullLog.append(buildLogLine(log: log))
            if index != logs.count - 1 {
                fullLog.append(AttributedString("\n"))
            }
        }
        return fullLog
    }

    private static func buildLogLine(log: ConnectConsoleLog) -> AttributedString {
        var fullLog = AttributedString()
        
        // --- 1. Format the Timestamp ---
        let strictFormat = Date.VerbatimFormatStyle(
            format: "\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits).\(secondFraction: .fractional(3))",
            timeZone: .current,
            calendar: .current
        )
        let timeString = log.timeStamp.formatted(strictFormat)
        
        // Style the Timestamp
        var timeAttr = AttributedString(timeString + " ")
        // Use a monospaced font so the timestamps align perfectly vertically
        timeAttr.font = .system(.body, design: .monospaced)
        timeAttr.foregroundColor = Color(red: 0.4, green: 0.45, blue: 0.55) // Dim grayish-blue
        
        fullLog.append(timeAttr)
        
        // --- 2. Format the Message ---
        var msgAttr = AttributedString(log.message)
        msgAttr.foregroundColor = log.highlightColor ?? Color.primary
        msgAttr.font = .system(.body, design: .monospaced)
            
        fullLog.append(msgAttr)
        
        return fullLog
    }
}
