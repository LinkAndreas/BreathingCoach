# Security Policy

## Supported versions

BreathingCoach is a single-maintainer hobby project. Only the latest release on `main` receives
fixes.

| Version | Supported |
|---|---|
| 1.0.x | ✅ |
| < 1.0 | ❌ |

## Reporting a vulnerability

Please **do not** open a public issue for a security problem.

Use GitHub's [private vulnerability reporting](https://github.com/LinkAndreas/BreathingCoach/security/advisories/new)
(Security → Report a vulnerability). It is private to the maintainer until a fix is published.

Include what you can: affected version, steps to reproduce, and the impact you think it has. You can
expect an acknowledgement within about a week, and I will keep you posted on the fix. Credit in the
release notes is offered unless you prefer to stay anonymous.

## Scope notes

The app talks to a locally connected serial/USB capnography monitor. It does not sandbox itself
(serial access requires this), and its entitlements grant USB and Bluetooth resource access. Reports
about parsing untrusted device input, privilege issues arising from the disabled sandbox, or local
data handling are all in scope.

The app makes no outbound network connections (`ENABLE_OUTGOING_NETWORK_CONNECTIONS = NO`) and does
not transmit session data anywhere.

Vulnerabilities in the [CapnostreamKit](https://github.com/LinkAndreas/CapnostreamKit) or
[NavigationKit](https://github.com/LinkAndreas/NavigationKit) dependencies should be reported on
those repositories.

## Not a medical device

BreathingCoach is not certified for clinical use and must not be relied on for monitoring or care
decisions. Incorrect or missing readings are a known and accepted property of an uncertified tool,
not a security vulnerability — but do report anything that makes the app misrepresent data as
trustworthy when it is not.
