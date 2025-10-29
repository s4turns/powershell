<#
    .SYNOPSIS
    Installs a list of applications using winget, skipping those already installed.

    .DESCRIPTION
    This script iterates through a pre-defined list of application package IDs.
    For each application, it checks if it is already installed. If not, it uses
    winget to perform a silent installation. It also ensures winget is
    present before proceeding.
#>

# Check for winget installation
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "winget is not installed. Please install it from the Microsoft Store or via a package manager first."
    Write-Warning "You can use the following command to download the App Installer: winget install Microsoft.DesktopAppInstaller"
    exit
}

# ----------------------------------------------
# --- Customize this list with your apps ---
# ----------------------------------------------
$apps = @(
    # Utilities
    "Microsoft.PowerShell",          # Windows Powershell 7
    "7zip.7zip",                     # 7-Zip
    "VideoLAN.VLC",                  # VLC Media Player
    "IDRIX.VeraCrypt",               # VeraCrypt disk encryption software
	"WinSCP.WinSCP",                 # FTP
	"GIMP.GIMP.3",                   # Image editing
	
    # Browsers
    "Google.Chrome",                 # Google Chrome
    
    # Communication
    "Discord.Discord",               # Discord
    "9NKSQGP7F2NH",                  # WhatsApp

    # Developer Tools
    "Microsoft.VisualStudioCode",    # Visual Studio Code
    "Git.Git",                       # Git
    "Docker.DockerDesktop",          # Docker Desktop
    
    # Productivity
    "Spotify.Spotify",               # Spotify
    "Notepad++.Notepad++",           # Notepad++
    
    # Cloud Storage
    "Google.GoogleDrive"             # Google Drive for desktop
)

# ----------------------------------------------
# --- Installation Logic ---
# ----------------------------------------------
Write-Host "Starting batch installation of applications with winget..." -ForegroundColor Green

foreach ($appId in $apps) {
    Write-Host "`nChecking for '$appId'..." -ForegroundColor Cyan

    # Check if the app is already installed
    $isInstalled = winget list --id $appId --accept-source-agreements --disable-interactivity 2>&1
    if ($isInstalled -match "No installed package found") {
        Write-Host "Installing '$appId'..." -ForegroundColor Green
        try {
            winget install --id $appId --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
            Write-Host "Successfully installed '$appId'." -ForegroundColor Green
        } catch {
            Write-Error "Failed to install '$appId'. Error: $($_.Exception.Message)"
        }
    } else {
        Write-Host "'$appId' is already installed. Skipping."
    }
}

Write-Host "`nInstallation process completed." -ForegroundColor Green

