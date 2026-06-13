#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${CODEX_HOME:-$HOME/.codex}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_URL="${EXPERT_TEAM_ARCHIVE_URL:-https://github.com/ReJeCtAll/ExpertTeam-Codex/archive/refs/heads/main.tar.gz}"
TEMP_DIR=""
ROOT_DIR=""
PROJECT_VERSION="unknown"
BACKUP_ROOT=""

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

if [ -f "$ROOT_DIR/VERSION" ]; then
  IFS= read -r PROJECT_VERSION <"$ROOT_DIR/VERSION"
fi

ensure_backup_root() {
  if [ -n "$BACKUP_ROOT" ]; then
    return 0
  fi

  local base_path="$TARGET_DIR/backups/expert-team/$TIMESTAMP"
  local candidate="$base_path"
  local suffix=1

  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="${base_path}.${suffix}"
    suffix=$((suffix + 1))
  done

  mkdir -p "$candidate"
  BACKUP_ROOT="$candidate"
}

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    ensure_backup_root

    local relative_target="${target#"$TARGET_DIR"/}"
    local backup_path="$BACKUP_ROOT/$relative_target"

    mkdir -p "$(dirname "$backup_path")"
    cp -R "$target" "$backup_path"
    echo "Backed up: $target -> $backup_path"
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
    local target="$target_dir/$base"

    backup_if_exists "$target"
    if [ -e "$target" ] || [ -L "$target" ]; then
      rm -rf -- "$target"
    fi
    cp -R "$item" "$target"
    echo "Installed: $target"
  done
}

echo "Installing Codex Expert Teams to: $TARGET_DIR"

install_dir_contents "$ROOT_DIR/.codex/commands" "$TARGET_DIR/commands"
install_dir_contents "$ROOT_DIR/.codex/agents" "$TARGET_DIR/agents"
install_dir_contents "$ROOT_DIR/.codex/skills" "$TARGET_DIR/skills"

echo ""
echo "Installation completed."
echo "Version: $PROJECT_VERSION"
echo "Available Codex CLI skills:"
echo '  $expert-team'
echo '  $expert-software'
echo '  $expert-design'
echo '  $expert-product'
echo '  $expert-ops'
echo '  $expert-security'
echo ""
echo 'Tip: type $expert in Codex CLI to verify skill discovery.'
