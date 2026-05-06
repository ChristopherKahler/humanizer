#!/usr/bin/env bash
# voice-system installer
# Symlinks /calibrate-voice into ~/.claude/commands/ so Claude Code can discover it.
# Idempotent. Safe to re-run.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"
COMMAND_NAME="calibrate-voice.md"
SOURCE="$SKILL_DIR/commands/$COMMAND_NAME"
TARGET="$COMMANDS_DIR/$COMMAND_NAME"

# sanity: are we in a real voice-system clone?
if [[ ! -f "$SOURCE" ]]; then
  echo "Error: $SOURCE not found."
  echo "       Run this script from inside a voice-system clone."
  echo "       Expected layout: <clone-dir>/commands/$COMMAND_NAME"
  exit 1
fi

if [[ ! -f "$SKILL_DIR/SKILL.md" ]]; then
  echo "Error: $SKILL_DIR/SKILL.md not found. This does not look like a voice-system clone."
  exit 1
fi

echo "voice-system installer"
echo "  Skill dir: $SKILL_DIR"
echo ""

# informational: detect existing humanizer install
if [[ -d "$HOME/.claude/skills/humanizer" ]] && [[ "$SKILL_DIR" != "$HOME/.claude/skills/humanizer" ]]; then
  echo "Note: existing skill at ~/.claude/skills/humanizer detected."
  echo "      voice-system installs separately and does not modify it."
  echo ""
fi

mkdir -p "$COMMANDS_DIR"

# handle existing target
if [[ -L "$TARGET" ]]; then
  CURRENT_LINK="$(readlink "$TARGET")"
  if [[ "$CURRENT_LINK" == "$SOURCE" ]]; then
    echo "Already linked: $TARGET → $SOURCE"
    echo ""
    echo "voice-system installed. Run /calibrate-voice in Claude Code."
    exit 0
  fi
  echo "Replacing existing symlink at $TARGET (was: $CURRENT_LINK)"
  rm "$TARGET"
elif [[ -e "$TARGET" ]]; then
  echo "Warning: $TARGET exists and is not a symlink."
  echo "         Move or delete it manually if you want voice-system's /calibrate-voice instead."
  echo "         (Existing /calibrate-voice command, if any, has been left in place.)"
  exit 0
fi

ln -s "$SOURCE" "$TARGET"
echo "Linked: $TARGET → $SOURCE"
echo ""
echo "voice-system installed."
echo "  Skill:   $SKILL_DIR/SKILL.md"
echo "  Command: /calibrate-voice"
echo ""
echo "Next: run /calibrate-voice in Claude Code."
