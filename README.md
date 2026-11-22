# star-rail-warp-tools

PowerShell scripts that get your Honkai: Star Rail Warp History from an Android phone over ADB, with nothing extra installed on the phone.

Unofficial. Not affiliated with HoYoverse.

## Scripts

| Script | What it does |
|---|---|
| `get-warp-link.ps1` | Reads the Warp History link from the phone's log and copies it to your clipboard. Paste it into a tracker such as starrailstation.com. |
| `import-warp-history.ps1` | Gets the link, then downloads all four banners and saves them as `.json` and `.csv` on your PC. |

## Requirements

- Windows with PowerShell 5.1 or newer
- `adb` (Android platform-tools) on PATH, or next to the script
- Phone connected over USB with USB debugging enabled and authorized
- Honkai: Star Rail installed on the phone (global server)

## Usage

```
powershell -ExecutionPolicy Bypass -File .\get-warp-link.ps1
```

1. Run the script.
2. In the game, open Warp > History and scroll through 2-3 pages.
3. Press Enter in the terminal.

For the full history export:

```
powershell -ExecutionPolicy Bypass -File .\import-warp-history.ps1
```

To skip the phone step and use a link you already have:

```
powershell -ExecutionPolicy Bypass -File .\import-warp-history.ps1 -Url "<link>"
```

## Notes

- The link contains a temporary auth key. It expires after a while. If you get "authkey timeout", run the script again.
- Do not share the link, or the exported files, publicly. The exports include your UID.
- `import-warp-history.ps1` targets the global server only.
- The logcat output also contains login tokens. Never paste raw logcat output anywhere public.
