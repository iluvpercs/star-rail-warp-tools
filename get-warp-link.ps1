$ErrorActionPreference='Stop'
$adb=(Get-Command adb -ErrorAction SilentlyContinue).Source
if(-not $adb){$adb=(Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Filter adb.exe -Recurse -ErrorAction SilentlyContinue|Select-Object -First 1).FullName}
if(-not $adb){Write-Host "adb not found";exit 1}
$d=& $adb devices|Select-Object -Skip 1|Where-Object{$_ -match '\sdevice$'}
if(-not $d){Write-Host "No authorized device";exit 1}
& $adb logcat -c
Read-Host "Open Warp > History in game, scroll 2-3 pages, then press Enter"
$log=(& $adb logcat -d) -join "`n"
$m=@([regex]::Matches($log,'https://gs\.hoyoverse\.com/hkrpg/[^\s"\\#]+')|Where-Object{$_.Value -match 'authkey='})
if(-not $m.Count){Write-Host "No link found, open Warp History and try again";exit 1}
Set-Clipboard -Value $m[-1].Value
Write-Host "Link copied to clipboard"
