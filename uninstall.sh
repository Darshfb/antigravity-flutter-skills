#!/usr/bin/env bash

set -euo pipefail

GLOBAL_DESTINATION="$HOME/.gemini/config/skills"

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
Antigravity Flutter Skills Uninstaller

Usage:
  ./uninstall.sh --global
  ./uninstall.sh --project [path]
  ./uninstall.sh --help

Options:
  --global
      Remove the globally installed Antigravity Flutter Skills
      from the current user's Gemini config skills directory.

  --project [path]
      Remove the skills from a specific project's .agents/skills directory.
      Defaults to the current directory when no path is provided.

  --help
      Show this help message.

Examples:
  ./uninstall.sh --global
  ./uninstall.sh --project .
  ./uninstall.sh --project ~/Projects/my_flutter_app

Notes:
  This script removes only the seven skills managed by this repository.

  It does NOT remove:
    ~/.gemini/config/skills/

  It also does NOT touch the legacy directory:
    ~/.gemini/antigravity/skills/
EOF_USAGE
}

remove_skills() {
  local destination="$1"
  local removed=0
  local missing=0

  if [[ -z "$destination" ]]; then
    echo "Error: Destination path is empty."
    exit 1
  fi

  echo ""
  echo "Removing Antigravity Flutter Skills"
  echo "==================================="
  echo ""
  echo "Destination:"
  echo "  $destination"
  echo ""

  for skill in "${SKILLS[@]}"; do
    local target="$destination/$skill"

    if [[ -d "$target" ]]; then
      rm -rf "$target"
      echo "✓ Removed $skill"
      removed=$((removed + 1))
    else
      echo "- $skill was not installed"
      missing=$((missing + 1))
    fi
  done

  echo ""
  echo "==================================="
  echo "Uninstall complete."
  echo ""
  echo "Removed: $removed"
  echo "Already absent: $missing"
  echo ""

  if [[ "$removed" -eq 0 ]]; then
    echo "No managed Antigravity Flutter Skills were installed at:"
    echo "  $destination"
    echo ""
  else
    echo "Only the skills managed by this repository were removed."
    echo "Other skills in the destination were left untouched."
    echo ""
  fi
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  --global)
    remove_skills "$GLOBAL_DESTINATION"
    ;;

  --project)
    PROJECT_PATH="${2:-.}"

    if [[ ! -d "$PROJECT_PATH" ]]; then
      echo "Error: Project directory does not exist:"
      echo "  $PROJECT_PATH"
      exit 1
    fi

    PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

    remove_skills "$PROJECT_PATH/.agents/skills"
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