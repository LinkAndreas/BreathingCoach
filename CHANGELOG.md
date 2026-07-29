# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/LinkAndreas/BreathingCoach/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/LinkAndreas/BreathingCoach/releases/tag/v1.0.0
