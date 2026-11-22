# Changelog

All notable changes to this project are documented here. Dates reflect the commit dates in the repository history.

## Unreleased

- Replaced the placeholder CI workflow with PowerShell syntax validation and PSScriptAnalyzer checks.
- Added a release workflow for `v*.*.*` tags.
- Redesigned the README with a local SVG banner, badges, feature overview, placeholders for future screenshots, and expanded security guidance.
- Added contribution guidelines, issue forms, and a pull request template.
- Added PSScriptAnalyzer settings and minor `.gitignore` entries.
- Removed the automatic Platform-Tools download; ADB must now be installed manually from Google's official release.
- Added beginner-friendly ADB installation, Windows `PATH`, device authorization, and phone USB-debugging setup guides to the README.
- Added explicit script messages for missing ADB, adb server failures, unauthorized devices, offline devices, and multiple devices.
- Replaced the generic screenshot placeholders with a single blurred capture; all text and keys in the image are intentionally unreadable.

## 2026-11-22

- `5e08158` — Fast path for warp link detection: check the existing logcat buffer first, filter on-device, and fall back to a short 25-second watch window.
- `d6a3829` — Added a basic CI workflow with a build job (later replaced by the current CI workflow).
- `de8427a` — Improved ADB detection and error handling, including automatic `platform-tools` download.
- `e5ee72b` — Revised README with quick start and usage details.
- `969eca5` — Updated README with usage instructions and notes.
- `acb3099` — Revised README for clarity on script usage.
- `b5e03cd` — Added the warp link grabber script.
- `fbff7ea` — Added warp link grabber and history import scripts.
