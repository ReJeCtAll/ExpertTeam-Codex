#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${CODEX_HOME:-$HOME/.codex}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_URL="${EXPERT_TEAM_ARCHIVE_URL:-https://github.com/ReJeCtAll/ExpertTeam-Codex/archive/refs/heads/main.tar.gz}"
TEMP_DIR=""
ROOT_DIR=""
PROJECT_VERSION="unknown"
BACKUP_ROOT=""
DRY_RUN=0
LIST_ONLY=0
INSTALL_COMMANDS=1

usage() {
  cat <<'USAGE'
Usage: install.sh [options]

Options:
  --dry-run       Preview files that would be installed without writing anything.
  --list          List bundled components without installing anything.
  --no-commands   Skip optional Slash Commands compatibility files.
  -h, --help      Show this help message.
USAGE
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        ;;
      --list)
        LIST_ONLY=1
        ;;
      --no-commands)
        INSTALL_COMMANDS=0
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
    shift
  done
}

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

parse_args "$@"
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

list_dir_contents() {
  local label="$1"
  local source_dir="$2"
  local item=""

  echo "$label:"
  if [ ! -d "$source_dir" ]; then
    echo "  (missing)"
    return 0
  fi

  for item in "$source_dir"/*; do
    [ -e "$item" ] || continue
    echo "  - $(basename "$item")"
  done
}

list_components() {
  echo "Codex Expert Teams components:"
  if [ "$INSTALL_COMMANDS" -eq 1 ]; then
    list_dir_contents "commands" "$ROOT_DIR/.codex/commands"
  else
    echo "commands:"
    echo "  (skipped by --no-commands)"
  fi
  list_dir_contents "agents" "$ROOT_DIR/.codex/agents"
  list_dir_contents "skills" "$ROOT_DIR/.codex/skills"
}

install_dir_contents() {
  local source_dir="$1"
  local target_dir="$2"
  local action_label="Installed"

  if [ "$DRY_RUN" -eq 1 ]; then
    action_label="Would install"
  else
    mkdir -p "$target_dir"
  fi

  if [ ! -d "$source_dir" ]; then
    echo "Skip missing source directory: $source_dir"
    return 0
  fi

  for item in "$source_dir"/*; do
    [ -e "$item" ] || continue
    local base
    base="$(basename "$item")"
    local target="$target_dir/$base"

    if [ "$DRY_RUN" -eq 1 ]; then
      if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Would back up: $target"
      fi
    else
      backup_if_exists "$target"
      if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf -- "$target"
      fi
      cp -R "$item" "$target"
    fi
    echo "$action_label: $target"
  done
}

if [ "$LIST_ONLY" -eq 1 ]; then
  list_components
  exit 0
fi

echo "Installing Codex Expert Teams to: $TARGET_DIR"
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run enabled. No files will be written."
fi

if [ "$INSTALL_COMMANDS" -eq 1 ]; then
  install_dir_contents "$ROOT_DIR/.codex/commands" "$TARGET_DIR/commands"
else
  echo "Skipping optional Slash Commands compatibility layer."
fi
install_dir_contents "$ROOT_DIR/.codex/agents" "$TARGET_DIR/agents"
install_dir_contents "$ROOT_DIR/.codex/skills" "$TARGET_DIR/skills"

echo ""
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run completed."
else
  echo "Installation completed."
fi
echo "Version: $PROJECT_VERSION"
echo "Available Codex CLI skills:"
echo '  $expert-team'
echo '  $expert-software'
echo '  $expert-design'
echo '  $expert-product'
echo '  $expert-ops'
echo '  $expert-security'
echo '  $expert-database'
echo '  $privacy-policy-pipl-audit'
echo ""
echo 'Tip: type $expert in Codex CLI to verify skill discovery.'
