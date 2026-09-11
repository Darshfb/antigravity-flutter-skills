$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Antigravity Flutter Skills - Windows Installer
#
# Installs the seven managed Flutter skills either globally
# or into a specific project.
#
# Repository verification runs before installation.
# ------------------------------------------------------------

$RepoDir = $PSScriptRoot
$SkillsDir = Join-Path $RepoDir "skills"
$VerifyScript = Join-Path $RepoDir "verify.ps1"

$GlobalDestination = Join-Path $HOME ".gemini\config\skills"
$LegacyGlobalDestination = Join-Path $HOME ".gemini\antigravity\skills"

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
      Install the skills globally for the current user.

  --project [path]
      Install the skills only into a specific project.
      Defaults to the current directory when no path is provided.

  --help
      Show this help message.

Examples:
  .\install.ps1 --global
  .\install.ps1 --project .
  .\install.ps1 --project C:\Projects\my_flutter_app
"@
}

function Get-PowerShellExecutable {
    # Prefer the same PowerShell generation currently running this script.

    if ($PSVersionTable.PSEdition -eq "Core") {
        $Candidate = Join-Path $PSHOME "pwsh.exe"

        if (Test-Path $Candidate -PathType Leaf) {
            return $Candidate
        }

        return "pwsh"
    }

    $Candidate = Join-Path $PSHOME "powershell.exe"

    if (Test-Path $Candidate -PathType Leaf) {
        return $Candidate
    }

    return "powershell"
}

function Run-Verification {
    Write-Host ""
    Write-Host "Verifying repository before installation..."
    Write-Host ""

    if (-not (Test-Path $VerifyScript -PathType Leaf)) {
        throw "verify.ps1 was not found: $VerifyScript"
    }

    $PowerShellExecutable = Get-PowerShellExecutable

    & $PowerShellExecutable `
        -NoProfile `
        -ExecutionPolicy Bypass `
        -File $VerifyScript

    if ($LASTEXITCODE -ne 0) {
        throw "Repository verification failed. Installation aborted."
    }
}

function Check-LegacyGlobalInstallation {
    $Found = $false

    foreach ($Skill in $Skills) {
        $LegacyPath = Join-Path $LegacyGlobalDestination $Skill

        if (Test-Path $LegacyPath -PathType Container) {
            $Found = $true
            break
        }
    }

    if ($Found) {
        Write-Host ""
        Write-Host "Warning: older copies of these skills were found in:"
        Write-Host ""
        Write-Host "  $LegacyGlobalDestination"
        Write-Host ""
        Write-Host "Antigravity may load a different copy than the one installed into:"
        Write-Host ""
        Write-Host "  $GlobalDestination"
        Write-Host ""
        Write-Host "Consider removing the old copies after confirming they are no longer needed."
        Write-Host ""
        Write-Host "This installer will NOT delete them automatically."
        Write-Host ""
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
        $SourceDir = Join-Path $SkillsDir $Skill
        $DestinationDir = Join-Path $Destination $Skill
        $SkillFile = Join-Path $SourceDir "SKILL.md"

        if (-not (Test-Path $SkillFile -PathType Leaf)) {
            throw "Missing skill file: $SkillFile"
        }

        if (Test-Path $DestinationDir) {
            Remove-Item -Recurse -Force $DestinationDir
        }

        Copy-Item `
            -Path $SourceDir `
            -Destination $DestinationDir `
            -Recurse `
            -Force

        Write-Host "✓ $Skill"
    }

    Write-Host ""
    Write-Host "====================================="
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
        Run-Verification
        Check-LegacyGlobalInstallation
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

        Run-Verification
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