#? ENV Path
# New paths to be added
$spotifyPath = "$env:APPDATA\Spotify\"
$wingetUIPath = "$env:ProgramFiles\WingetUI\"

# Get the current user PATH environment variable
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Split the current PATH into an array of paths
$currentPathsArray = $currentPath -split ';'

# Initialize a list to hold unique paths
$newPathsList = [System.Collections.Generic.List[string]]::new()

# Add existing paths and clear blank paths in the list
foreach ($path in $currentPathsArray) {
    if (-not [string]::IsNullOrEmpty($path)) {
        $newPathsList.Add($path)
    }
}

function Add-PathIfNotExists {
    param (
        [string]$path,
        [System.Collections.Generic.List[string]]$pathList
    )
    if (-not $pathList.Contains($path)) {
        $pathList.Add($path)
    }
}

# Add the new paths if they don't already exist
Add-PathIfNotExists -path $spotifyPath -pathList $newPathsList
Add-PathIfNotExists -path $wingetUIPath -pathList $newPathsList

# Combine the list with semicolons
$newPath = [string]::Join(';', $newPathsList)

# Set the new PATH environment variable
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")