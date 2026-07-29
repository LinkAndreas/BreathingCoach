import SwiftUI

/// The Connect screen. Owns a `ConnectRouter` for the step the user is on and hands each step's
/// side effects — scanning, connecting, disconnecting — to the shared view model.
struct ConnectComposer: View {
    let viewModel: ConnectViewModel
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
                            ConnectEmptyView(
                                scanAction: router.startSearch,
                                startDemoAction: {
                                    DemoMode.shared.setEnabled(true)
                                    router.startSearch()
                                }
                            )
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
                                devices: devices,
                                connectAction: router.selectPort,
                                rescanAction: router.startSearch
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
