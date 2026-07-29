import CapnostreamKit
import NavigationKit
import Observation
import SwiftUI

struct ConnectComposer: View {
    let viewModel: ConnectViewModel
    let navigator: StackNavigator
    let startBreathingSession: () -> Void
    
    var body: some View {
        MenuContent(
            header: {
                MenuContentHeader(
                    title: "Connect",
                    subtitle: "Search for a nearby Capnostream monitor over serial / USB."
                )
            },
            content: {
                WithContext {
                    ConnectRouter(
                        initialStep: viewModel.connectedDevice.map { .connected(device: $0) } ?? .initial
                    )
                } content: { router in
                    ConnectFlow(
                        currentStep: router.currentStep,
                        initial: {
                            ConnectEmptyView(scanAction: router.startSearch)
                        },
                        searching: {
                            ConnectProgressView()
                                .task { await viewModel.searchSerialDevices() }
                                .onChange(of: viewModel.serialDevices) { _, devices in
                                    router.didCompleteSearch(with: devices ?? [])
                                }
                        },
                        serialDeviceSelection: { devices in
                            ConnectDevicesOverview(
                                devices: devices.map { device in
                                    SerialDevice(
                                        name: device.name,
                                        path: device.path,
                                        baudRate: device.baudRate,
                                        communicationProtocol: device.communicationProtocol,
                                        connectionStatus: .available
                                    )
                                },
                                connectAction: { device in
                                    router.selectPort(device)
                                },
                                rescanAction: {
                                    router.startSearch()
                                }
                            )
                        },
                        handshake: { device in
                            ConnectHandshakeView(logs: viewModel.logs)
                                .task {
                                    do {
                                        try await viewModel.connect(to: device)
                                        router.connectionSucceeded(device: device)
                                    } catch {
                                        router.connectionFailed(device: device)
                                    }
                                }
                        },
                        connected: { device in
                            ConnectSuccessfulConnectionView(
                                device: device,
                                startBreathingSessionAction: startBreathingSession,
                                disconnectAction: {
                                    viewModel.disconnect()
                                    router.disconnect()
                                }
                            )
                        },
                        failed: { device in
                            ConnectFailedConnectionView(
                                device: device,
                                backToDevicesAction: { router.backToDevices() }
                            )
                        }
                    )
                }
            }
        )
    }
}
