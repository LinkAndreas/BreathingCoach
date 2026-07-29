import Foundation

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
