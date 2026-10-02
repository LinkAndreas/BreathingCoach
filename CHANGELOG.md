# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2026-10-02

### Changed

- Navigation runs on NavigationKit 3. Nothing changes on screen.

## [1.1.0] - 2026-10-01

### Changed

- Navigation runs on NavigationKit 2. The sidebar looks and works as before; each section now keeps
  its own place, so an opened history entry is still open when you return to History.

## [1.0.1] - 2026-07-29

### Added

- Demo mode: fake devices and synthetic readings so the whole app can be used without a capnograph,
  with a permanent `DEMO DATA` badge while it is active. Switch it on from the Connect screen or
  Settings, or launch with `-BCDemoMode YES`.
- Screenshots of every screen in the README.

### Changed

- Unified the product name to **BreathingCoach** across the window title, sidebar and onboarding
  (previously a mix of "EtCO₂ Trainer" and "Biofeedback Training").
- Extracted `DisplayUnit` out of `ConnectViewModel` and gave it the unit conversion and formatting
  that were previously duplicated across the Session, Summary and History screens.

### Fixed

- The sidebar device indicator no longer breaks the monitor name mid-word.
- The connection console no longer grows without limit during a session. It logs at ~20 Hz while
  the waveform streams, so it is now capped at the most recent 500 lines.

## [1.0.0] - 2026-07-29

Initial public release.

### Added

- **Connect** — serial/USB discovery of Capnostream monitors, handshake and progress views, live
  connection console with attributed log output, and success/failure/empty states.
- **Live session** — animated breathing pacer driven by a pure `BreathingPacer`, live CO₂ waveform,
  EtCO₂ and in-target cards, trend sparkline, target band and technique picker.
- **Techniques** — CART, Coherent Breathing, Buteyko reduced breathing, pursed-lip breathing, 4-7-8,
  and a custom pace derived from the user's breaths-per-minute setting.
- **Guide** — technique list with segment timings, benefits and step-by-step instructions.
- **Summary & history** — per-session EtCO₂ chart and stats, plus a browsable history with detail view.
- **Settings** — measurement units, EtCO₂ target range, custom pace, guide preferences and onboarding replay.
- **Onboarding** — paged first-run introduction, replayable from Settings.
- Localization via a string catalog, adaptive light/dark color palette, and a full macOS app icon set.

[Unreleased]: https://github.com/LinkAndreas/BreathingCoach/compare/1.1.1...HEAD
[1.1.1]: https://github.com/LinkAndreas/BreathingCoach/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/LinkAndreas/BreathingCoach/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/LinkAndreas/BreathingCoach/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/LinkAndreas/BreathingCoach/releases/tag/1.0.0
