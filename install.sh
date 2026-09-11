#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

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
Antigravity Flutter Skills Installer

Usage:
  ./install.sh --global
  ./install.sh --project [path]

Options:
  --global          Install for all Antigravity projects.
  --project [path]  Install into a single project.
                    Defaults to the current directory.
  --help            Show this help message.

Examples:
  ./install.sh --global
  ./install.sh --project .
  ./install.sh --project ~/Projects/my_flutter_app
EOF_USAGE
}

install_skills() {
  local destination="$1"

  mkdir -p "$destination"

  echo ""
  echo "Installing Antigravity Flutter Skills..."
  echo "Destination: $destination"
  echo ""

  for skill in "${SKILLS[@]}"; do
    source_dir="$SKILLS_DIR/$skill"
    destination_dir="$destination/$skill"

    if [[ ! -f "$source_dir/SKILL.md" ]]; then
      echo "Error: Missing $source_dir/SKILL.md"
      exit 1
    fi

    rm -rf "$destination_dir"
    cp -R "$source_dir" "$destination_dir"

    echo "✓ $skill"
  done

  echo ""
  echo "Installation complete."
  echo ""
  echo "Restart Antigravity or start a new conversation so the skills are discovered."
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

case "$1" in

  --global)
    install_skills "$HOME/.gemini/config/skills"
    ;;

  --project)
    PROJECT_PATH="${2:-.}"

    if [[ ! -d "$PROJECT_PATH" ]]; then
      echo "Error: Project directory does not exist: $PROJECT_PATH"
      exit 1
    fi

    PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
    install_skills "$PROJECT_PATH/.agents/skills"
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
