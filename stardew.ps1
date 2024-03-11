# URL do SMAPI
$smaPiUrl = "https://github.com/Pathoschild/SMAPI/releases/download/3.18.6/SMAPI-3.18.6-installer.zip"
# Diretório de download
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
# Caminho do instalador do SMAPI
$smaPiInstallerPath = Join-Path $downloadsPath "SMAPI.zip"
# Caminho padrão do diretório de mods
$defaultModsPath = "C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods"

# URLs para download do Project Fluent e Stardew Access
$projectFluentUrl = "https://github.com/Shockah/Stardew-Valley-Mods/releases/download/release%2Fproject-fluent%2F1.1.0/ProjectFluent.1.1.0.zip"
$stardewAccessUrl = "https://github.com/khanshoaib3/stardew-access/releases/download/v1.5.1/stardew-access-1.5.1.zip"

# Função para baixar e extrair arquivos zip
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

# Verificar se o arquivo do SMAPI já existe antes de baixá-lo
if (-not (Test-Path $smaPiInstallerPath)) {
    try {
        # Baixar o SMAPI
        DownloadAndExtractZip -sourceUrl $smaPiUrl -destinationPath $downloadsPath -fileName "SMAPI.zip"
        Write-Host "SMAPI downloaded successfully."
    } catch {
        Write-Host "Failed to download SMAPI."
        exit
    }
} else {
    Write-Host "SMAPI installer already exists."
}

# Perguntar ao usuário se eles querem instalar o SMAPI
$installSMAPI = Read-Host "Do you want to install SMAPI? (Enter 'Y' for yes, 'N' for no)"
if ($installSMAPI -eq "Y") {
    # Extrair o instalador do SMAPI
    $smaPiExtractedPath = Join-Path $downloadsPath "SMAPI 3.18.6 installer"
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
    
    # Aguardar a conclusão do .bat
    Write-Host "Waiting for SMAPI installation to finish..."
    
    # Navegar até o diretório extraído e executar install on Windows
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

# Perguntar ao usuário se eles querem escolher o diretório de instalação dos mods
$customModsPathChoice = Read-Host "Do you want to choose the installation directory for the mods? (Enter 'Y' for yes, 'N' for no)"
if ($customModsPathChoice -eq "Y") {
    # Usar o explorador nativo do Windows para escolher o diretório
    $modsPath = (New-Object -ComObject Shell.Application).BrowseForFolder(0, "Choose the mod installation directory", 0, $defaultModsPath).Self.Path
} else {
    # Usar o diretório padrão
    $modsPath = $defaultModsPath
}

# Verificar se a pasta de mods foi criada
if (Test-Path $modsPath) {
    Write-Host "Mods folder exists in: $modsPath."

    # Baixar e instalar o Project Fluent
    DownloadAndExtractZip -sourceUrl $projectFluentUrl -destinationPath $modsPath -fileName "ProjectFluent.zip"
    # Baixar e instalar o Stardew Access
    DownloadAndExtractZip -sourceUrl $stardewAccessUrl -destinationPath $modsPath -fileName "StardewAccess.zip"

    # Informar que a configuração do mod foi concluída com sucesso
    Write-Host "Mod configuration completed successfully! Executing the game with mods..."
    Start-Sleep -Seconds 5

    # Abrir o StardewModdingAPI.exe no Explorador de Arquivos
    $gameFolderPath = $modsPath.Substring(0, $modsPath.LastIndexOf("\"))
    $stardewModdingAPIPath = Join-Path $gameFolderPath "StardewModdingAPI.exe"
    Start-Process $stardewModdingAPIPath
    
    # Pausa para o usuário ler a mensagem antes de fechar o script
    Read-Host "Press Enter to close the script..."
} else {
    Write-Host "Mods folder was not created. Verify the SMAPI installation."
}
