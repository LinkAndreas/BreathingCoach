import SwiftUI

/// One line in the connection console. `highlightColor` is `nil` for ordinary lines and set for
/// outgoing commands, successful replies and errors.
struct ConnectConsoleLog {
    let timeStamp: Date
    let message: String
    let highlightColor: Color?

    init(timeStamp: Date = Date(), message: String, highlightColor: Color? = nil) {
        self.timeStamp = timeStamp
        self.message = message
        self.highlightColor = highlightColor
    }
}
