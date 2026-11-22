# get-warp-link.ps1
# Grabs your Honkai: Star Rail Warp History link from a USB-connected Android
# phone via ADB and copies it to the clipboard. Nothing needs to be installed
# on the phone. Works in Windows PowerShell 5.1 and PowerShell 7+.

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# If the link is not already in the log, how long to watch while you open
# Warp > History. Change this to 10 or 60 if you want it shorter/longer.
$WatchSeconds = 25

function Find-Adb {
    $cmd = Get-Command adb -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $winget = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    if (Test-Path $winget) {
        $found = Get-ChildItem -Path $winget -Filter adb.exe -Recurse -ErrorAction SilentlyContinue |
                 Select-Object -First 1
        if ($found) { return $found.FullName }
    }

    # $PSScriptRoot is empty when this script is run through "irm ... | iex".
    if ($PSScriptRoot) {
        $local = Join-Path $PSScriptRoot 'adb.exe'
        if (Test-Path $local) { return $local }
    }

    # Last resort: use (or download) platform-tools into TEMP.
    $fallback = Join-Path $env:TEMP 'platform-tools\adb.exe'
    if (Test-Path $fallback) { return $fallback }

    Write-Host "adb not found; downloading platform-tools..."
    try {
        $zip = Join-Path $env:TEMP 'platform-tools.zip'
        Invoke-WebRequest 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile $zip -UseBasicParsing
        Expand-Archive $zip $env:TEMP -Force
        if (Test-Path $fallback) { return $fallback }
    } catch {
        Write-Host "Could not download adb: $($_.Exception.Message)" -ForegroundColor Red
    }
    return $null
}

function Get-WarpLink {
    $adb = Find-Adb
    if (-not $adb) {
        Write-Host "adb.exe not found. Put it on PATH, or next to this script." -ForegroundColor Red
        return $null
    }
    Write-Host "Using adb: $adb"

    $devices = @(& $adb devices 2>$null)
    $ready = $devices | Where-Object { $_ -match '\sdevice\s*$' }
    if (-not $ready) {
        Write-Host "No authorized device. Plug in the phone, enable USB debugging and allow this PC." -ForegroundColor Red
        return $null
    }

    # The gacha URL is not always on gs.hoyoverse.com. Match any host that
    # the working Ascent app watches (plus hoyolab).
    $urlPattern = 'https://(?:[a-z0-9-]+\.)?(?:hoyoverse|mihoyo|hoyolab)\.com/[^\s"''\\]+'

    # Filtering on the phone is much faster than pulling thousands of log
    # lines into PowerShell. This is the same idea Ascent uses.
    function Read-Link {
        # Single quotes around the grep pattern on purpose: PowerShell 5.1
        # strips embedded double quotes when passing args to a native exe.
        $lines = @(& $adb shell 'logcat -d | grep -iE ''authkey=|webview_gacha|game_biz=hkrpg'' | tail -n 40' 2>$null)
        if (-not $lines -or $lines.Count -eq 0) { return $null }

        $candidates = @(
            [regex]::Matches(($lines -join "`n"), $urlPattern) |
                ForEach-Object { $_.Value.TrimEnd('"', ',', ';', ')', ']', '}') } |
                Where-Object {
                    $_ -match '(?i)authkey=' -and
                    ($_ -match '(?i)gacha' -or $_ -match '(?i)hkrpg')
                }
        )
        if ($candidates.Count -eq 0) { return $null }

        # Prefer the Star Rail link if several games' links are in the log.
        $hsr = @($candidates | Where-Object { $_ -match '(?i)hkrpg' })
        if ($hsr.Count -gt 0) { return $hsr[-1] }
        return $candidates[-1]
    }

    # FAST PATH: if you already opened Warp > History, the link is usually
    # still in the log. No clearing, no waiting - done in about a second.
    $url = Read-Link
    if ($url) { return $url }

    # SLOW PATH (only if needed): clear the log and watch briefly while you
    # open the history page. Enlarging the buffer prevents dropped lines.
    & $adb logcat -G 16M 2>$null | Out-Null
    & $adb logcat -c 2>$null | Out-Null

    Write-Host ""
    Write-Host "Nothing in the current log. Open Warp > History in the game now..." -ForegroundColor Cyan
    Write-Host "Watching up to $WatchSeconds seconds."
    Write-Host ""

    $deadline = (Get-Date).AddSeconds($WatchSeconds)
    while ((Get-Date) -lt $deadline) {
        $url = Read-Link
        if ($url) { break }
        Start-Sleep -Milliseconds 300
    }

    if (-not $url) {
        Write-Host "No Warp link found in logcat." -ForegroundColor Red
        Write-Host "- If this phone has Android System WebView 114 or newer, this logcat method usually no longer works. Use the in-game Share button or the Ascent app instead."
        Write-Host "- Otherwise check what the phone logs with: adb logcat -d -t 3000 | findstr /i gacha"
        return $null
    }

    return $url
}

# Using a function + return instead of "exit" keeps "irm ... | iex" from
# closing the whole PowerShell window when something goes wrong.
$link = Get-WarpLink
if ($link) {
    Set-Clipboard -Value $link
    Write-Host ""
    Write-Host "Link copied to clipboard ($($link.Length) chars)." -ForegroundColor Green
    Write-Host "Paste it into the importer (Ctrl+V). Do not share it publicly - it contains your authkey."
}
