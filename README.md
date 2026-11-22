# star-rail-warp-tools

A PowerShell script that gets your Honkai: Star Rail Warp History link from an Android phone over ADB, with nothing extra installed on the phone. The link is copied to your clipboard so you can paste it into a tracker such as starrailstation.com.

Unofficial. Not affiliated with HoYoverse.

## Requirements

- Windows with PowerShell 5.1 or newer
- `adb` (Android platform-tools) on PATH, or next to the script
- Phone connected over USB with USB debugging enabled and authorized
- Honkai: Star Rail installed on the phone

## Usage

```
powershell -ExecutionPolicy Bypass -File .\get-warp-link.ps1
```

1. Run the script.
2. In the game, open Warp > History and scroll through 2-3 pages.
3. Press Enter in the terminal.
4. Paste the link (Ctrl+V) into the tracker's import page.

## Notes

- The link contains a temporary auth key and expires after a while. If the import fails, run the script again.
- Do not share the link publicly.
- The logcat output also contains login tokens. Never paste raw logcat output anywhere public.
