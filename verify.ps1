$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Antigravity Flutter Skills - Windows Verification Script
#
# Validates repository structure, skill metadata, examples,
# Bash tooling presence, and PowerShell script syntax.
#
# This script is read-only:
# it does not install, modify, rename, or delete anything.
# ------------------------------------------------------------

$RepoDir = $PSScriptRoot
$SkillsDir = Join-Path $RepoDir "skills"
$ExamplesDir = Join-Path $RepoDir "examples"

$Errors = 0
$Warnings = 0

$ExpectedSkills = @(
    "flutter-production-audit",
    "flutter-codebase-conventions",
    "flutter-state-management",
    "flutter-performance",
    "flutter-a11y-rtl",
    "flutter-responsive",
    "flutter-review-gate"
)

$ExpectedExamples = @(
    "README.md",
    "full-project-audit.md",
    "targeted-feature-audit.md",
    "bug-investigation.md",
    "performance-audit.md",
    "state-management-audit.md",
    "responsive-ui-audit.md",
    "accessibility-rtl-audit.md",
    "codebase-consistency-audit.md",
    "pre-release-audit.md",
    "implement-approved-audit-plan.md",
    "post-implementation-review.md"
)

$ExpectedBashScripts = @(
    "install.sh",
    "uninstall.sh",
    "verify.sh"
)

$ExpectedPowerShellScripts = @(
    "install.ps1",
    "uninstall.ps1",
    "verify.ps1"
)

function Write-Ok {
    param([string]$Message)

    Write-Host "  ✓ $Message"
}

function Write-Failure {
    param([string]$Message)

    Write-Host "  ✗ $Message"
    $script:Errors++
}

function Write-WarningMessage {
    param([string]$Message)

    Write-Host "  ! $Message"
    $script:Warnings++
}

function Write-Section {
    param([string]$Message)

    Write-Host ""
    Write-Host $Message
}

Write-Host ""
Write-Host "Antigravity Flutter Skills Verification"
Write-Host "======================================="
Write-Host "Repository: $RepoDir"

# ------------------------------------------------------------
# 1. Repository structure
# ------------------------------------------------------------

Write-Section "Repository structure"

if (Test-Path $SkillsDir -PathType Container) {
    Write-Ok "skills/ directory exists"
}
else {
    Write-Failure "skills/ directory is missing"
}

if (Test-Path $ExamplesDir -PathType Container) {
    Write-Ok "examples/ directory exists"
}
else {
    Write-Failure "examples/ directory is missing"
}

$RequiredRootFiles = @(
    "README.md",
    "install.sh",
    "uninstall.sh",
    "verify.sh",
    "install.ps1",
    "uninstall.ps1",
    "verify.ps1"
)

foreach ($File in $RequiredRootFiles) {
    $Path = Join-Path $RepoDir $File

    if (Test-Path $Path -PathType Leaf) {
        Write-Ok "$File exists"
    }
    else {
        Write-Failure "$File is missing"
    }
}

# ------------------------------------------------------------
# 2. Skill files
# ------------------------------------------------------------

Write-Section "Skill files"

foreach ($Skill in $ExpectedSkills) {
    $SkillFile = Join-Path (Join-Path $SkillsDir $Skill) "SKILL.md"

    if (Test-Path $SkillFile -PathType Leaf) {
        Write-Ok "$Skill/SKILL.md"
    }
    else {
        Write-Failure "$Skill/SKILL.md is missing"
    }
}

# ------------------------------------------------------------
# 3. Skill metadata
# ------------------------------------------------------------

Write-Section "Skill metadata"

foreach ($Skill in $ExpectedSkills) {
    $SkillFile = Join-Path (Join-Path $SkillsDir $Skill) "SKILL.md"

    if (-not (Test-Path $SkillFile -PathType Leaf)) {
        continue
    }

    $Lines = @(Get-Content -LiteralPath $SkillFile)

    if ($Lines.Count -eq 0) {
        Write-Failure "$Skill: SKILL.md is empty"
        continue
    }

    if ($Lines[0].Trim() -ne "---") {
        Write-Failure "$Skill: YAML frontmatter does not start with ---"
        continue
    }

    $ClosingIndex = $null

    for ($i = 1; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i].Trim() -eq "---") {
            $ClosingIndex = $i
            break
        }
    }

    if ($null -eq $ClosingIndex) {
        Write-Failure "$Skill: YAML frontmatter has no closing ---"
        continue
    }

    if ($ClosingIndex -le 1) {
        Write-Failure "$Skill: YAML frontmatter is empty"
        continue
    }

    $Frontmatter = $Lines[1..($ClosingIndex - 1)]

    $NameLine = $Frontmatter |
        Where-Object { $_ -match '^name:\s*' } |
        Select-Object -First 1

    $DescriptionLine = $Frontmatter |
        Where-Object { $_ -match '^description:\s*' } |
        Select-Object -First 1

    if (-not $NameLine) {
        Write-Failure "$Skill: frontmatter is missing name"
    }
    else {
        $DeclaredName = ($NameLine -replace '^name:\s*', '').Trim()

        if ($DeclaredName -eq $Skill) {
            Write-Ok "$Skill: name is valid"
        }
        else {
            Write-Failure "$Skill: declared name is '$DeclaredName'"
        }
    }

    if (-not $DescriptionLine) {
        Write-Failure "$Skill: frontmatter is missing description"
    }
    else {
        $Description = ($DescriptionLine -replace '^description:\s*', '').Trim()

        if ([string]::IsNullOrWhiteSpace($Description)) {
            Write-Failure "$Skill: description is empty"
        }
        else {
            Write-Ok "$Skill: description exists"
        }
    }
}

# ------------------------------------------------------------
# 4. Example prompts
# ------------------------------------------------------------

Write-Section "Example prompts"

foreach ($Example in $ExpectedExamples) {
    $ExampleFile = Join-Path $ExamplesDir $Example

    if (-not (Test-Path $ExampleFile -PathType Leaf)) {
        Write-Failure "$Example is missing"
        continue
    }

    $Item = Get-Item -LiteralPath $ExampleFile

    if ($Item.Length -eq 0) {
        Write-Failure "$Example exists but is empty"
    }
    else {
        Write-Ok "$Example exists"
    }
}

# ------------------------------------------------------------
# 5. Bash scripts
# ------------------------------------------------------------

Write-Section "Bash scripts"

foreach ($Script in $ExpectedBashScripts) {
    $ScriptPath = Join-Path $RepoDir $Script

    if (Test-Path $ScriptPath -PathType Leaf) {
        Write-Ok "$Script exists"
    }
    else {
        Write-Failure "$Script is missing"
    }
}

# Optional Bash syntax validation on Windows if bash is installed.

$BashCommand = Get-Command bash -ErrorAction SilentlyContinue

if ($BashCommand) {
    foreach ($Script in $ExpectedBashScripts) {
        $ScriptPath = Join-Path $RepoDir $Script

        if (-not (Test-Path $ScriptPath -PathType Leaf)) {
            continue
        }

        & bash -n $ScriptPath

        if ($LASTEXITCODE -eq 0) {
            Write-Ok "$Script has valid Bash syntax"
        }
        else {
            Write-Failure "$Script contains Bash syntax errors"
        }
    }
}
else {
    Write-WarningMessage "bash is not installed; .sh syntax validation was skipped"
}

# ------------------------------------------------------------
# 6. PowerShell scripts
# ------------------------------------------------------------

Write-Section "PowerShell scripts"

foreach ($Script in $ExpectedPowerShellScripts) {
    $ScriptPath = Join-Path $RepoDir $Script

    if (-not (Test-Path $ScriptPath -PathType Leaf)) {
        Write-Failure "$Script is missing"
        continue
    }

    Write-Ok "$Script exists"

    $Tokens = $null
    $ParseErrors = $null

    [System.Management.Automation.Language.Parser]::ParseFile(
        $ScriptPath,
        [ref]$Tokens,
        [ref]$ParseErrors
    ) | Out-Null

    if ($ParseErrors.Count -eq 0) {
        Write-Ok "$Script has valid PowerShell syntax"
    }
    else {
        Write-Failure "$Script contains PowerShell syntax errors"

        foreach ($ParseError in $ParseErrors) {
            Write-Host "      $($ParseError.Message)"
        }
    }
}

# ------------------------------------------------------------
# 7. Unexpected skill directories
# ------------------------------------------------------------

Write-Section "Unexpected skills"

if (Test-Path $SkillsDir -PathType Container) {
    $Unexpected = @(
        Get-ChildItem -LiteralPath $SkillsDir -Directory |
        Where-Object {
            $ExpectedSkills -notcontains $_.Name
        }
    )

    if ($Unexpected.Count -eq 0) {
        Write-Ok "No unexpected skill directories found"
    }
    else {
        foreach ($Directory in $Unexpected) {
            Write-WarningMessage "Unexpected skill directory: $($Directory.Name)"
        }
    }
}

# ------------------------------------------------------------
# 8. Final result
# ------------------------------------------------------------

Write-Host ""
Write-Host "======================================="

if ($Errors -eq 0) {
    Write-Host "Verification PASSED"
    Write-Host "Errors:   0"
    Write-Host "Warnings: $Warnings"
    Write-Host "======================================="
    Write-Host ""

    exit 0
}

Write-Host "Verification FAILED"
Write-Host "Errors:   $Errors"
Write-Host "Warnings: $Warnings"
Write-Host "======================================="
Write-Host ""

exit 1