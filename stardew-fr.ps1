# Download directory
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
# SMAPI installer path
$smaPiInstallerPath = Join-Path $downloadsPath "SMAPI.zip"
# Default mod directory path
$defaultModsPath = "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods"

# URLs for download of SMAPI, Project Fluent, Stardew Access, GlueFurnitureDown, AutoFish, and Kokoro
$smaPiUrl = "https://github.com/Pathoschild/SMAPI/releases/download/4.0.8/SMAPI-4.0.8-installer.zip"
$projectFluentUrl = "https://github.com/Shockah/Stardew-Valley-Mods/releases/download/release%2Fproject-fluent%2F2.0.0/ProjectFluent.2.0.0.zip"
$stardewAccessUrl = "https://github.com/khanshoaib3/stardew-access/releases/download/v1.6.0-beta.5/stardew-access-1.6.0-beta.5.zip"
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
        Write-Host "Téléchargement de  $fileName... veuillez patienter..."
        Invoke-WebRequest -Uri $sourceUrl -OutFile $zipFilePath -UseBasicParsing
        Start-Sleep -Seconds 8
        Expand-Archive -Path $zipFilePath -DestinationPath $destinationPath -Force
        Write-Host "Fichier télécharger et extrait: $fileName"
    } catch {
        Write-Host "Échec du téléchargement et de l'extraction: $fileName"
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
    Write-Host "Le raccourci à été créer et placé sur le bureau."
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
        Write-Host "Les succès ont été activé pour  Stardew Modding API."
    } else {
        Write-Host "Le raccourci n'a pas été trouvé sur le bureau."
    }
}

# Ask the user if they want to install SMAPI
$installSMAPI = Read-Host "Voulez vous installer  SMAPI? (Entrez 'Y' pour oui, 'N' pour non)"
if ($installSMAPI -eq "Y") {
    # Check if the SMAPI file already exists before downloading it
    if (-not (Test-Path $smaPiInstallerPath)) {
        try {
            # Download SMAPI
            DownloadAndExtractZip -sourceUrl $smaPiUrl -destinationPath $downloadsPath -fileName "SMAPI.zip"
            Write-Host "SMAPI téléchargé avec succès."
        } catch {
            Write-Host "Échec du téléchargement de  SMAPI."
            exit
        }
    } else {
        Write-Host "SMAPI installer existe déjà."
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
        Write-Host "$batFilePath run from the SMAPI directory."
    } else {
        Write-Host ".bat file not found in SMAPI directory."
    }
} else {
    Write-Host "SMAPI directory not found in extracted files."
}

# Ask the user if they want to choose the installation directory for the mods
$customModsPathChoice = Read-Host "Voulez vous choisir  la destination de l'instalation  pour le  mods? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($customModsPathChoice -eq "Y") {
    # Use the native Windows explorer to choose the directory
    $modsPath = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Choose the mod installation directory", 0, $defaultModsPath).Self.Path
} else {
    # Use the default directory
    $modsPath = $defaultModsPath
}

# Check if the mods folder was created
if (Test-Path $modsPath) {
    Write-Host "Le dossier de Mods existe dans la direction suivante:: $modsPath."
}

# Ask the user if they want to download and install Project Fluent
$downloadProjectFluent = Read-Host "Voulez vous télécharger et installer  Project Fluent? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($downloadProjectFluent -eq "Y") {
    DownloadAndExtractZip -sourceUrl $projectFluentUrl -destinationPath $modsPath -fileName "ProjectFluent.zip"
}

# Ask the user if they want to download and install Stardew Access
$downloadStardewAccess = Read-Host "Voulez vous télécharger et installer Stardew Access? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($downloadStardewAccess -eq "Y") {
    DownloadAndExtractZip -sourceUrl $stardewAccessUrl -destinationPath $modsPath -fileName "StardewAccess.zip"
}

# Ask the user if they want to download and install GlueFurnitureDown
$downloadGlueFurnitureDown = Read-Host "Voulez vous télécharger et installer GlueFurnitureDown? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($downloadGlueFurnitureDown -eq "Y") {
    DownloadAndExtractZip -sourceUrl $glueFurnitureDownUrl -destinationPath $modsPath -fileName "GlueFurnitureDown.zip"
}

# Ask the user if they want to download and install AutoFish
$downloadAutoFish = Read-Host "Voulez vous télécharger et installer AutoFish? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($downloadAutoFish -eq "Y") {
    DownloadAndExtractZip -sourceUrl $autoFishUrl -destinationPath $modsPath -fileName "AutoFish.zip"
}

# Ask the user if they want to download and install Kokoro
$downloadKokoro = Read-Host "Voulez vous télécharger et installer Kokoro? (Ecrivez 'Y' pour oui, 'N' pour non)"
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
        Write-Host "L'éxécutable du jeu n'as pas été trouvé."
    }
}

# Find the StardewModdingAPI executable
$stardewModdingAPIPath = Get-ChildItem -Path (Join-Path (Split-Path $modsPath -Parent) "StardewModdingAPI.exe") -Recurse | Where-Object { $_.Name -eq "StardewModdingAPI.exe" } | Select-Object -ExpandProperty FullName

# Ask the user if they want to create a shortcut on the desktop
$createShortcut = Read-Host "Voulez vous créer un raccourci pour lancer le jeu sur le bureau ? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($createShortcut -eq "Y") {
    # Create a shortcut on the desktop for Stardew Modding API
    CreateDesktopShortcut -executablePath $stardewModdingAPIPath -shortcutName "StardewModdingAPI"
}

# Ask the user if they want to enable achievements
$enableAchievements = Read-Host "Voulez vous activer les succès pour Stardew Modding API? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($enableAchievements -eq "Y") {
    # Enable achievements for Stardew Modding API shortcut
    EnableAchievements -shortcutName "StardewModdingAPI"
}

# Ask the user if they want to execute the game with mods
$executeGame = Read-Host "Voulez vous lancer le jeu avec les Mods maintenant ? (Ecrivez 'Y' pour oui, 'N' pour non)"
if ($executeGame -eq "Y") {
    # Execute the game with mods
    ExecuteGameWithMods -gameExecutablePath $stardewModdingAPIPath
}

# Report that the mod configuration was completed successfully
Write-Host "La configuration du mod est terminé avec succès!"

