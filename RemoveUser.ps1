param (
    [string]$userName
)

if (-not $userName) {
    Write-Host "Please provide a username to remove. Usage: .\RemoveUser.ps1 -userName <username>"
}

# Check if the user exists
$user = Get-WmiObject Win32_UserAccount -Filter "Name='$userName'"
if ($user -eq $null) {
    Write-Host "User '$userName' does not exist on this system."
} else {
    # Remove the user account
    try {
        Write-Host "Removing user '$userName'..."
        net user $userName /delete
        Write-Host "User '$userName' removed successfully."
    } catch {
        Write-Host "Error while removing user account: $_"
    }
}

# Get the user's profile path
try {
    $userProfile = Get-WmiObject Win32_UserProfile | Where-Object { $_.LocalPath -like "*$userName" }
    if ($userProfile -ne $null) {
        Write-Host "Removing profile for user '$userName'..."
        Remove-Item -Path $userProfile.LocalPath -Recurse -Force
        Write-Host "Profile directory for '$userName' removed."
    } else {
        Write-Host "No profile found for user '$userName'. Proceeding to registry clean up."
    }
} catch {
    Write-Host "Error while removing profile directory: $_"
}

# Remove registry entries associated with the user's profile
try {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
    $profileKey = Get-ChildItem $regPath | Where-Object { (Get-ItemProperty $_.PSPath).ProfileImagePath -like "*$userName*" }
    if ($profileKey -ne $null) {
        Write-Host "Removing registry entry for user profile '$userName'..."
        Remove-Item -Path $profileKey.PSPath -Recurse -Force
        Write-Host "Registry entry for '$userName' removed."
    } else {
        Write-Host "No registry entry found for user profile '$userName'."
    }
} catch {
    Write-Host "Error while removing registry entries: $_"
}

# Optionally, remove user-specific scheduled tasks, cached files, or any other user-specific data.
try {
    $tasks = Get-ScheduledTask | Where-Object {$_.Principal.UserId -like "*$userName"}
    if ($tasks) {
        Write-Host "Removing scheduled tasks for '$userName'..."
        foreach ($task in $tasks) {
            Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
        }
        Write-Host "Scheduled tasks for '$userName' removed."
    }
} catch {
    Write-Host "Error while removing scheduled tasks: $_"
}

Write-Host "Clean-up for user '$userName' completed successfully."