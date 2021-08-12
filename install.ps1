$exe = Read-Host -Prompt "Exe Path: "
$content = Get-Content -Path ".\integrate-shell.reg"
$exe = $exe -replace "\\", "\\"
$exe = $exe -replace '"',""
$content = $content -replace "REPLACETHIS",$exe
$content | Set-Content -Path ".\integrate-shell.reg"
reg import .\integrate-shell.reg