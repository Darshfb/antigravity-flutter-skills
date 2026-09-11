$ErrorActionPreference = "Stop"

$GlobalDestination = Join-Path $HOME ".gemini\config\skills"

$Skills = @(
    "flutter-production-audit",
    "flutter-codebase-conventions",
    "flutter-state-management",
    "flutter-performance",
    "flutter-a11y-rtl",
    "flutter-responsive",
    "flutter-review-gate"
)

function Show-Usage {
    @"
Antigravity Flutter Skills Uninstaller

Usage:
  .\uninstall.ps1 --global
  .\uninstall.ps1 --project [path]
  .\uninstall.ps1 --help

Options:
  --global
      Remove the globally installed Antigravity Flutter Skills.

  --project [path]
      Remove the skills from a specific project's .agents\skills directory.
      Defaults to the current directory when no path is provided.

  --help
      Show this help message.

Examples:
  .\uninstall.ps1 --global
  .\uninstall.ps1 --project .
  .\uninstall.ps1 --project C:\Projects\my_flutter_app

Notes:
  This script removes only the seven skills managed by this repository.

  It does NOT remove the parent skills directory.

  It also does NOT touch the legacy directory:
    $HOME\.gemini\antigravity\skills
"@
}

function Remove-Skills {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    if ([string]::IsNullOrWhiteSpace($Destination)) {
        throw "Destination path is empty."
    }

    $Removed = 0
    $Missing = 0

    Write-Host ""
    Write-Host "Removing Antigravity Flutter Skills"
    Write-Host "==================================="
    Write-Host ""
    Write-Host "Destination:"
    Write-Host "  $Destination"
    Write-Host ""

    foreach ($Skill in $Skills) {
        $Target = Join-Path $Destination $Skill

        if (Test-Path $Target -PathType Container) {
            Remove-Item -Recurse -Force $Target
            Write-Host "✓ Removed $Skill"
            $Removed++
        }
        else {
            Write-Host "- $Skill was not installed"
            $Missing++
        }
    }

    Write-Host ""
    Write-Host "==================================="
    Write-Host "Uninstall complete."
    Write-Host ""
    Write-Host "Removed: $Removed"
    Write-Host "Already absent: $Missing"
    Write-Host ""

    if ($Removed -eq 0) {
        Write-Host "No managed Antigravity Flutter Skills were installed at:"
        Write-Host "  $Destination"
        Write-Host ""
    }
    else {
        Write-Host "Only the skills managed by this repository were removed."
        Write-Host "Other skills in the destination were left untouched."
        Write-Host ""
    }
}

if ($args.Count -lt 1) {
    Show-Usage
    exit 1
}

switch ($args[0]) {
    "--global" {
        Remove-Skills -Destination $GlobalDestination
    }

    "--project" {
        $ProjectPath = if ($args.Count -ge 2) { $args[1] } else { "." }

        if (-not (Test-Path $ProjectPath -PathType Container)) {
            throw "Project directory does not exist: $ProjectPath"
        }

        $ProjectPath = (Resolve-Path $ProjectPath).Path
        $ProjectDestination = Join-Path $ProjectPath ".agents\skills"

        Remove-Skills -Destination $ProjectDestination
    }

    "--help" {
        Show-Usage
    }

    "-h" {
        Show-Usage
    }

    default {
        Write-Host "Error: Unknown option: $($args[0])"
        Write-Host ""
        Show-Usage
        exit 1
    }
}