#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
VERIFY_SCRIPT="$REPO_DIR/verify.sh"

GLOBAL_DESTINATION="$HOME/.gemini/config/skills"
LEGACY_GLOBAL_DESTINATION="$HOME/.gemini/antigravity/skills"

SKILLS=(
  "flutter-production-audit"
  "flutter-codebase-conventions"
  "flutter-state-management"
  "flutter-performance"
  "flutter-a11y-rtl"
  "flutter-responsive"
  "flutter-review-gate"
)

usage() {
  cat <<'EOF_USAGE'
Antigravity Flutter Skills Installer

Usage:
  ./install.sh --global
  ./install.sh --project [path]
  ./install.sh --help

Options:
  --global
      Install the skills globally for the current user.

  --project [path]
      Install the skills only into a specific project.
      Defaults to the current directory when no path is provided.

  --help
      Show this help message.

Examples:
  ./install.sh --global
  ./install.sh --project .
  ./install.sh --project ~/Projects/my_flutter_app
EOF_USAGE
}

run_verification() {
  echo ""
  echo "Verifying repository before installation..."
  echo ""

  if [[ ! -f "$VERIFY_SCRIPT" ]]; then
    echo "Error: verify.sh was not found:"
    echo "  $VERIFY_SCRIPT"
    exit 1
  fi

  if [[ ! -x "$VERIFY_SCRIPT" ]]; then
    echo "Error: verify.sh is not executable."
    echo ""
    echo "Run:"
    echo "  chmod +x \"$VERIFY_SCRIPT\""
    exit 1
  fi

  "$VERIFY_SCRIPT"
}

check_legacy_global_installation() {
  local found=0

  for skill in "${SKILLS[@]}"; do
    if [[ -d "$LEGACY_GLOBAL_DESTINATION/$skill" ]]; then
      found=1
      break
    fi
  done

  if [[ "$found" -eq 1 ]]; then
    echo ""
    echo "Warning: older copies of these skills were found in:"
    echo ""
    echo "  $LEGACY_GLOBAL_DESTINATION"
    echo ""
    echo "Antigravity may load a different copy than the one installed into:"
    echo ""
    echo "  $GLOBAL_DESTINATION"
    echo ""
    echo "Consider removing the old copies after confirming they are no longer needed."
    echo ""
    echo "This installer will NOT delete them automatically."
  fi
}

install_skills() {
  local destination="$1"

  mkdir -p "$destination"

  echo ""
  echo "Installing Antigravity Flutter Skills"
  echo "====================================="
  echo ""
  echo "Source:"
  echo "  $SKILLS_DIR"
  echo ""
  echo "Destination:"
  echo "  $destination"
  echo ""

  for skill in "${SKILLS[@]}"; do
    local source_dir="$SKILLS_DIR/$skill"
    local destination_dir="$destination/$skill"

    if [[ ! -f "$source_dir/SKILL.md" ]]; then
      echo "Error: Missing:"
      echo "  $source_dir/SKILL.md"
      exit 1
    fi

    if [[ -e "$destination_dir" ]]; then
      rm -rf "$destination_dir"
    fi

    cp -R "$source_dir" "$destination_dir"

    echo "✓ $skill"
  done

  echo ""
  echo "====================================="
  echo "Installation complete."
  echo ""
  echo "Installed to:"
  echo "  $destination"
  echo ""
  echo "Restart Antigravity or start a new conversation/session"
  echo "so the updated skills are discovered."
  echo ""
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  --global)
    run_verification
    check_legacy_global_installation
    install_skills "$GLOBAL_DESTINATION"
    ;;

  --project)
    PROJECT_PATH="${2:-.}"

    if [[ ! -d "$PROJECT_PATH" ]]; then
      echo "Error: Project directory does not exist:"
      echo "  $PROJECT_PATH"
      exit 1
    fi

    PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

    run_verification
    install_skills "$PROJECT_PATH/.agents/skills"
    ;;

  --help|-h)
    usage
    ;;

  *)
    echo "Error: Unknown option: $1"
    echo ""
    usage
    exit 1
    ;;
esac