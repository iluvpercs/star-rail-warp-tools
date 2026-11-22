# star-rail-warp-tools

A PowerShell script that gets your Honkai: Star Rail Warp History link from an Android phone over ADB, with nothing extra installed on the phone. The link is copied to your clipboard so you can paste it into a tracker such as starrailstation.com.

Unofficial. Not affiliated with HoYoverse.

## Quick start (no download)

Open PowerShell and run:

```
irm https://raw.githubusercontent.com/iluvpercs/star-rail-warp-tools/main/get-warp-link.ps1 | iex
```

From Command Prompt:

```
powershell -NoProfile -Command "irm https://raw.githubusercontent.com/iluvpercs/star-rail-warp-tools/main/get-warp-link.ps1 | iex"
```

Then:

1. Connect the phone over USB (USB debugging on, and allow this PC when asked).
2. In the game, open Warp > History and scroll through 2-3 pages.
3. Press Enter in the terminal.
4. Paste the link (Ctrl+V) into the tracker's import page.

If `adb` isn't installed, the script downloads Google's platform-tools to your temp folder automatically.

## Run from a downloaded file

```
powershell -ExecutionPolicy Bypass -File .\get-warp-link.ps1
```

## Requirements

- Windows with PowerShell 5.1 or newer
- Phone connected over USB with USB debugging enabled
- Honkai: Star Rail installed on the phone

## Notes

- Piping a web script into `iex` runs it without a look first. Read `get-warp-link.ps1` before running it, or download and run the file instead.
- The link contains a temporary auth key and expires after a while. If the import fails, run the script again.
- Do not share the link publicly.
- The logcat output also contains login tokens. Never paste raw logcat output anywhere public.
