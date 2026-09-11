$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Antigravity Flutter Skills - Windows Installer
#
# Installs the seven managed Flutter skills either globally
# or into a specific project.
# ------------------------------------------------------------

$RepoDir = $PSScriptRoot
$SkillsDir = Join-Path $RepoDir "skills"
$VerifyScript = Join-Path $RepoDir "verify.ps1"

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
Antigravity Flutter Skills Installer

Usage:
  .\install.ps1 --global
  .\install.ps1 --project [path]
  .\install.ps1 --help

Options:
  --global
      Install the skills globally for Antigravity projects.

  --project [path]
      Install the skills into a specific project's .agents\skills directory.
      Defaults to the current directory when no path is provided.

  --help
      Show this help message.

Examples:
  .\install.ps1 --global
  .\install.ps1 --project .
  .\install.ps1 --project C:\Projects\my_flutter_app
"@
}

function Test-LegacyInstallation {
    $LegacyDirectory = Join-Path $HOME ".gemini\antigravity\skills"

    if (-not (Test-Path $LegacyDirectory -PathType Container)) {
        return
    }

    $FoundLegacySkill = $false

    foreach ($Skill in $Skills) {
        $LegacySkillPath = Join-Path $LegacyDirectory $Skill

        if (Test-Path $LegacySkillPath -PathType Container) {
            $FoundLegacySkill = $true
            break
        }
    }

    if ($FoundLegacySkill) {
        Write-Host ""
        Write-Host "Warning: older copies of these skills were found in:"
        Write-Host ""
        Write-Host "  $LegacyDirectory"
        Write-Host ""
        Write-Host "Antigravity may load a different copy than the one installed into:"
        Write-Host ""
        Write-Host "  $HOME\.gemini\config\skills"
        Write-Host ""
        Write-Host "Consider removing the old copies after confirming they are no longer needed."
        Write-Host ""
        Write-Host "This installer will NOT delete them automatically."
    }
}

function Invoke-RepositoryVerification {
    if (-not (Test-Path $VerifyScript -PathType Leaf)) {
        throw "Verification script is missing: $VerifyScript"
    }

    Write-Host ""
    Write-Host "Verifying repository before installation..."
    Write-Host ""

    & $VerifyScript

    if ($LASTEXITCODE -ne 0) {
        throw "Repository verification failed. Installation aborted."
    }
}

function Install-Skills {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    if ([string]::IsNullOrWhiteSpace($Destination)) {
        throw "Destination path is empty."
    }

    if (-not (Test-Path $SkillsDir -PathType Container)) {
        throw "Skills directory does not exist: $SkillsDir"
    }

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null

    Write-Host ""
    Write-Host "Installing Antigravity Flutter Skills"
    Write-Host "====================================="
    Write-Host ""
    Write-Host "Source:"
    Write-Host "  $SkillsDir"
    Write-Host ""
    Write-Host "Destination:"
    Write-Host "  $Destination"
    Write-Host ""

    foreach ($Skill in $Skills) {
        $SourceDirectory = Join-Path $SkillsDir $Skill
        $SkillFile = Join-Path $SourceDirectory "SKILL.md"
        $DestinationDirectory = Join-Path $Destination $Skill

        if (-not (Test-Path $SkillFile -PathType Leaf)) {
            throw "Missing skill file: $SkillFile"
        }

        if (Test-Path $DestinationDirectory) {
            Remove-Item -Recurse -Force $DestinationDirectory
        }

        Copy-Item `
            -Path $SourceDirectory `
            -Destination $DestinationDirectory `
            -Recurse `
            -Force

        Write-Host "✓ $Skill"
    }

    Write-Host ""
    Write-Host "====================================="
    Write-Host ""
    Write-Host "Installation complete."
    Write-Host ""
    Write-Host "Installed to:"
    Write-Host "  $Destination"
    Write-Host ""
    Write-Host "Restart Antigravity or start a new conversation/session"
    Write-Host "so the updated skills are discovered."
    Write-Host ""
}

# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

if ($args.Count -lt 1) {
    Show-Usage
    exit 1
}

$Mode = $args[0]

switch ($Mode) {

    "--global" {
        Invoke-RepositoryVerification

        Test-LegacyInstallation

        $GlobalDestination = Join-Path $HOME ".gemini\config\skills"

        Install-Skills -Destination $GlobalDestination
    }

    "--project" {
        $ProjectPath = if ($args.Count -ge 2) {
            $args[1]
        }
        else {
            "."
        }

        if (-not (Test-Path $ProjectPath -PathType Container)) {
            throw "Project directory does not exist: $ProjectPath"
        }

        $ProjectPath = (Resolve-Path $ProjectPath).Path
        $ProjectDestination = Join-Path $ProjectPath ".agents\skills"

        Invoke-RepositoryVerification

        Install-Skills -Destination $ProjectDestination
    }

    "--help" {
        Show-Usage
    }

    "-h" {
        Show-Usage
    }

    default {
        Write-Host "Error: Unknown option: $Mode"
        Write-Host ""
        Show-Usage
        exit 1
    }
}