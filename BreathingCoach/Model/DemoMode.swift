import Foundation
import Observation

/// A device-free mode that drives the app with obviously synthetic readings.
///
/// It lets someone without a capnograph try the full flow — connect, train, review — and lets the
/// session screens be developed, previewed and captured for documentation without hardware.
///
/// It is **off** until switched on, either from Settings (or the Connect screen) or by launching
/// with `-BCDemoMode YES`, and while it is on the window shows a `DEMO DATA` badge, because readings
/// the user cannot tell apart from real ones would be exactly the wrong thing for this app to show.
///
/// The choice is remembered between launches.
@Observable
final class DemoMode {
    static let shared = DemoMode()

    private static let defaultsKey = "BCDemoMode"

    /// Whether the app is currently running on synthetic data.
    ///
    /// This in-memory value is the source of truth once the app is running, so toggling in the UI
    /// takes effect even when the launch argument set the initial value.
    private(set) var isEnabled: Bool

    private init() {
        isEnabled = UserDefaults.standard.bool(forKey: Self.defaultsKey)
    }

    func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        UserDefaults.standard.set(isEnabled, forKey: Self.defaultsKey)
    }

    /// The fake monitors offered by a demo scan. Named so they cannot be mistaken for real hardware.
    static let devices: [SerialDevice] = [
        SerialDevice(
            name: "Capnostream 20p (Demo)",
            path: "/dev/cu.demo-capnostream",
            baudRate: 9600,
            communicationProtocol: "Capnostream",
            connectionStatus: .available
        ),
        SerialDevice(
            name: "Capnostream 35 (Demo)",
            path: "/dev/cu.demo-capnostream-35",
            baudRate: 9600,
            communicationProtocol: "Capnostream",
            connectionStatus: .available
        ),
    ]
}

/// Generates a plausible capnogram and matching numerics for demo mode.
///
/// The waveform follows the selected technique's own timing, so the trace stays in step with the
/// pacer, and EtCO₂ drifts up from a mildly hyperventilating value into the target range the way a
/// successful training session would. Nothing here is measured — it is a shaped function of time.
struct DemoSignalGenerator {
    /// The technique timing the synthetic breathing follows.
    let segments: BreathingTechnique.Segments

    /// EtCO₂ at the start of the session, in mmHg — deliberately below a typical target range.
    private let startEtco2 = 30.0
    /// The value EtCO₂ approaches as the session progresses, in mmHg.
    private let targetEtco2 = 41.0
    /// Time constant of that approach, in seconds.
    private let riseTimeConstant = 75.0
    /// Inspired CO₂ baseline between breaths, in mmHg.
    private let baseline = 0.4

    /// EtCO₂ at `elapsed`, rising asymptotically from `startEtco2` toward `targetEtco2`.
    func etco2(at elapsed: TimeInterval) -> Double {
        let progress = 1 - exp(-max(0, elapsed) / riseTimeConstant)
        let wobble = 0.4 * sin(elapsed / 7)
        return startEtco2 + (targetEtco2 - startEtco2) * progress + wobble
    }

    /// The instantaneous CO₂ value at `elapsed`, in mmHg.
    ///
    /// Follows the shape of a real capnogram: near zero while inhaling and holding, a fast upstroke
    /// at the start of exhalation, then a slightly rising alveolar plateau that ends at EtCO₂.
    func waveformValue(at elapsed: TimeInterval) -> Double {
        let cycle = segments.cycleDuration
        guard cycle > 0 else { return baseline }

        let peak = etco2(at: elapsed)
        let t = elapsed.truncatingRemainder(dividingBy: cycle)
        let exhaleStart = segments.inhale + segments.holdIn
        let exhaleEnd = exhaleStart + segments.exhale

        guard t >= exhaleStart, t < exhaleEnd, segments.exhale > 0 else { return baseline }

        // Fraction through the exhale: a fast upstroke over the first fifth, then the plateau.
        let fraction = (t - exhaleStart) / segments.exhale
        let upstroke = 0.2
        if fraction < upstroke {
            return baseline + (peak * 0.92 - baseline) * (fraction / upstroke)
        }
        let plateauProgress = (fraction - upstroke) / (1 - upstroke)
        return peak * (0.92 + 0.08 * plateauProgress)
    }

    /// The once-per-second readings at `elapsed`.
    func readings(at elapsed: TimeInterval) -> LiveReadings {
        let cycle = segments.cycleDuration
        return LiveReadings(
            etco2: etco2(at: elapsed).rounded(),
            respirationRate: cycle > 0 ? (60 / cycle).rounded() : nil,
            spo2: (97 + 1.5 * sin(elapsed / 11)).rounded()
        )
    }
}
