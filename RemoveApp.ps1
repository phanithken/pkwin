param (
    [string]$appName = "Visual Studio Code",  # Default app name
    [string]$userName = $env:USERNAME         # Default to current user if not provided
)

# Define paths based on provided user
$installPath = "C:\Users\$userName\AppData\Local\Programs\$appName"
$appDataRoamingPath = "C:\Users\$userName\AppData\Roaming\$appName"
$appDataLocalPath = "C:\Users\$userName\AppData\Local\Programs\$appName"

# 1. Remove the installation folder
if (Test-Path $installPath) {
    Write-Host "Removing $appName installation directory: $installPath"
    Remove-Item -Recurse -Force $installPath
    Write-Host "$appName installation directory removed."
} else {
    Write-Host "$appName installation directory not found."
}

# 2. Remove the user data in AppData\Roaming
if (Test-Path $appDataRoamingPath) {
    Write-Host "Removing $appName user data from AppData\Roaming: $appDataRoamingPath"
    Remove-Item -Recurse -Force $appDataRoamingPath
    Write-Host "$appName data from AppData\Roaming removed."
} else {
    Write-Host "No $appName data found in AppData\Roaming."
}

# 3. Remove the user data in AppData\Local
if (Test-Path $appDataLocalPath) {
    Write-Host "Removing $appName data from AppData\Local: $appDataLocalPath"
    Remove-Item -Recurse -Force $appDataLocalPath
    Write-Host "$appName data from AppData\Local removed."
} else {
    Write-Host "No $appName data found in AppData\Local."
}

# 4. Remove registry entries associated with the app
$regUninstallPaths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach ($regPath in $regUninstallPaths) {
    $appKey = Get-ChildItem $regPath | Where-Object {
        (Get-ItemProperty $_.PSPath).DisplayName -like "*$appName*"
    }

    if ($appKey) {
        Write-Host "Removing $appName registry key at: $($appKey.PSPath)"
        Remove-Item -Path $appKey.PSPath -Recurse -Force
        Write-Host "$appName registry key removed."
    } else {
        Write-Host "No $appName registry key found in $regPath."
    }
}

Write-Host "$appName removal completed successfully."
