#!/usr/bin/env bash

set -u

# ------------------------------------------------------------
# Antigravity Flutter Skills - Repository Verification
#
# Validates repository structure, skill metadata, examples,
# and cross-platform installer scripts.
#
# This script is read-only:
# it does not install, modify, rename, or delete anything.
# ------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
EXAMPLES_DIR="$SCRIPT_DIR/examples"

ERRORS=0
WARNINGS=0

EXPECTED_SKILLS=(
  "flutter-production-audit"
  "flutter-codebase-conventions"
  "flutter-state-management"
  "flutter-performance"
  "flutter-a11y-rtl"
  "flutter-responsive"
  "flutter-review-gate"
)

EXPECTED_EXAMPLES=(
  "full-project-audit.md"
  "implement-approved-audit-plan.md"
)

EXPECTED_BASH_SCRIPTS=(
  "install.sh"
  "uninstall.sh"
  "verify.sh"
)

EXPECTED_POWERSHELL_SCRIPTS=(
  "install.ps1"
  "uninstall.ps1"
  "verify.ps1"
)

ok() {
  printf "  ✓ %s\n" "$1"
}

error() {
  printf "  ✗ %s\n" "$1"
  ERRORS=$((ERRORS + 1))
}

warning() {
  printf "  ! %s\n" "$1"
  WARNINGS=$((WARNINGS + 1))
}

section() {
  printf "\n%s\n" "$1"
}

printf "\n"
printf "Antigravity Flutter Skills Verification\n"
printf "=======================================\n"
printf "Repository: %s\n" "$SCRIPT_DIR"

# ------------------------------------------------------------
# 1. Repository structure
# ------------------------------------------------------------

section "Repository structure"

if [[ -d "$SKILLS_DIR" ]]; then
  ok "skills/ directory exists"
else
  error "skills/ directory is missing"
fi

if [[ -d "$EXAMPLES_DIR" ]]; then
  ok "examples/ directory exists"
else
  error "examples/ directory is missing"
fi

REQUIRED_ROOT_FILES=(
  "README.md"
  "install.sh"
  "uninstall.sh"
  "verify.sh"
  "install.ps1"
  "uninstall.ps1"
  "verify.ps1"
)

for file in "${REQUIRED_ROOT_FILES[@]}"; do
  if [[ -f "$SCRIPT_DIR/$file" ]]; then
    ok "$file exists"
  else
    error "$file is missing"
  fi
done

# ------------------------------------------------------------
# 2. Skill files
# ------------------------------------------------------------

section "Skill files"

for skill in "${EXPECTED_SKILLS[@]}"; do
  skill_file="$SKILLS_DIR/$skill/SKILL.md"

  if [[ -f "$skill_file" ]]; then
    ok "$skill/SKILL.md"
  else
    error "$skill/SKILL.md is missing"
  fi
done

# ------------------------------------------------------------
# 3. Skill frontmatter
# ------------------------------------------------------------

section "Skill metadata"

for skill in "${EXPECTED_SKILLS[@]}"; do
  skill_file="$SKILLS_DIR/$skill/SKILL.md"

  [[ -f "$skill_file" ]] || continue

  first_line="$(head -n 1 "$skill_file")"

  if [[ "$first_line" != "---" ]]; then
    error "$skill: YAML frontmatter does not start with ---"
    continue
  fi

  closing_line="$(
    awk '
      NR > 1 && $0 == "---" {
        print NR
        exit
      }
    ' "$skill_file"
  )"

  if [[ -z "$closing_line" ]]; then
    error "$skill: YAML frontmatter has no closing ---"
    continue
  fi

  declared_name="$(
    awk '
      /^name:[[:space:]]*/ {
        sub(/^name:[[:space:]]*/, "", $0)
        print
        exit
      }
    ' "$skill_file"
  )"

  description="$(
    awk '
      /^description:[[:space:]]*/ {
        sub(/^description:[[:space:]]*/, "", $0)
        print
        exit
      }
    ' "$skill_file"
  )"

  if [[ -z "$declared_name" ]]; then
    error "$skill: frontmatter is missing name"
  elif [[ "$declared_name" != "$skill" ]]; then
    error "$skill: declared name is '$declared_name'"
  else
    ok "$skill: name is valid"
  fi

  if [[ -z "$description" ]]; then
    error "$skill: frontmatter is missing description"
  else
    ok "$skill: description exists"
  fi
done

# ------------------------------------------------------------
# 4. Example prompts
# ------------------------------------------------------------

section "Example prompts"

for example in "${EXPECTED_EXAMPLES[@]}"; do
  example_file="$EXAMPLES_DIR/$example"

  if [[ ! -f "$example_file" ]]; then
    error "$example is missing"
    continue
  fi

  if [[ ! -s "$example_file" ]]; then
    error "$example exists but is empty"
    continue
  fi

  ok "$example exists"
done

# ------------------------------------------------------------
# 5. Bash scripts
# ------------------------------------------------------------

section "Bash scripts"

for script in "${EXPECTED_BASH_SCRIPTS[@]}"; do
  script_path="$SCRIPT_DIR/$script"

  if [[ ! -f "$script_path" ]]; then
    error "$script is missing"
    continue
  fi

  if bash -n "$script_path"; then
    ok "$script has valid Bash syntax"
  else
    error "$script contains Bash syntax errors"
  fi

  if [[ -x "$script_path" ]]; then
    ok "$script is executable"
  else
    warning "$script is not executable (run: chmod +x $script)"
  fi
done

# ------------------------------------------------------------
# 6. PowerShell scripts
# ------------------------------------------------------------

section "PowerShell scripts"

powershell_files_missing=0

for script in "${EXPECTED_POWERSHELL_SCRIPTS[@]}"; do
  script_path="$SCRIPT_DIR/$script"

  if [[ -f "$script_path" ]]; then
    ok "$script exists"
  else
    error "$script is missing"
    powershell_files_missing=1
  fi
done

# PowerShell syntax validation is optional on macOS/Linux.
# If pwsh is available, validate the scripts using the PowerShell parser.
# If not, existence is still checked and a warning is shown.

if [[ "$powershell_files_missing" -eq 0 ]]; then
  if command -v pwsh >/dev/null 2>&1; then
    for script in "${EXPECTED_POWERSHELL_SCRIPTS[@]}"; do
      script_path="$SCRIPT_DIR/$script"

      if pwsh -NoProfile -Command '
        param([string]$Path)

        $tokens = $null
        $errors = $null

        [System.Management.Automation.Language.Parser]::ParseFile(
          $Path,
          [ref]$tokens,
          [ref]$errors
        ) | Out-Null

        if ($errors.Count -gt 0) {
          foreach ($error in $errors) {
            Write-Error $error.Message
          }

          exit 1
        }

        exit 0
      ' "$script_path" >/dev/null 2>&1; then
        ok "$script has valid PowerShell syntax"
      else
        error "$script contains PowerShell syntax errors"
      fi
    done
  else
    warning "PowerShell (pwsh) is not installed; .ps1 syntax validation was skipped"
  fi
fi

# ------------------------------------------------------------
# 7. Unexpected skill directories
# ------------------------------------------------------------

section "Unexpected skills"

if [[ -d "$SKILLS_DIR" ]]; then
  unexpected_found=0

  while IFS= read -r path; do
    dir="$(basename "$path")"
    expected=0

    for skill in "${EXPECTED_SKILLS[@]}"; do
      if [[ "$dir" == "$skill" ]]; then
        expected=1
        break
      fi
    done

    if [[ "$expected" -eq 0 ]]; then
      warning "Unexpected skill directory: $dir"
      unexpected_found=1
    fi
  done < <(
    find "$SKILLS_DIR" \
      -mindepth 1 \
      -maxdepth 1 \
      -type d \
      | sort
  )

  if [[ "$unexpected_found" -eq 0 ]]; then
    ok "No unexpected skill directories found"
  fi
fi

# ------------------------------------------------------------
# 8. Final result
# ------------------------------------------------------------

printf "\n"
printf "=======================================\n"

if [[ "$ERRORS" -eq 0 ]]; then
  printf "Verification PASSED\n"
  printf "Errors:   0\n"
  printf "Warnings: %d\n" "$WARNINGS"
  printf "=======================================\n\n"
  exit 0
else
  printf "Verification FAILED\n"
  printf "Errors:   %d\n" "$ERRORS"
  printf "Warnings: %d\n" "$WARNINGS"
  printf "=======================================\n\n"
  exit 1
fi