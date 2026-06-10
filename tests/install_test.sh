#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/expert-team-install-test.XXXXXX")"
PROJECT_VERSION="$(tr -d '[:space:]' <"$REPO_ROOT/VERSION")"
PASS_COUNT=0

cleanup() {
  rm -rf -- "$TEST_ROOT"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $*" >&2
  return 1
}

assert_file() {
  local file_path="$1"
  [ -f "$file_path" ] || fail "Expected file: $file_path"
}

assert_not_exists() {
  local file_path="$1"
  [ ! -e "$file_path" ] || fail "Expected path to be absent: $file_path"
}

assert_contains() {
  local file_path="$1"
  local expected="$2"
  grep -Fq "$expected" "$file_path" || fail "Expected '$expected' in $file_path"
}

assert_tree_matches() {
  local source_dir="$1"
  local target_dir="$2"
  diff -qr "$source_dir" "$target_dir" >/dev/null ||
    fail "Installed tree differs: $source_dir -> $target_dir"
}

run_test() {
  local test_name="$1"
  shift

  echo "RUN: $test_name"
  "$@"
  PASS_COUNT=$((PASS_COUNT + 1))
  echo "PASS: $test_name"
}

create_release_archive() {
  local archive_path="$1"
  local staging_dir="$TEST_ROOT/archive-staging"
  local archive_root="$staging_dir/ExpertTeam-Codex-main"

  rm -rf -- "$staging_dir"
  mkdir -p "$archive_root"
  cp -R "$REPO_ROOT/.codex" "$archive_root/.codex"
  cp "$REPO_ROOT/VERSION" "$archive_root/VERSION"
  tar -czf "$archive_path" -C "$staging_dir" "ExpertTeam-Codex-main"
}

assert_install_complete() {
  local codex_home="$1"

  assert_tree_matches "$REPO_ROOT/.codex/agents" "$codex_home/agents"
  assert_tree_matches "$REPO_ROOT/.codex/commands" "$codex_home/commands"
  assert_tree_matches "$REPO_ROOT/.codex/skills" "$codex_home/skills"
  assert_file "$codex_home/agents/infrastructure-operations-expert.md"
  assert_file "$codex_home/commands/expert-ops.md"
  assert_file "$codex_home/skills/expert-ops/SKILL.md"
  assert_file "$codex_home/skills/expert-ops/agents/openai.yaml"
}

test_local_install() {
  local case_root="$TEST_ROOT/local install"
  local codex_home="$case_root/custom codex home"
  local log_file="$case_root/install.log"

  mkdir -p "$case_root"
  CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" >"$log_file"

  assert_install_complete "$codex_home"
  assert_contains "$log_file" 'Installation completed.'
  assert_contains "$log_file" "Version: $PROJECT_VERSION"
  assert_contains "$log_file" '$expert-ops'
}

test_piped_archive_install() {
  local case_root="$TEST_ROOT/piped-install"
  local codex_home="$case_root/.codex"
  local archive_path="$case_root/release.tar.gz"
  local log_file="$case_root/install.log"

  mkdir -p "$case_root"
  create_release_archive "$archive_path"

  curl -fsSL "file://$REPO_ROOT/install.sh" |
    CODEX_HOME="$codex_home" \
      EXPERT_TEAM_ARCHIVE_URL="file://$archive_path" \
      bash >"$log_file"

  assert_install_complete "$codex_home"
  assert_contains "$log_file" 'Downloading Codex Expert Teams...'
  assert_contains "$log_file" "Version: $PROJECT_VERSION"
  assert_contains "$log_file" '$expert-ops'
}

test_version_metadata() {
  [[ "$PROJECT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
    fail "VERSION is not valid SemVer: $PROJECT_VERSION"
  assert_contains "$REPO_ROOT/README.md" "当前版本：**v$PROJECT_VERSION**"
  assert_contains "$REPO_ROOT/CHANGELOG.md" "## [$PROJECT_VERSION]"
}

test_reinstall_replaces_stale_content_and_backs_up() {
  local case_root="$TEST_ROOT/reinstall"
  local codex_home="$case_root/.codex"
  local fake_bin="$case_root/bin"
  local log_file="$case_root/reinstall.log"
  local installed_skill="$codex_home/skills/expert-ops"
  local first_backup=""
  local second_backup=""
  local backup_count=""

  mkdir -p "$fake_bin"
  printf '%s\n' \
    '#!/usr/bin/env bash' \
    "printf '%s\\n' '20260610_120000'" >"$fake_bin/date"
  chmod +x "$fake_bin/date"

  PATH="$fake_bin:$PATH" CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" >/dev/null

  printf '%s\n' 'local modification' >"$installed_skill/SKILL.md"
  printf '%s\n' 'stale content' >"$installed_skill/stale.txt"

  PATH="$fake_bin:$PATH" CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" >"$log_file"

  first_backup="$codex_home/skills/expert-ops.bak.20260610_120000"
  assert_contains "$first_backup/SKILL.md" 'local modification'
  assert_file "$first_backup/stale.txt"
  assert_not_exists "$installed_skill/stale.txt"
  assert_tree_matches "$REPO_ROOT/.codex/skills/expert-ops" "$installed_skill"

  printf '%s\n' 'second modification' >"$installed_skill/SKILL.md"
  printf '%s\n' 'second stale content' >"$installed_skill/second-stale.txt"

  PATH="$fake_bin:$PATH" CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" >>"$log_file"

  second_backup="$codex_home/skills/expert-ops.bak.20260610_120000.1"
  assert_contains "$second_backup/SKILL.md" 'second modification'
  assert_file "$second_backup/second-stale.txt"
  assert_not_exists "$installed_skill/stale.txt"
  assert_not_exists "$installed_skill/second-stale.txt"
  assert_tree_matches "$REPO_ROOT/.codex/skills/expert-ops" "$installed_skill"

  backup_count="$(find "$codex_home/skills" -maxdepth 1 -type d \
    -name 'expert-ops.bak.*' -print | wc -l | tr -d ' ')"
  [ "$backup_count" = "2" ] || fail "Expected 2 unique expert-ops backups, got $backup_count"
  assert_contains "$log_file" 'Backed up:'
}

test_invalid_archive_fails_cleanly() {
  local case_root="$TEST_ROOT/invalid-archive"
  local codex_home="$case_root/.codex"
  local archive_path="$case_root/invalid.tar.gz"
  local archive_root="$case_root/archive/invalid-root"
  local log_file="$case_root/install.log"

  mkdir -p "$archive_root"
  printf '%s\n' 'missing .codex directory' >"$archive_root/README.md"
  tar -czf "$archive_path" -C "$case_root/archive" "invalid-root"

  if curl -fsSL "file://$REPO_ROOT/install.sh" |
    CODEX_HOME="$codex_home" \
      EXPERT_TEAM_ARCHIVE_URL="file://$archive_path" \
      bash >"$log_file" 2>&1; then
    fail "Invalid archive installation unexpectedly succeeded"
  fi

  assert_contains "$log_file" 'Downloaded archive does not contain a .codex directory.'
  assert_not_exists "$codex_home/skills"
}

run_test "version metadata consistency" test_version_metadata
run_test "local install with custom path" test_local_install
run_test "piped archive install" test_piped_archive_install
run_test "reinstall backup and replacement" test_reinstall_replaces_stale_content_and_backs_up
run_test "invalid archive rejection" test_invalid_archive_fails_cleanly

echo "All $PASS_COUNT install tests passed."
