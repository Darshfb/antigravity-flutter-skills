#!/usr/bin/env bash

set -euo pipefail

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
  cat <<EOF_USAGE
Antigravity Flutter Skills Uninstaller

Usage:
  ./uninstall.sh --global
  ./uninstall.sh --project [path]

Examples:
  ./uninstall.sh --global
  ./uninstall.sh --project .
EOF_USAGE
}

remove_skills() {

  local destination="$1"

  echo ""
  echo "Removing Antigravity Flutter Skills from:"
  echo "$destination"
  echo ""

  for skill in "${SKILLS[@]}"; do

    target="$destination/$skill"

    if [[ -d "$target" ]]; then
      rm -rf "$target"
      echo "✓ Removed $skill"
    else
      echo "- $skill was not installed"
    fi

  done

  echo ""
  echo "Uninstall complete."
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

case "$1" in

  --global)
    remove_skills "$HOME/.gemini/config/skills"
    ;;

  --project)

    PROJECT_PATH="${2:-.}"

    if [[ ! -d "$PROJECT_PATH" ]]; then
      echo "Error: Project directory does not exist: $PROJECT_PATH"
      exit 1
    fi

    PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

    remove_skills "$PROJECT_PATH/.agents/skills"
    ;;

  --help|-h)
    usage
    ;;

  *)
    echo "Unknown option: $1"
    echo ""
    usage
    exit 1
    ;;
esac
