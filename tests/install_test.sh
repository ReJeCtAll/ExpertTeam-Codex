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

assert_not_contains() {
  local file_path="$1"
  local unexpected="$2"
  ! grep -Fq "$unexpected" "$file_path" ||
    fail "Did not expect '$unexpected' in $file_path"
}

assert_log_contains() {
  local file_path="$1"
  local expected="$2"
  grep -Fq -- "$expected" "$file_path" || fail "Expected '$expected' in $file_path"
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
  assert_file "$codex_home/agents/security-expert.md"
  assert_file "$codex_home/commands/expert-ops.md"
  assert_file "$codex_home/commands/expert-security.md"
  assert_file "$codex_home/skills/expert-ops/SKILL.md"
  assert_file "$codex_home/skills/expert-ops/agents/openai.yaml"
  assert_file "$codex_home/skills/expert-security/SKILL.md"
  assert_file "$codex_home/skills/expert-security/agents/openai.yaml"
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
  assert_contains "$log_file" '$expert-security'
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
  assert_contains "$log_file" '$expert-security'
}

test_list_components() {
  local case_root="$TEST_ROOT/list-components"
  local codex_home="$case_root/.codex"
  local log_file="$case_root/list.log"

  mkdir -p "$case_root"
  CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" --list >"$log_file"

  assert_log_contains "$log_file" 'Codex Expert Teams components:'
  assert_log_contains "$log_file" 'commands:'
  assert_log_contains "$log_file" 'agents:'
  assert_log_contains "$log_file" 'skills:'
  assert_log_contains "$log_file" '  - expert-team'
  assert_log_contains "$log_file" '  - expert-security'
  assert_not_exists "$codex_home"
}

test_dry_run_does_not_write() {
  local case_root="$TEST_ROOT/dry-run"
  local codex_home="$case_root/.codex"
  local log_file="$case_root/dry-run.log"

  mkdir -p "$case_root"
  CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" --dry-run >"$log_file"

  assert_log_contains "$log_file" 'Dry run enabled. No files will be written.'
  assert_log_contains "$log_file" 'Would install:'
  assert_log_contains "$log_file" "$codex_home/skills/expert-team"
  assert_log_contains "$log_file" "$codex_home/agents/software-team-lead.md"
  assert_log_contains "$log_file" "$codex_home/commands/expert-team.md"
  assert_not_exists "$codex_home"
}

test_no_commands_skips_compat_layer() {
  local case_root="$TEST_ROOT/no-commands"
  local codex_home="$case_root/.codex"
  local log_file="$case_root/install.log"

  mkdir -p "$case_root"
  CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" --no-commands >"$log_file"

  assert_tree_matches "$REPO_ROOT/.codex/agents" "$codex_home/agents"
  assert_tree_matches "$REPO_ROOT/.codex/skills" "$codex_home/skills"
  assert_not_exists "$codex_home/commands"
  assert_log_contains "$log_file" 'Skipping optional Slash Commands compatibility layer.'
  assert_log_contains "$log_file" 'Installation completed.'
}

test_version_metadata() {
  [[ "$PROJECT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
    fail "VERSION is not valid SemVer: $PROJECT_VERSION"
  assert_contains "$REPO_ROOT/README.md" "当前版本：**v$PROJECT_VERSION**"
  assert_contains "$REPO_ROOT/CHANGELOG.md" "## [$PROJECT_VERSION]"
  assert_contains "$REPO_ROOT/CHANGELOG.md" "[$PROJECT_VERSION]: https://github.com/ReJeCtAll/ExpertTeam-Codex/compare/"
  assert_contains "$REPO_ROOT/README.md" "例如 \`v$PROJECT_VERSION\`"
  assert_file "$REPO_ROOT/docs/RELEASE.md"
  assert_file "$REPO_ROOT/docs/TROUBLESHOOTING.md"
  assert_file "$REPO_ROOT/CONTEXT.md"
  assert_contains "$REPO_ROOT/docs/RELEASE.md" "VERSION"
  assert_contains "$REPO_ROOT/docs/RELEASE.md" "CHANGELOG.md"
  assert_contains "$REPO_ROOT/docs/RELEASE.md" "tests/install_test.sh"
  assert_contains "$REPO_ROOT/README.md" "docs/TROUBLESHOOTING.md"
  assert_contains "$REPO_ROOT/README.md" "CONTEXT.md"
  assert_contains "$REPO_ROOT/docs/USAGE.md" "docs/TROUBLESHOOTING.md"
}

test_repository_metadata_consistency() {
  local skill_count=""
  local agent_count=""
  local command_count=""
  local skill_dir=""
  local skill_name=""
  local agent_file=""
  local agent_name=""
  local command_file=""

  skill_count="$(find "$REPO_ROOT/.codex/skills" -mindepth 1 -maxdepth 1 \
    -type d -print | wc -l | tr -d ' ')"
  agent_count="$(find "$REPO_ROOT/.codex/agents" -maxdepth 1 \
    -type f -name '*.md' -print | wc -l | tr -d ' ')"
  command_count="$(find "$REPO_ROOT/.codex/commands" -maxdepth 1 \
    -type f -name 'expert-*.md' -print | wc -l | tr -d ' ')"

  [ "$skill_count" = "10" ] || fail "Expected 10 skills, got $skill_count"
  [ "$agent_count" = "19" ] || fail "Expected 19 agents, got $agent_count"
  [ "$command_count" = "6" ] || fail "Expected 6 commands, got $command_count"

  assert_contains "$REPO_ROOT/docs/TEAM_ARCHITECTURE.md" \
    "6 个 Codex CLI / Codex App 桌面版入口 Skills、19 个 Agents、4 个支撑 Skills，以及 6 个可选 Slash Commands"
  assert_contains "$REPO_ROOT/CHANGELOG.md" \
    "6 个入口 Skills、19 个 Agents 和 6 个兼容 Commands"

  for skill_dir in "$REPO_ROOT/.codex/skills"/*; do
    [ -d "$skill_dir" ] || continue
    assert_file "$skill_dir/SKILL.md"
    skill_name="$(sed -n 's/^name: //p' "$skill_dir/SKILL.md" | head -n 1)"
    [ "$skill_name" = "$(basename "$skill_dir")" ] ||
      fail "Skill name mismatch: $skill_dir declares '$skill_name'"
  done

  for agent_file in "$REPO_ROOT/.codex/agents"/*.md; do
    agent_name="$(sed -n 's/^name: //p' "$agent_file" | head -n 1)"
    [ "$agent_name" = "$(basename "$agent_file" .md)" ] ||
      fail "Agent name mismatch: $agent_file declares '$agent_name'"
  done

  for command_file in "$REPO_ROOT/.codex/commands"/expert-*.md; do
    assert_not_contains "$command_file" '转交 `/expert-'
    assert_not_contains "$command_file" '联动 `/expert-'
    assert_not_contains "$command_file" '→ `/expert-'
    if [ "$(basename "$command_file")" != "expert-team.md" ]; then
      assert_not_contains "$command_file" '/expert-'
    fi
  done
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

  first_backup="$codex_home/backups/expert-team/20260610_120000/skills/expert-ops"
  assert_contains "$first_backup/SKILL.md" 'local modification'
  assert_file "$first_backup/stale.txt"
  assert_not_exists "$codex_home/skills/expert-ops.bak.20260610_120000"
  assert_not_exists "$installed_skill/stale.txt"
  assert_tree_matches "$REPO_ROOT/.codex/skills/expert-ops" "$installed_skill"

  printf '%s\n' 'second modification' >"$installed_skill/SKILL.md"
  printf '%s\n' 'second stale content' >"$installed_skill/second-stale.txt"

  PATH="$fake_bin:$PATH" CODEX_HOME="$codex_home" "$REPO_ROOT/install.sh" >>"$log_file"

  second_backup="$codex_home/backups/expert-team/20260610_120000.1/skills/expert-ops"
  assert_contains "$second_backup/SKILL.md" 'second modification'
  assert_file "$second_backup/second-stale.txt"
  assert_not_exists "$codex_home/skills/expert-ops.bak.20260610_120000.1"
  assert_not_exists "$installed_skill/stale.txt"
  assert_not_exists "$installed_skill/second-stale.txt"
  assert_tree_matches "$REPO_ROOT/.codex/skills/expert-ops" "$installed_skill"

  backup_count="$(find "$codex_home/backups/expert-team" -mindepth 1 -maxdepth 1 \
    -type d -name '20260610_120000*' -print | wc -l | tr -d ' ')"
  [ "$backup_count" = "2" ] || fail "Expected 2 unique backup runs, got $backup_count"
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
run_test "repository metadata consistency" test_repository_metadata_consistency
run_test "list components without writing" test_list_components
run_test "dry run preview without writing" test_dry_run_does_not_write
run_test "local install with custom path" test_local_install
run_test "piped archive install" test_piped_archive_install
run_test "install without optional commands" test_no_commands_skips_compat_layer
run_test "reinstall backup and replacement" test_reinstall_replaces_stale_content_and_backs_up
run_test "invalid archive rejection" test_invalid_archive_fails_cleanly

echo "All $PASS_COUNT install tests passed."
