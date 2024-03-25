# Function to execute script based on language choice
function Execute-Script {
    param(
        [int]$LanguageChoice
    )
    switch ($LanguageChoice) {
        1 {
            Write-Host "You have chosen English."
            $scriptUrl = "https://github.com/azurejoga/Stardew-Valley-access-automatic/raw/main/stardew.ps1"
        }
        2 {
            Write-Host "Voce escolheu Portugues."
            $scriptUrl = "https://github.com/azurejoga/Stardew-Valley-access-automatic/raw/main/stardew-pt-br.ps1"
        }
        default {
            Write-Host "Invalid choice. Exiting." -ForegroundColor Red
            Exit
        }
    }

    # Download and execute script
    $scriptPath = "$env:TEMP\script.ps1"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    if ($?) {
        Write-Host "Script downloaded successfully. Executing..."
        powershell -File $scriptPath
        Remove-Item $scriptPath
    } else {
        Write-Host "Failed to download script. Exiting." -ForegroundColor Red
        Exit
    }
}

# Check if running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "You are not running this script as administrator. Re-launching with elevated permissions..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File",$MyInvocation.MyCommand.Path
    Exit
}

# Prompt user to select language
Write-Host "Select your language:"
Write-Host "1. English"
Write-Host "2. Portugues / Portuguese"
$languageChoice = Read-Host "Enter your choice (1 or 2)"

# Execute script based on language choice
Execute-Script -LanguageChoice $languageChoice
