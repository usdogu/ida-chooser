function Download-File {
    Invoke-WebRequest -Uri "https://github.com/usdogu/ida-chooser/releases/download/v3.0.0/ida-chooser.exe" -OutFile ".\ida-chooser.exe"
}



function Add-Integration {
    Download-File
    "Exe path, leave blank if you want to use the one in the current directory"
    $exe = Read-Host -Prompt "Input: "
    $exe = $exe.Trim()
    if (!$exe) {
        $exe = $PSScriptRoot + "\ida-chooser.exe"
    }
    $content = Get-Content -Path ".\integrate-shell.reg"
    $exe = $exe -replace "\\", "\\"
    $exe = $exe -replace '"', ""
    $content = $content -replace "REPLACETHIS", $exe
    $content | Set-Content -Path ".\integrate-shell.reg"
    reg import .\integrate-shell.reg

}

Add-Integration