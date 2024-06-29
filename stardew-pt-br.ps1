# Download directory
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
# SMAPI installer path
$smaPiInstallerPath = Join-Path $downloadsPath "SMAPI.zip"
# Default mod directory path
$defaultModsPath = "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods"

# URLs for download of SMAPI, Project Fluent, Stardew Access, GlueFurnitureDown, AutoFish, and Kokoro
$smaPiUrl = "https://github.com/Pathoschild/SMAPI/releases/download/4.0.8/SMAPI-4.0.8-installer.zip"
$projectFluentUrl = "https://github.com/Shockah/Stardew-Valley-Mods/releases/download/release%2Fproject-fluent%2F2.0.0/ProjectFluent.2.0.0.zip"
$stardewAccessUrl = "https://github.com/khanshoaib3/stardew-access/releases/download/v1.5.1/stardew-access-1.5.1.zip"
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
        Write-Host "Baixando $fileName... espere..."
        Invoke-WebRequest -Uri $sourceUrl -OutFile $zipFilePath -UseBasicParsing
        Start-Sleep -Seconds 8
        Expand-Archive -Path $zipFilePath -DestinationPath $destinationPath -Force
        Write-Host "Baixado e extraído: $fileName"
    } catch {
        Write-Host "Falha ao baixar e extrair: $fileName"
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
    Write-Host "Atalho criado no Desktop."
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
        Write-Host "Conquistas habilitadas para API Stardew Modding."
    } else {
        Write-Host "Atalho nao encontrado na area de trabalho."
    }
}

# Ask the user if they want to install SMAPI
$installSMAPI = Read-Host "Deseja instalar o SMAPI? (Digite 'Y' para sim, 'N' para não)"
if ($installSMAPI -eq "Y") {
    # Check if the SMAPI file already exists before downloading it
    if (-not (Test-Path $smaPiInstallerPath)) {
        try {
            # Download SMAPI
            DownloadAndExtractZip -sourceUrl $smaPiUrl -destinationPath $downloadsPath -fileName "SMAPI.zip"
            Write-Host "SMAPI baixado com sucesso."
        } catch {
            Write-Host "Falha ao baixar SMAPI."
            exit
        }
    } else {
        Write-Host "O instalador SMAPI já existe."
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
        Write-Host "$batFilePath executado a partir do diretório SMAPI."
    } else {
        Write-Host "Arquivo .bat não encontrado no diretório SMAPI."
    }
} else {
    Write-Host "Diretório SMAPI não encontrado nos arquivos extraídos."
}

# Ask the user if they want to choose the installation directory for the mods
$customModsPathChoice = Read-Host "Quer escolher o diretório de instalação dos mods? (Digite 'Y' para sim, 'N' para não)"
if ($customModsPathChoice -eq "Y") {
    # Use the native Windows explorer to choose the directory
    $modsPath = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Escolha o diretório de instalação dos mods", 0, $defaultModsPath).Self.Path
} else {
    # Use the default directory
    $modsPath = $defaultModsPath
}

# Check if the mods folder was created
if (Test-Path $modsPath) {
    Write-Host "A pasta Mods existe em: $modsPath."
}

# Ask the user if they want to download and install Project Fluent
$downloadProjectFluent = Read-Host "Deseja baixar e instalar o Project Fluent? (Digite 'Y' para sim, 'N' para não)"
if ($downloadProjectFluent -eq "Y") {
    DownloadAndExtractZip -sourceUrl $projectFluentUrl -destinationPath $modsPath -fileName "ProjectFluent.zip"
}

# Ask the user if they want to download and install Stardew Access
$downloadStardewAccess = Read-Host "Quer baixar e instalar o Stardew Access? (Digite 'Y' para sim, 'N' para não)"
if ($downloadStardewAccess -eq "Y") {
    DownloadAndExtractZip -sourceUrl $stardewAccessUrl -destinationPath $modsPath -fileName "StardewAccess.zip"
}

# Ask the user if they want to download and install GlueFurnitureDown
$downloadGlueFurnitureDown = Read-Host "Quer baixar e instalar o GlueFurnitureDown? (Digite 'Y' para sim, 'N' para não)"
if ($downloadGlueFurnitureDown -eq "Y") {
    DownloadAndExtractZip -sourceUrl $glueFurnitureDownUrl -destinationPath $modsPath -fileName "GlueFurnitureDown.zip"
}

# Ask the user if they want to download and install AutoFish
$downloadAutoFish = Read-Host "Quer baixar e instalar o AutoFish? (Digite 'Y' para sim, 'N' para não)"
if ($downloadAutoFish -eq "Y") {
    DownloadAndExtractZip -sourceUrl $autoFishUrl -destinationPath $modsPath -fileName "AutoFish.zip"
}

# Ask the user if they want to download and install Kokoro
$downloadKokoro = Read-Host "Quer baixar e instalar o Kokoro? (Digite 'Y' para sim, 'N' para não)"
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
        Write-Host "Executável do jogo não encontrado."
    }
}

# Find the StardewModdingAPI executable
$stardewModdingAPIPath = Get-ChildItem -Path (Join-Path (Split-Path $modsPath -Parent) "StardewModdingAPI.exe") -Recurse | Where-Object { $_.Name -eq "StardewModdingAPI.exe" } | Select-Object -ExpandProperty FullName

# Ask the user if they want to create a shortcut on the desktop
$createShortcut = Read-Host "Quer criar um atalho na área de trabalho? (Digite 'Y' para sim, 'N' para não)"
if ($createShortcut -eq "Y") {
    # Create a shortcut on the desktop for Stardew Modding API
    CreateDesktopShortcut -executablePath $stardewModdingAPIPath -shortcutName "StardewModdingAPI"
}

# Ask the user if they want to enable achievements
$enableAchievements = Read-Host "Você deseja habilitar conquistas para a API Stardew Modding? (Digite 'Y' para sim, 'N' para não)"
if ($enableAchievements -eq "Y") {
    # Enable achievements for Stardew Modding API shortcut
    EnableAchievements -shortcutName "StardewModdingAPI"
}

# Ask the user if they want to execute the game with mods
$executeGame = Read-Host "Quer executar o jogo com mods agora? (Digite 'Y' para sim, 'N' para não)"
if ($executeGame -eq "Y") {
    # Execute the game with mods
    ExecuteGameWithMods -gameExecutablePath $stardewModdingAPIPath
}

# Report that the mod configuration was completed successfully
Write-Host "Configuração do mod concluída com sucesso!"

