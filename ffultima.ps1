# download theme
$profile = read-host "Whats the path of your ff profile: "
Set-Location "$profile"
git clone https://github.com/himadrichakra12/HIM-ULTIMA.git chrome
Set-Location "chrome"; Copy-Item "user.js" "..\user.js"

# kill browser
Get-Process -Name firefox, firefox-developer-edition, firefox-nightly, librewolf -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
while (Get-Process -Name firefox, firefox-developer-edition, firefox-nightly, librewolf -ErrorAction SilentlyContinue) { Start-Sleep -Milliseconds 500 }

# restart browser (choose one)
Start-Process "firefox.exe"                   

# clean up user.js
Start-Sleep -Seconds 5; Set-Location ".."; Remove-Item "user.js" -ErrorAction SilentlyContinue
