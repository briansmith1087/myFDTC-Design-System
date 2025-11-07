param(
    [string]$Entry = "src\index.css",
    [string]$Out   = "dist\fdtc.css"
)

$ErrorActionPreference = "Stop"

function Resolve-Css {
    param(
        [string]$FilePath,
        [ref]$Visited
    )

    if (-not (Test-Path $FilePath)) {
        throw "CSS file not found: $FilePath"
    }

    $full = (Resolve-Path $FilePath).Path
    if ($Visited.Value.Contains($full)) {
        return ""  # already included
    }
    $Visited.Value.Add($full) | Out-Null

    $dir = Split-Path $full
    $lines = Get-Content -LiteralPath $full -Encoding UTF8

    $sb = New-Object System.Text.StringBuilder

    foreach ($line in $lines) {
        # Match: @import "path"; or @import 'path';
        if ($line -match '^\s*@import\s+["''](.+?)["'']\s*;') {
            $rel = $Matches[1]
            $child = Join-Path $dir $rel
            [void]$sb.Append( (Resolve-Css -FilePath $child -Visited ([ref]$Visited.Value)) )
            [void]$sb.Append("`n")
        } else {
            [void]$sb.Append($line)
            [void]$sb.Append("`n")
        }
    }

    $sb.ToString()
}

# Ensure dist directory exists
$distDir = Split-Path -Path $Out
if (-not (Test-Path $distDir)) { New-Item -ItemType Directory -Path $distDir | Out-Null }

# Build
$visited = New-Object System.Collections.Generic.HashSet[string]
$content = Resolve-Css -FilePath $Entry -Visited ([ref]$visited)

# Banner
$banner = "/* FDTC Design System bundle`n   Built: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ssK')`n   Entry: $Entry`n*/`n"
$content = $banner + $content

# Force LF and write UTF-8 (no BOM)
$content = $content -replace "`r`n","`n" -replace "`r","`n"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Compute a full path without requiring file to exist yet
$fullOut = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Out))
[System.IO.File]::WriteAllText($fullOut, $content, $utf8NoBom)

Write-Host "Wrote $Out ($(Get-Item $Out).Length) bytes."
