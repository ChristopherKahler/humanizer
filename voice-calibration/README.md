# voice-calibration — slash command support directory

This directory holds support files for the `/calibrate-voice` slash command. **Not a standalone skill.** Do not invoke directly.

The slash command file lives at `commands/calibrate-voice.md` in the parent (voice-system skill) directory. After install, `bash install.sh` symlinks it into `~/.claude/commands/` so members can invoke `/calibrate-voice` from any Claude Code session.

## Layout

- `tasks/` — sequence runners (`sequence-1.md` through `sequence-4.md`), `sample-bootstrap.md`, `compile.md`, `demo.md`, `status.md`, `refine.md`
- `context/` — `interviewer.md` (push-back DNA) + `compiler.md` (XML schema and distillation rules)

## Outputs

- `~/.claude/voice-archive.md` — raw Q+A transcript, append-only
- `~/.claude/voice.md` — compiled XML profile (read by parent `voice-system` skill on every output)
- `~/.claude/voice.backup.md` — one-step rollback
- `~/.claude/CLAUDE.md` — gets the humanizer NEVER rule pinned on first compile

## Source references

These task files are distilled from:
- `planning/skool-design/skool-roadmap/voice-interview.md` (Taste Interviewer)
- `planning/skool-design/skool-roadmap/voice-compiler.md` (Voice Compiler)

Source docs live in Chris's private workspace. This directory is the operational distillation packaged for distribution.
