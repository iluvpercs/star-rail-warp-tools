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
2. Open Warp > History in the game (or wait for the script to ask you to).
3. If the link is still in logcat it is copied almost instantly. Otherwise the script watches for `$WatchSeconds` (25 by default) while you open the page. No Enter needed.
4. Paste the link (Ctrl+V) into the tracker's import page.

If `adb` isn't installed, the script downloads Google's platform-tools to your temp folder automatically.

## Run from a downloaded file

```
powershell -ExecutionPolicy Bypass -File .\get-warp-link.ps1
```

Set `$WatchSeconds` at the top of the script to make the fallback shorter or longer.

## Requirements

- Windows with PowerShell 5.1 or newer
- `adb` on PATH, next to the script, or auto-downloaded to `%TEMP%`
- Phone connected over USB with USB debugging enabled and authorized
- Honkai: Star Rail installed on the phone

## Troubleshooting

- **Still no link?** Check what the phone actually logs: `adb logcat -d -t 3000 | findstr /i gacha`. Do not post the raw output publicly - it contains tokens.
- **Android System WebView 114+:** Google patched this logging behaviour, so logcat (and system tracing) no longer show the link on many devices. Use the in-game Warp History **Share** button, or the Ascent app, instead.
- **Log line disappears quickly:** increase the device logger buffer (Developer options > Logger buffer size) or run `adb logcat -G 16M` before starting.

## Security

[![VirusTotal Scan](https://img.shields.io/badge/VirusTotal-View%20Scan-blue?logo=virustotal)](https://www.virustotal.com/gui/url/ccb8eb1b2d0754c03b80948b36ba48bf54d467c91882f6f5fb2305500829062e/detection)

The project can be independently checked using VirusTotal before execution.

## Notes

- Piping a web script into `iex` runs it without a look first. Read `get-warp-link.ps1` before running it, or download and run the file instead.
- The link contains a temporary auth key and expires after a while. If the import fails, run the script again.
- Do not share the link publicly.
- The logcat output also contains login tokens. Never paste raw logcat output anywhere public.
