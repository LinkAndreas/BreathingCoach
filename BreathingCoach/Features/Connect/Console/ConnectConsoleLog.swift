import SwiftUI

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
