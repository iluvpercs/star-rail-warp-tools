param([string]$Url)
$ErrorActionPreference='Stop'
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12

if(-not $Url){
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
    $Url=$m[-1].Value
}

$Url=($Url -split '#')[0]
$keep='authkey_ver','sign_type','auth_appid','lang','authkey','game_biz','region'
$pairs=($Url -split '\?',2)[1] -split '&'
$q=($pairs|Where-Object{$keep -contains ($_ -split '=',2)[0]}) -join '&'
$base='https://public-operation-hkrpg-sg.hoyoverse.com/common/gacha_record/api/getGachaLog'
$banners=[ordered]@{'11'='Character Event Warp';'12'='Light Cone Event Warp';'1'='Stellar Warp';'2'='Departure Warp'}
$all=New-Object System.Collections.Generic.List[object]

foreach($t in $banners.Keys){
    $page=1
    $endId='0'
    do{
        do{
            $r=Invoke-RestMethod "${base}?$q&gacha_type=$t&page=$page&size=20&end_id=$endId"
            if($r.retcode -eq -110){Start-Sleep 3}
        }while($r.retcode -eq -110)
        if($r.retcode -ne 0){Write-Host "API error: $($r.message)";exit 1}
        $list=@($r.data.list)
        foreach($i in $list){
            $i|Add-Member -NotePropertyName banner -NotePropertyValue $banners[$t] -Force
            $all.Add($i)
        }
        if($list.Count){$endId=$list[-1].id}
        $page++
        Start-Sleep -Milliseconds 400
    }while($list.Count -eq 20)
    Write-Host "$($banners[$t]): $(@($all|Where-Object{$_.banner -eq $banners[$t]}).Count) pulls"
}

if(-not $all.Count){Write-Host "No records returned";exit 1}
$uid=$all[0].uid
$sorted=$all|Sort-Object id
$out=Join-Path (Get-Location) "star-rail-warp-$uid"
$sorted|ConvertTo-Json -Depth 5|Set-Content "$out.json" -Encoding UTF8
$sorted|Select-Object uid,banner,time,name,item_type,rank_type,id|Export-Csv "$out.csv" -NoTypeInformation -Encoding UTF8
Write-Host "Saved $($all.Count) pulls to $out.json and $out.csv"
