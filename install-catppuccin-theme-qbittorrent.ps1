$themesAndUrls = @{
	themes = @(
		"latte",
		"frappe",
		"macchiato",
		"mocha"
	)
	urls   = @(
		"https://github.com/catppuccin/qbittorrent/blob/main/latte.qbtheme",
		"https://github.com/catppuccin/qbittorrent/blob/main/frappe.qbtheme",
		"https://github.com/catppuccin/qbittorrent/blob/main/macchiato.qbtheme",
		"https://github.com/catppuccin/qbittorrent/blob/main/mocha.qbtheme"
	)
}

function chooseCatppuccinThemeQbittorrent($theme) {
	$index = $themesAndUrls.themes.IndexOf($theme)
	if ($index -ge 0) {
		$url = $themesAndUrls.urls[$index]
		$outputPath = "$env:USERPROFILE\Documents\qBittorrent\themes\$theme.qbtheme"
		
		Write-Host "Downloading $theme theme from $url..."
		Invoke-WebRequest -Uri $url -OutFile $outputPath
		Write-Host "$theme theme downloaded to $outputPath"
	}
	else {
		Write-Host "Theme '$theme' not found. Please choose a valid theme." -ForegroundColor Red
	}
}

# Validate that the lengths of both arrays are the same
if ($themesAndUrls.themes.Count -ne $themesAndUrls.urls.Count) {
	Write-Host "Error: The number of themes does not match the number of URLs." -ForegroundColor Red
	exit 1
}

# Display available themes with numbers
Write-Host "Available themes:"
for ($i = 0; $i -lt $themesAndUrls.themes.Count; $i++) {
	Write-Host "$($i + 1). $($themesAndUrls.themes[$i])"
}

# Prompt user to choose a theme by number or name
$chosenInput = Read-Host "Enter theme number(s) or name(s) to choose (e.g., '1-2', '1, 2', '1 2')"

# Split input into individual items
$chosenInputs = $chosenInput -split '[-,\s]+' | Where-Object { $_ -ne '' }

# Process each input item
foreach ($input in $chosenInputs) {
	# Determine if the input is a number or name
	if ($input -match '^\d+$') {
		$index = [int]$input - 1
		if ($index -ge 0 -and $index -lt $themesAndUrls.themes.Count) {
			$chosenTheme = $themesAndUrls.themes[$index]
			chooseCatppuccinThemeQbittorrent -theme $chosenTheme
		}
		else {
			Write-Host "Invalid theme number '$input'. Please choose a valid theme number." -ForegroundColor Red
		}
	}
	else {
		$chosenTheme = $input
		chooseCatppuccinThemeQbittorrent -theme $chosenTheme
	}
}
