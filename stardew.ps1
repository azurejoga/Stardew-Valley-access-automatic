# Check if you are running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Running as a non-administrator. Requesting elevation..."

    # Request elevation to administrator
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# Download directory
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
# SMAPI installer path
$smaPiInstallerPath = Join-Path $downloadsPath "SMAPI.zip"
# Default mod directory path
$defaultModsPath = "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods"

# URLs for download of SMAPI, Project Fluent, Stardew Access, GlueFurnitureDown, AutoFish, and Kokoro
$smaPiUrl = "https://github.com/Pathoschild/SMAPI/releases/download/4.0.5/SMAPI-4.0.5-installer.zip"
$projectFluentUrl = "https://github.com/Shockah/Stardew-Valley-Mods/releases/download/release%2Fproject-fluent%2F2.0.0/ProjectFluent.2.0.0.zip"
$stardewAccessUrl = "https://github.com/khanshoaib3/stardew-access/releases/download/v1.6.0-beta.3/stardew-access.1.6.0-beta.3.zip"
$glueFurnitureDownUrl = "https://github.com/elizabethcd/PreventFurniturePickup/releases/download/v1.1.0/GlueFurnitureDown.1.1.0.zip"
$autoFishUrl = "https://www.dropbox.com/scl/fi/utlvojra41d4e6b1m4w7j/AutoFish-1895-1-5-1-1680785870.zip?rlkey=ybzmtx4umepzquby26fr8uofh&dl=1"
$kokoroUrl = "https://github.com/Shockah/Stardew-Valley-Mods/releases/download/release%2Fkokoro%2F3.0.0/Kokoro.3.0.0.zip"

# Function to download and extract zip files
function DownloadAndExtractZip {
    param(
        [string]$sourceUrl,
        [string]$destinationPath,
        [string]$fileName
    )
    try {
        $zipFilePath = Join-Path $downloadsPath $fileName
        Write-Host "Downloading $fileName... wait..."
        Invoke-WebRequest -Uri $sourceUrl -OutFile $zipFilePath -UseBasicParsing
        Start-Sleep -Seconds 8
        Expand-Archive -Path $zipFilePath -DestinationPath $destinationPath -Force
        Write-Host "Downloaded and extracted: $fileName"
    } catch {
        Write-Host "Failed to download and extract: $fileName"
    }
}

# Function to create a shortcut on the desktop
function CreateDesktopShortcut {
    param (
        [string]$executablePath,
        [string]$shortcutName
    )
    # Create a shortcut on the desktop
    $shortcutFilePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "$shortcutName.lnk")
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutFilePath)
    $shortcut.TargetPath = $executablePath
    $shortcut.Save()
    Write-Host "Shortcut created on Desktop."
}

# Function to enable achievements
function EnableAchievements {
    param (
        [string]$shortcutName
    )
    # Find the shortcut on the desktop
    $shortcutFilePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "$shortcutName.lnk")
    
    if (Test-Path $shortcutFilePath) {
        # Add the command to enable achievements to the shortcut
        $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcutFilePath)
        $shortcut.Arguments = "%command%"
        $shortcut.Save()
        Write-Host "Achievements enabled for Stardew Modding API."
    } else {
        Write-Host "Shortcut not found on Desktop."
    }
}

# Ask the user if they want to install SMAPI
$installSMAPI = Read-Host "Do you want to install SMAPI? (Enter 'Y' for yes, 'N' for no)"
if ($installSMAPI -eq "Y") {
    # Check if the SMAPI file already exists before downloading it
    if (-not (Test-Path $smaPiInstallerPath)) {
        try {
            # Download SMAPI
            DownloadAndExtractZip -sourceUrl $smaPiUrl -destinationPath $downloadsPath -fileName "SMAPI.zip"
            Write-Host "SMAPI downloaded successfully."
        } catch {
            Write-Host "Failed to download SMAPI."
            exit
        }
    } else {
        Write-Host "SMAPI installer already exists."
    }
}

# Moves to the extracted SMAPI directory and runs the .bat file from the SMAPI directory
$smaPiDirectory = Get-ChildItem -Path $downloadsPath -Filter "SMAPI*" -Directory | Select-Object -First 1
if ($smaPiDirectory) {
    $smaPiDirectory = $smaPiDirectory.FullName
    Set-Location -Path $smaPiDirectory
    # Execute the .bat file from the SMAPI directory
    $batFilePath = Join-Path $smaPiDirectory "install on Windows.bat"
    if (Test-Path $batFilePath) {
        & $batFilePath
        Write-Host "$batFilePath executed from the SMAPI directory."
    } else {
        Write-Host ".bat file not found in the SMAPI directory."
    }
} else {
    Write-Host "SMAPI directory not found in extracted files."
}

# Ask the user if they want to choose the installation directory for the mods
$customModsPathChoice = Read-Host "Do you want to choose the installation directory for the mods? (Enter 'Y' for yes, 'N' for no)"
if ($customModsPathChoice -eq "Y") {
    # Use the native Windows explorer to choose the directory
    $modsPath = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Choose the mod installation directory", 0, $defaultModsPath).Self.Path
} else {
    # Use the default directory
    $modsPath = $defaultModsPath
}

# Check if the mods folder was created
if (Test-Path $modsPath) {
    Write-Host "Mods folder exists in: $modsPath."
}

# Ask the user if they want to download and install Project Fluent
$downloadProjectFluent = Read-Host "Do you want to download and install Project Fluent? (Enter 'Y' for yes, 'N' for no)"
if ($downloadProjectFluent -eq "Y") {
    DownloadAndExtractZip -sourceUrl $projectFluentUrl -destinationPath $modsPath -fileName "ProjectFluent.zip"
}

# Ask the user if they want to download and install Stardew Access
$downloadStardewAccess = Read-Host "Do you want to download and install Stardew Access? (Enter 'Y' for yes, 'N' for no)"
if ($downloadStardewAccess -eq "Y") {
    DownloadAndExtractZip -sourceUrl $stardewAccessUrl -destinationPath $modsPath -fileName "StardewAccess.zip"
}

# Ask the user if they want to download and install GlueFurnitureDown
$downloadGlueFurnitureDown = Read-Host "Do you want to download and install GlueFurnitureDown? (Enter 'Y' for yes, 'N' for no)"
if ($downloadGlueFurnitureDown -eq "Y") {
    DownloadAndExtractZip -sourceUrl $glueFurnitureDownUrl -destinationPath $modsPath -fileName "GlueFurnitureDown.zip"
}

# Ask the user if they want to download and install AutoFish
$downloadAutoFish = Read-Host "Do you want to download and install AutoFish? (Enter 'Y' for yes, 'N' for no)"
if ($downloadAutoFish -eq "Y") {
    DownloadAndExtractZip -sourceUrl $autoFishUrl -destinationPath $modsPath -fileName "AutoFish.zip"
}

# Ask the user if they want to download and install Kokoro
$downloadKokoro = Read-Host "Do you want to download and install Kokoro? (Enter 'Y' for yes, 'N' for no)"
if ($downloadKokoro -eq "Y") {
    DownloadAndExtractZip -sourceUrl $kokoroUrl -destinationPath $modsPath -fileName "Kokoro.zip"
}

# Function to execute the game with mods
function ExecuteGameWithMods {
    param (
        [string]$gameExecutablePath
    )
    # Execute the game with mods
    if (Test-Path $gameExecutablePath) {
        Start-Process $gameExecutablePath
    } else {
        Write-Host "Game executable not found."
    }
}

# Find the StardewModdingAPI executable
$stardewModdingAPIPath = Get-ChildItem -Path (Join-Path (Split-Path $modsPath -Parent) "StardewModdingAPI.exe") -Recurse | Where-Object { $_.Name -eq "StardewModdingAPI.exe" } | Select-Object -ExpandProperty FullName

# Ask the user if they want to create a shortcut on the desktop
$createShortcut = Read-Host "Do you want to create a shortcut on the desktop? (Enter 'Y' for yes, 'N' for no)"
if ($createShortcut -eq "Y") {
    # Create a shortcut on the desktop for Stardew Modding API
    CreateDesktopShortcut -executablePath $stardewModdingAPIPath -shortcutName "StardewModdingAPI"
}

# Ask the user if they want to enable achievements
$enableAchievements = Read-Host "Do you want to enable achievements for Stardew Modding API? (Enter 'Y' for yes, 'N' for no)"
if ($enableAchievements -eq "Y") {
    # Enable achievements for Stardew Modding API shortcut
    EnableAchievements -shortcutName "StardewModdingAPI"
}

# Ask the user if they want to execute the game with mods
$executeGame = Read-Host "Do you want to execute the game with mods now? (Enter 'Y' for yes, 'N' for no)"
if ($executeGame -eq "Y") {
    # Execute the game with mods
    ExecuteGameWithMods -gameExecutablePath $stardewModdingAPIPath
}

# Report that the mod configuration was completed successfully
Write-Host "Mod configuration completed successfully!"
