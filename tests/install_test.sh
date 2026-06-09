#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -r -- "$TEST_TMP_DIR"
}
trap cleanup EXIT

FIXTURE_ROOT="$TEST_TMP_DIR/ExpertTeam-Codex-main"
ARCHIVE_PATH="$TEST_TMP_DIR/ExpertTeam-Codex-main.tar.gz"
RUNNER_DIR="$TEST_TMP_DIR/runner"
TARGET_DIR="$TEST_TMP_DIR/codex-home"
LOCAL_TARGET_DIR="$TEST_TMP_DIR/local-codex-home"

mkdir -p "$FIXTURE_ROOT" "$RUNNER_DIR"
cp -R "$ROOT_DIR/.codex" "$FIXTURE_ROOT/.codex"
cp "$ROOT_DIR/install.sh" "$RUNNER_DIR/install.sh"
tar -czf "$ARCHIVE_PATH" -C "$TEST_TMP_DIR" "ExpertTeam-Codex-main"

curl -fsSL "file://$RUNNER_DIR/install.sh" |
  CODEX_HOME="$TARGET_DIR" \
    EXPERT_TEAM_ARCHIVE_URL="file://$ARCHIVE_PATH" \
    bash

test -f "$TARGET_DIR/skills/expert-team/SKILL.md"
test -f "$TARGET_DIR/skills/expert-software/SKILL.md"
test -f "$TARGET_DIR/agents/software-team-lead.md"
test -f "$TARGET_DIR/commands/expert-team.md"

CODEX_HOME="$LOCAL_TARGET_DIR" bash "$ROOT_DIR/install.sh"

test -f "$LOCAL_TARGET_DIR/skills/expert-team/SKILL.md"
test -f "$LOCAL_TARGET_DIR/agents/software-team-lead.md"
test -f "$LOCAL_TARGET_DIR/commands/expert-team.md"

printf 'Remote install test passed.\n'
printf 'Local install test passed.\n'
