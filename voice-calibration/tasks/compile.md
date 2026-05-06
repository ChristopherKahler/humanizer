<purpose>
Compile `~/.claude/voice-archive.md` (raw Q+A) into `~/.claude/voice.md` (XML about_me profile). Idempotent — runs after every sequence and any time the archive changes. Output is consumed by the sibling humanizer skill on every session.
</purpose>

<user-story>
As a writer who just answered a sequence, I want my voice file refreshed automatically, so that my next AI session reads the latest behavioral DNA without me having to do anything.
</user-story>

<when-to-use>
- Immediately after any sequence (1, 2, 3, or 4) completes
- User runs `/calibrate-voice compile` manually
- User edited `~/.claude/voice-archive.md` by hand and wants a fresh compile
</when-to-use>

<context>
@../context/compiler.md
</context>

<steps>

<step name="read_archive" priority="first">
1. Read `~/.claude/voice-archive.md`.
2. Count Q+A entries. Note which sequences are represented (S1, S1+S2, S1+S2+S3, or all four). The compiler honors what's there — do not invent content for unanswered sequences.
3. If archive is missing or empty, stop and tell the user to run `tasks/sequence-1.md`.
</step>

<step name="backup_existing">
If `~/.claude/voice.md` already exists:
1. Copy it to `~/.claude/voice.backup.md` (overwrite any prior backup — the archive is source of truth, the backup is just for one-step rollback).
2. Confirm to the user the backup is in place.
</step>

<step name="distill">
Apply the compiler DNA from `context/compiler.md`:

1. Run the **core test** on every candidate line: *"If this line disappeared, would the AI write, edit, judge, refuse, structure, or decide differently?"* Yes → keep. No → cut.
2. Stay under 5,000 tokens. Aim for 2,000-4,000 on a full archive. Aim ~1,500 on S1-only.
3. Use the XML schema verbatim: `<about_me>` with all child sections in the order specified.
4. Sections sparse but honest — never pad. If `<hard_refusals>` has nothing strong yet, leave it short or empty.
5. `<golden_examples>` cap at 6. Pick the highest-leverage ones — each must teach a distinct pattern.
6. Run the pre-output audit (cut generic, flattering, weak biography, low-evidence, repeated, vague).
</step>

<step name="write_voice_file">
Write the compiled XML profile to `~/.claude/voice.md`. Overwrite. No commentary before or after the file content.
</step>

<step name="pin_humanizer_rule">
Ensure the humanizer NEVER-rule is present in `~/.claude/CLAUDE.md`. This is the rule the published Skool lesson promises members.

1. Read `~/.claude/CLAUDE.md`. If it does not exist, create it with a `## Voice` section.
2. Search for the exact string `voice.md` in the file.
3. If absent, append (or create) this section:

```markdown

## Voice
NEVER write content on behalf of the user without running it through the humanizer skill against ~/.claude/voice.md.
```

4. If present, do nothing — idempotent.
5. Mention to the user: "Humanizer rule pinned in your CLAUDE.md. If you use CARL, consider moving the rule to a global CARL domain instead — same effect, lighter context cost."
</step>

<step name="report">
Tell the user:
- File written to `~/.claude/voice.md`
- Approximate token count
- Sections that came in strong (cite 2-3) and sections that are sparse (cite 1-2 if any)
- Sparse sections are not failures — they reflect the archive's depth in that area. Mention which sequence would deepen them if the user wants more.
</step>

</steps>

<output>
## Artifact
`~/.claude/voice.md` — compiled XML about_me profile.

## Format
See `context/compiler.md` for the full schema.

## Backup
Prior `voice.md` (if any) preserved at `~/.claude/voice.backup.md`.
</output>

<acceptance-criteria>
- [ ] Archive read and Q+A entry count confirmed
- [ ] Prior voice.md (if present) backed up
- [ ] New voice.md written with all required XML sections
- [ ] Token count under 5,000
- [ ] No padding, no flattering self-description, no biography
- [ ] User informed of file location, count, sparse sections
</acceptance-criteria>
