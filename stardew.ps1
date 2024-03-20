# URL of SMAPI
$smaPiUrl = "https://mediafilez.forgecdn.net/files/5194/243/SMAPI%204.0.0-alpha.20240310%20for%20developers-4-0-0-alpha-20240310.zip"
# Download directory
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
# SMAPI installer path
$smaPiInstallerPath = Join-Path $downloadsPath "SMAPI.zip"
# Default mod directory path
$defaultModsPath = "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods"

# URLs for  download of Project Fluent and Stardew Access
$projectFluentUrl = "https://github.com/Shockah/Stardew-Valley-Mods/releases/download/release%2Fproject-fluent%2F2.0.0/ProjectFluent.2.0.0.zip"
$stardewAccessUrl = "https://github.com/khanshoaib3/stardew-access/releases/download/v1.6.0-beta.1/stardew-access.1.6.0-beta.1.zip"

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

# Ask the user if they want to install SMAPI
$installSMAPI = Read-Host "Do you want to install SMAPI? (Enter 'Y' for yes, 'N' for no)"
if ($installSMAPI -eq "Y") {
    # Extract the SMAPI installer
    $smaPiExtractedPath = Join-Path $downloadsPath "SMAPI 4.0.0-alpha.20240310 installer for developers"
    if (-not (Test-Path $smaPiExtractedPath)) {
        try {
            Expand-Archive -Path $smaPiInstallerPath -DestinationPath $downloadsPath -Force
            Write-Host "SMAPI installer extracted successfully."
            Start-Sleep -Seconds 8
        } catch {
            Write-Host "Failed to extract SMAPI installer."
            exit
        }
    } else {
        Write-Host "SMAPI installer already extracted."
    }
    
    # Wait for the .bat to complete
    Write-Host "Waiting for SMAPI installation to finish..."
    
    # Navigate to the extracted directory and run install on Windows
    $batFilePath = Join-Path $smaPiExtractedPath "install on Windows.bat"
    if (Test-Path $batFilePath) {
        try {
            Set-Location $smaPiExtractedPath
            & ".\install on Windows.bat"
            Write-Host "SMAPI installed successfully."
            Start-Sleep -Seconds 8
        } catch {
            Write-Host "Failed to install SMAPI."
        }
    } else {
        Write-Host "Failed to find the SMAPI installation script."
    }
}

# Ask the user if they want to choose the mods installation directory
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

    # Download and install Project Fluent
    DownloadAndExtractZip -sourceUrl $projectFluentUrl -destinationPath $modsPath -fileName "ProjectFluent.zip"
    # Download and install Stardew Access
    DownloadAndExtractZip -sourceUrl $stardewAccessUrl -destinationPath $modsPath -fileName "StardewAccess.zip"

    # Report that the mod configuration was completed successfully
    Write-Host "Mod configuration completed successfully! Executing the game with mods..."
    Start-Sleep -Seconds 5

    # Open StardewModdingAPI.exe in File Explorer
    $gameFolderPath = $modsPath.Substring(0, $modsPath.LastIndexOf("\"))
    $stardewModdingAPIPath = Join-Path $gameFolderPath "StardewModdingAPI.exe"
    Start-Process $stardewModdingAPIPath
    
    # Pause for the user to read the message before closing the script
    Read-Host "Press Enter to close the script..."
} else {
    Write-Host "Mods folder was not created. Verify the SMAPI installation."
}
