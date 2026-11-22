

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


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


    if ($PSScriptRoot) {
        $local = Join-Path $PSScriptRoot 'adb.exe'
        if (Test-Path $local) { return $local }
    }

   
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

    
    $urlPattern = 'https://(?:[a-z0-9-]+\.)?(?:hoyoverse|mihoyo|hoyolab)\.com/[^\s"''\\]+'

 
    function Read-Link {
       
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

       
        $hsr = @($candidates | Where-Object { $_ -match '(?i)hkrpg' })
        if ($hsr.Count -gt 0) { return $hsr[-1] }
        return $candidates[-1]
    }

 
    $url = Read-Link
    if ($url) { return $url }

 
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


$link = Get-WarpLink
if ($link) {
    Set-Clipboard -Value $link
    Write-Host ""
    Write-Host "Link copied to clipboard ($($link.Length) chars)." -ForegroundColor Green
    Write-Host "Paste it into the importer (Ctrl+V). Do not share it publicly - it contains your authkey."
}
