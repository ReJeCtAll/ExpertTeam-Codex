#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${CODEX_HOME:-$HOME/.codex}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_URL="${EXPERT_TEAM_ARCHIVE_URL:-https://github.com/ReJeCtAll/ExpertTeam-Codex/archive/refs/heads/main.tar.gz}"
TEMP_DIR=""
ROOT_DIR=""

cleanup() {
  if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -r -- "$TEMP_DIR"
  fi
}
trap cleanup EXIT

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Required command not found: $command_name" >&2
    exit 1
  fi
}

resolve_root_dir() {
  local script_source="${BASH_SOURCE[0]:-}"
  local script_dir=""

  if [ -n "$script_source" ] && [ -f "$script_source" ]; then
    script_dir="$(cd "$(dirname "$script_source")" && pwd)"
  fi

  if [ -n "$script_dir" ] && [ -d "$script_dir/.codex" ]; then
    ROOT_DIR="$script_dir"
    return 0
  fi

  require_command curl
  require_command tar
  require_command mktemp

  TEMP_DIR="$(mktemp -d)"
  local archive_path="$TEMP_DIR/expert-team-codex.tar.gz"
  local candidate=""

  echo "Downloading Codex Expert Teams..."
  curl -fsSL "$ARCHIVE_URL" -o "$archive_path"
  tar -xzf "$archive_path" -C "$TEMP_DIR"

  for candidate in "$TEMP_DIR"/*; do
    if [ -d "$candidate/.codex" ]; then
      ROOT_DIR="$candidate"
      return 0
    fi
  done

  echo "Downloaded archive does not contain a .codex directory." >&2
  exit 1
}

resolve_root_dir

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
