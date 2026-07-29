# Contributing to BreathingCoach

Thanks for taking the time to contribute. Bug reports, technique corrections, protocol fixes and
UI improvements are all welcome.

By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## Before you start

- For anything larger than a bug fix, open an issue first so we can agree on the approach.
- Changes that affect displayed physiological values, technique timings or the safety wording in the
  app deserve extra scrutiny — please cite a source in the PR description.
- BreathingCoach is not a medical device and will not accept features that present it as one
  (alarms, diagnostic claims, clinical decision support).

## Development setup

Requirements: macOS 27+, Xcode 27+. Hardware is optional: switch on demo mode in Settings, or run
with `-BCDemoMode YES` in the scheme's launch arguments, and the app serves fake devices and synthetic readings, so the session, summary and
history screens work without a capnograph. Anything you change there must keep the `DEMO DATA` badge
visible — simulated readings must never be mistakable for real ones.

```bash
git clone https://github.com/LinkAndreas/BreathingCoach.git
```

Open `BreathingCoach.xcodeproj` and run the `BreathingCoach` scheme, or build from the terminal:

```bash
xcodebuild -project BreathingCoach.xcodeproj -scheme BreathingCoach -destination 'platform=macOS' build
```

## Branching model (git-flow)

| Branch | Purpose |
|---|---|
| `main` | Production. Only release and hotfix merges land here, each tagged `vX.Y.Z`. |
| `develop` | Integration branch. Everything else branches from and merges back into it. |
| `feature/*` | New work, branched from `develop`. |
| `release/*` | Release stabilization, branched from `develop`, merged into `main` **and** back into `develop`. |
| `hotfix/*` | Urgent production fixes, branched from `main`, merged into `main` **and** `develop`. |

```bash
git checkout develop
git pull
git checkout -b feature/my-change
```

Open pull requests against `develop` — never against `main`. Merges into `main` use `--no-ff` so the
release history stays visible.

## Commit messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(session): add breath-hold countdown to the pacer

Longer explanation of the why, wrapped at 80 characters.
```

Common types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `chore`.
Scopes follow the feature folders: `session`, `connect`, `guide`, `history`, `summary`, `settings`,
`onboarding`, `navigation`, `ui`, `foundation`, `resources`.

## Code style

- SwiftUI views stay small and composable; put shared pieces in `Components/`.
- Keep logic that can be pure, pure — see `BreathingPacer` for the pattern.
- New features live under `Features/<Feature>/` with `Model/` and `Components/` subfolders as needed.
  Sources are file-system synchronized, so adding a file to the folder is enough — no `.pbxproj` edit.
- All user-facing strings go through `Localizable.xcstrings`. Never hardcode display copy.
- Colors come from the `Color.bc*` palette in `Extensions/`, so light and dark mode both work.
- Add `#Preview` blocks to new views where practical.

## Pull request checklist

- [ ] Branched from `develop` and targets `develop`
- [ ] `xcodebuild ... build` succeeds with no new warnings
- [ ] User-facing strings are localized
- [ ] New views render correctly in light and dark mode
- [ ] Commit messages follow Conventional Commits
- [ ] `CHANGELOG.md` updated under `Unreleased` for user-visible changes

## Releasing

1. `git checkout -b release/X.Y.Z develop`
2. Bump `MARKETING_VERSION` (and `CURRENT_PROJECT_VERSION`) in the project settings; move the
   `Unreleased` section of `CHANGELOG.md` under the new version heading.
3. Merge into `main` with `--no-ff`, tag `vX.Y.Z`, then merge `main` back into `develop`.
4. Push branches and tags: `git push origin main develop --tags`.
