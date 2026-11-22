<div align="center">

<img src="docs/banner.svg" alt="Star Rail Warp Tools banner" width="900">

<br>

# Star Rail Warp Tools

**A small Windows PowerShell script that reads your Honkai: Star Rail Warp History URL from a USB-connected Android phone and copies it to your clipboard.**

<br>

[![CI](https://github.com/iluvpercs/star-rail-warp-tools/actions/workflows/ci.yml/badge.svg)](https://github.com/iluvpercs/star-rail-warp-tools/actions/workflows/ci.yml)
[![Windows](https://img.shields.io/badge/platform-Windows-0078D6?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/)
[![License](https://img.shields.io/badge/license-not%20specified-lightgrey)](#license)

<br>

Unofficial fan project. Not affiliated with or endorsed by HoYoverse.

</div>

---

## Requirements

- Windows PC
- Windows PowerShell 5.1 or PowerShell 7+
- Android phone with USB debugging enabled
- Honkai: Star Rail installed on the phone
- Android SDK Platform-Tools (ADB), installed using the steps below
- A USB cable that supports data transfer

---

## Setup on Windows

### Step 1 — Download Android SDK Platform-Tools

Go to Google's official page:

**[https://developer.android.com/tools/releases/platform-tools](https://developer.android.com/tools/releases/platform-tools)**

Under **Download for Windows**, download `platform-tools-latest-windows.zip`.

### Step 2 — Extract the ZIP file

Right-click the downloaded ZIP file and choose **Extract All…**, then pick a permanent folder. For example:

```text
C:\platform-tools
```

When you open that folder, you should see `adb.exe` directly inside it. If `adb.exe` is inside another folder, use that folder in the next step instead.

### Step 3 — Make ADB available from PowerShell

Add the folder containing `adb.exe` to your Windows `PATH`:

1. Press `Win + R`, type `sysdm.cpl`, and press Enter.
2. Open the **Advanced** tab, then click **Environment Variables**.
3. Under **User variables**, select **Path** and click **Edit**.
4. Click **New**, paste your folder (for example `C:\platform-tools`), and click **OK** on each dialog.
5. Close and reopen PowerShell so the change takes effect.

Check that it worked:

```powershell
adb version
```

You should see something like `Android Debug Bridge version ...`.

> If you do not want to change `PATH`, you can copy `adb.exe` into the same folder as `get-warp-link.ps1` instead. The script checks that folder too.

### Step 4 — Set up the Android phone

1. Open **Settings → About phone** and tap **Build number** seven times. Enter your PIN or password if asked. This enables Developer options.
2. Open **Settings → Developer options** and turn on **USB debugging**.
3. Connect the phone to the PC with a USB data cable. If the phone asks about the USB mode, choose **File transfer (MTP)**.
4. Unlock the phone and read the **Allow USB debugging?** dialog. Tick **Always allow from this computer** if you trust this PC, then tap **Allow**.

### Step 5 — Verify the connection

In PowerShell, run:

```powershell
adb devices
```

You should see `List of devices attached` followed by a serial number and the word `device`:

```text
List of devices attached
abc123def456    device
```

- If the state says `unauthorized`, unlock the phone and accept the USB debugging prompt again.
- If the list is empty, check the cable and that USB debugging is on.

---

## Running the script

Open PowerShell in the folder containing `get-warp-link.ps1` and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\get-warp-link.ps1
```

You can also run it directly from GitHub:

```powershell
irm https://raw.githubusercontent.com/iluvpercs/star-rail-warp-tools/main/get-warp-link.ps1 | iex
```

> Review `get-warp-link.ps1` before executing it. Piping a web script into `iex` runs remote code immediately.

---

## What happens when it works

1. The script finds ADB and checks that your phone is connected and authorized.
2. It looks through the phone's current log for the Warp History URL. If the link is still there, it is copied almost immediately.
3. If the link is not there, it clears the log and says:

   ```text
   Nothing in the current log. Open Warp > History in the game now...
   Watching up to 25 seconds.
   ```

   Open **Warp → History** in Honkai: Star Rail while it watches. No Enter key is needed.
4. On success it prints:

   ```text
   Link copied to clipboard (### chars).
   ```

   The URL itself is **not** shown in the terminal.
5. Switch to your warp tracker and paste the link with `Ctrl+V`.

The URL contains a temporary authentication key. If the importer says the key expired, reopen Warp → History and run the script again.

---

## Troubleshooting ADB

| Problem | What to try |
|---|---|
| `adb` is not recognized | Make sure the folder with `adb.exe` is on `PATH`, then close and reopen PowerShell. Check with `adb version`. |
| `adb devices` shows no device | Use a data-capable USB cable, try another USB port, unlock the phone, and confirm USB debugging is enabled. |
| `adb devices` shows `unauthorized` | Unlock the phone and accept the **Allow USB debugging?** prompt. In Developer options you can tap **Revoke USB debugging authorizations** and reconnect to trigger it again. |
| `adb devices` shows `offline` | Unplug and reconnect the cable, unlock the phone, and run `adb devices` again. |
| More than one device is listed | Disconnect the other devices and connect only the phone you want to use. |
| The script says `No authorized device. Plug in the phone, enable USB debugging and allow this PC.` | Repeat Step 4 and confirm `adb devices` shows `device` before running the script again. |

If `adb devices` works but the script says `No Warp link found in logcat`, open Warp → History in the game and run the script again.

**Android System WebView 114+**

On many phones with Android System WebView 114 or newer, the Warp History URL no longer appears in logcat (system tracing is affected too). This can prevent this script from retrieving the link even when the phone is connected correctly. If that happens, use the in-game Warp History **Share** button or the [Ascent](https://github.com/4o3F/Ascent) app instead.

**Logcat buffer limitations**

The phone's logcat buffer is limited, so the line containing the Warp History URL can be overwritten before the script reads it. If links are found inconsistently, increase **Logger buffer size** in Developer options on the phone. As an optional advanced workaround, run this command on the PC before starting the script to enlarge the buffer to 16 MB:

```powershell
adb logcat -G 16M
```

---

## Security

Please read these before use:

- **Review `get-warp-link.ps1` before executing it.**
- **Warp History URLs contain temporary authentication keys.**
- **Never share generated Warp History URLs publicly.**
- **Logcat output may contain sensitive login tokens.**
- **Never publish raw logcat output.**

The script copies the URL to the clipboard and reports only its character count; it does not print the URL or the key.

### VirusTotal scan

The link below is a **URL scan of the raw script URL**, not a file scan of a local executable:

[View the VirusTotal URL scan report](https://www.virustotal.com/gui/url/ccb8eb1b2d0754c03b80948b36ba48bf54d467c91882f6f5fb2305500829062e/detection)

---

## License

This repository does not currently include a `LICENSE` file. No license is claimed or implied.
