#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${CODEX_HOME:-$HOME/.codex}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ]; then
    cp -R "$target" "${target}.bak.${TIMESTAMP}"
    echo "Backed up: $target -> ${target}.bak.${TIMESTAMP}"
  fi
}

install_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"

  mkdir -p "$target_dir"

  if [ ! -d "$source_dir" ]; then
    echo "Skip missing source directory: $source_dir"
    return 0
  fi

  for item in "$source_dir"/*; do
    [ -e "$item" ] || continue
    local base
    base="$(basename "$item")"
    backup_if_exists "$target_dir/$base"
    cp -R "$item" "$target_dir/"
    echo "Installed: $target_dir/$base"
  done
}

echo "Installing Codex Expert Teams to: $TARGET_DIR"

install_dir_contents "$ROOT_DIR/.codex/commands" "$TARGET_DIR/commands"
install_dir_contents "$ROOT_DIR/.codex/agents" "$TARGET_DIR/agents"
install_dir_contents "$ROOT_DIR/.codex/skills" "$TARGET_DIR/skills"

echo ""
echo "Installation completed."
echo "Available Codex CLI skills:"
echo '  $expert-team'
echo '  $expert-software'
echo '  $expert-design'
echo '  $expert-product'
echo ""
echo 'Tip: type $expert in Codex CLI to verify skill discovery.'
