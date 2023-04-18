param(
    [string]$searchPath = "."
)

function Get-ScriptSynopsis {
    param($filePath)
    $synopsis = ""
    $fileContent = Get-Content -Path $filePath
    $insideSynopsis = $false
    foreach ($line in $fileContent) {
        if ($line -match '<#') { $insideComment = $true }
        if ($insideComment -and $line -match '\.SYNOPSIS') {
            $insideSynopsis = $true
            $synopsis = ($line -replace '\.SYNOPSIS', '').Trim()
            continue
        }
        if ($insideSynopsis) {
            if ($line -match '\.DESCRIPTION') {
                break
            } else {
                $synopsis += " " + $line.Trim()
            }
        }
        if ($line -match '#>') { break }
    }
    return $synopsis
}

$files = Get-ChildItem -Path $searchPath -Filter *.ps1 -Recurse -File
$menu = @{}

for ($i = 0; $i -lt $files.Count; $i++) {
    $menu.Add($i + 1, $files[$i])
    $synopsis = Get-ScriptSynopsis -filePath $files[$i].FullName
    Write-Host ("{0}. {1} - {2}" -f ($i + 1), $files[$i].FullName, $synopsis)
}

$selected = Read-Host "Choose a file by number"
$selectedInt = [int]$selected
$selectedFile = $menu[$selectedInt]

if ($selectedFile) {
    Write-Host "You have chosen: $($selectedFile.FullName)"
    Write-Host "Executing $($selectedFile.FullName)..."
    Invoke-Expression $selectedFile.FullName
} else {
    Write-Host "Invalid selection"
}
