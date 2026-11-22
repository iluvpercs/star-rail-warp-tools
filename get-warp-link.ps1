& {
$ErrorActionPreference='Stop'
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$adb=(Get-Command adb -ErrorAction SilentlyContinue).Source
if(-not $adb){$adb=(Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Filter adb.exe -Recurse -ErrorAction SilentlyContinue|Select-Object -First 1).FullName}
if(-not $adb){
    $adb="$env:TEMP\platform-tools\adb.exe"
    if(-not (Test-Path $adb)){
        Write-Host "adb not found, downloading platform-tools..."
        $zip="$env:TEMP\platform-tools.zip"
        Invoke-WebRequest "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -OutFile $zip -UseBasicParsing
        Expand-Archive $zip $env:TEMP -Force
    }
}
$d=& $adb devices|Select-Object -Skip 1|Where-Object{$_ -match '\sdevice$'}
if(-not $d){Write-Host "No authorized device. Plug in the phone, enable USB debugging and allow this PC.";return}
& $adb logcat -c
Read-Host "Open Warp > History in game, scroll 2-3 pages, then press Enter"
$log=(& $adb logcat -d) -join "`n"
$m=@([regex]::Matches($log,'https://gs\.hoyoverse\.com/hkrpg/[^\s"\\#]+')|Where-Object{$_.Value -match 'authkey='})
if(-not $m.Count){Write-Host "No link found. Open Warp History and try again.";return}
Set-Clipboard -Value $m[-1].Value
Write-Host "Link copied to clipboard"
}
