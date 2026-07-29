import Foundation

/// A serial port that may host a capnograph, as presented in the UI.
///
/// The identity is generated per scan result rather than derived from `path`, so a device that
/// disappears and returns is treated as a fresh row.
struct SerialDevice: Equatable, Identifiable {
    enum ConnectionStatus: Equatable {
        case available
        case unavailable
        case unknown
    }

    let id: UUID
    let name: String
    let path: String
    let baudRate: Int
    let communicationProtocol: String
    let connectionStatus: ConnectionStatus

    init(
        name: String,
        path: String,
        baudRate: Int,
        communicationProtocol: String,
        connectionStatus: ConnectionStatus
    ) {
        self.id = UUID()
        self.name = name
        self.path = path
        self.baudRate = baudRate
        self.communicationProtocol = communicationProtocol
        self.connectionStatus = connectionStatus
    }
}
