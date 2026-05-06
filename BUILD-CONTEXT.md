# voice-system — Architecture Reference

**Repo:** `apps/humanizer/` in chris-ai-systems workspace. Published as `github.com/ChristopherKahler/humanizer` (fork of `github.com/blader/humanizer`). Installs as `~/.claude/skills/voice-system/` on member machines.

**Status:** Shipped (v1.0.0). Skill is live, slash command is wired, voice file pipeline is functional, demo + refine + status loops exist.

**Last updated:** 2026-05-06

> This doc is the architecture reference. Read it to understand what's installed, how the pieces fit, and what files do what. For the user-facing pitch, see `README.md`. For Skool lesson copy, see `planning/skool-design/skool-roadmap/quick-win-lesson-v2.md` in Chris's private workspace.

---

## 1. What this is

A Claude Code skill plus slash command that gives a writer two things on every output:

1. **Humanizer** — strips 29 AI-writing patterns (em dashes, AI vocabulary, rule of three, sycophancy, etc.). Auto-activates on writing tasks.
2. **Voice matching** — auto-detects `~/.claude/voice.md` and applies it as standing voice reference. No prompt engineering.

The voice file is built via the `/calibrate-voice` slash command. Two paths in (interview or sample bootstrap), one output (compiled XML profile).

This skill is the first slot in the Operator Build framework. Future slots: design-system, state-system, rule-system, etc.

---

## 2. Why this exists

### The audience

Skool community: **AI Builders & Operators** (`https://www.skool.com/claude-code-titans-9203`). $33/mo founding tier. Audience is entrepreneurs and operators already using Claude in their work.

### The Day 1 win

This is the community's Day 1 quick win — first felt outcome a new member produces after the welcome ritual. The win is emotional: AI output that sounds like *them*, not like AI. Most members feel the violation of generic AI output putting words in their mouth. Calibrating their voice and seeing the BEFORE/AFTER lands viscerally.

### The 50/90 frame

Methodology Chris teaches: most people accept AI's 50% slop output and ship it (or hand-rewrite half of it). The whole game is the gap from 50% to 90%. With voice-system + calibrated voice file, output lands at 90% — production-ready with light polish. The 10% you stays valuable.

The wizard is the most accessible proof of the 50/90 frame. Members run it once and see it.

---

## 3. Install architecture

```
member workflow:
  1. git clone https://github.com/ChristopherKahler/humanizer ~/.claude/skills/voice-system
  2. open Claude Code anywhere, say: "Set up voice-system and run voice calibration."
  3. Claude reads SKILL.md, sees no /calibrate-voice symlink yet, runs Bash:
     ln -s ~/.claude/skills/voice-system/commands/calibrate-voice.md ~/.claude/commands/calibrate-voice.md
  4. Claude proceeds into the calibration interview.

after step 3:
  ~/.claude/skills/voice-system/                    ← skill (auto-activates)
  ├── SKILL.md                                       ← humanizer + voice.md auto-detection + first-time setup logic
  ├── commands/
  │   └── calibrate-voice.md                         ← slash command source
  ├── voice-calibration/                             ← slash command support (NOT a skill)
  │   ├── README.md                                  ← clarifies "not a skill"
  │   ├── context/
  │   │   ├── interviewer.md                         ← push-back DNA, 6 locked rules
  │   │   └── compiler.md                            ← XML schema + distillation
  │   └── tasks/
  │       ├── sequence-1.md                          ← 25q quick win, 50% fidelity
  │       ├── sequence-2.md                          ← 25q +15%
  │       ├── sequence-3.md                          ← 25q +15%
  │       ├── sequence-4.md                          ← 25q +20%
  │       ├── sample-bootstrap.md                    ← 3-5 samples, 15 min, ~35%
  │       ├── compile.md                             ← archive → voice.md, pins NEVER rule
  │       ├── demo.md                                ← side-by-side BEFORE/AFTER
  │       ├── status.md                              ← pipeline state, no compile
  │       └── refine.md                              ← feedback loop on real AI output
  ├── README.md                                      ← user-facing docs
  ├── BUILD-CONTEXT.md                               ← this file
  ├── LICENSE
  └── WARP.md

  ~/.claude/commands/
  └── calibrate-voice.md → symlink → ../skills/voice-system/commands/calibrate-voice.md  (created by Claude during setup)
```

**Key install behaviors:**

- The clone target is `voice-system`, not `humanizer`. Members with an existing `~/.claude/skills/humanizer/` install are not affected — Claude's setup step detects and reports it during the prose-prompt setup.
- No bash install script. Setup happens through Claude's first-time setup logic in SKILL.md, triggered when the user prompts "set up voice-system" or similar. Claude runs one `ln -s` via the Bash tool. On-brand: AI does the work.
- Skill discovery happens automatically because the SKILL.md frontmatter declares `name: voice-system`. The skill works for humanize tasks even before the slash command symlink exists — only `/calibrate-voice` invocation needs the symlink.
- The `voice-calibration/` subdirectory has a README, not a SKILL.md, by design — to prevent Claude Code from auto-discovering it as a sub-skill.

---

## 4. Output files (in user home)

| Path | Purpose |
|------|---------|
| `~/.claude/voice.md` | Compiled XML voice profile. Read by the skill on every output. Regenerated on every compile. |
| `~/.claude/voice-archive.md` | Raw Q+A transcript, append-only across sequences and refinement passes. Source for the compiler. |
| `~/.claude/voice.backup.md` | One-step rollback (created automatically before each recompile). |
| `~/.claude/CLAUDE.md` | Receives a NEVER rule on first compile: *NEVER write content on behalf of the user without running it through the humanizer skill against ~/.claude/voice.md.* |

---

## 5. Calibration flow

```
member runs /calibrate-voice
   │
   ├─→ Path A: interview (no samples)
   │     │
   │     └─→ tasks/sequence-1.md (25q, 30 min, 50% fidelity)
   │           ├─→ append Q+A verbatim to ~/.claude/voice-archive.md
   │           └─→ tasks/compile.md (XML profile → ~/.claude/voice.md)
   │
   ├─→ Path B: sample bootstrap (paste 3-5 samples)
   │     │
   │     └─→ tasks/sample-bootstrap.md (15 min, ~35% fidelity)
   │           ├─→ extract patterns, append to archive
   │           └─→ tasks/compile.md
   │
   └─→ Either path ends at:
         ├─→ ~/.claude/voice.md (compiled)
         ├─→ ~/.claude/CLAUDE.md (NEVER rule pinned, idempotent)
         ├─→ tasks/demo.md (offered) — side-by-side WITHOUT/WITH
         └─→ user choice: continue, defer, or stop

later (anytime):
   /calibrate-voice s2/s3/s4    → deepen fidelity (each adds 25q)
   /calibrate-voice compile     → recompile from current archive
   /calibrate-voice demo        → run a fresh BEFORE/AFTER
   /calibrate-voice refine      → feedback loop on real AI output
   /calibrate-voice status      → pipeline state, no compile
```

---

## 6. Locked interviewer rules

From `voice-calibration/context/interviewer.md`. Distilled from `planning/skool-design/skool-roadmap/voice-interview.md` (Chris's private source). These rules preserve signal density and apply to every sequence and refinement pass.

1. **One question at a time.** Wait for the response. Never batch.
2. **Push back on vague answers.** "Simple how? Give me an example of simple done right and simple done lazy."
3. **Demand specific examples.** "Show me a sentence you've written that captures this."
4. **Call out contradictions.** Earlier answer disagrees with current? Name it. Force reconciliation.
5. **Don't accept 'I don't know.'** Reframe. Approach from another angle. Move on only if a third reframe also fails.
6. **Follow threads.** Unusual or charged answers get dug into before returning to the planned question.

---

## 7. Compiler distillation rule

From `voice-calibration/context/compiler.md`. Distilled from `planning/skool-design/skool-roadmap/voice-compiler.md`. Single test applied to every candidate line:

> "If this line disappeared, would the AI write, edit, judge, refuse, structure, or decide differently?"

Yes → keep. No → cut.

Output is XML structured, under 5,000 tokens. Sections: `<voice_fingerprint>`, `<writing_laws>`, `<communication_laws>`, `<hard_refusals>`, `<taste_loves>`, `<taste_disgusts>`, `<phrase_bank>`, `<signature_tells>`, `<decision_rules>`, `<productive_contradictions>`, `<golden_examples>`, `<do_not_infer>`, `<final_instruction>`.

---

## 8. Question distribution across sequences

100 questions total, split into 4 sequences of 25:

| Sequence | Mechanics | Aesthetic | Voice/Personality | Hard Nos | Red Flags | Beliefs | Structure | Cumulative |
|----------|-----------|-----------|-------------------|----------|-----------|---------|-----------|------------|
| S1 (quick win) | 9 | 5 | 4 | 3 | 4 | 0 | 0 | 50% |
| S2 (deepen) | 11 | 0 | 0 | 0 | 0 | 8 | 6 | 65% |
| S3 (structure + aesthetic) | 0 | 10 | 6 | 0 | 0 | 0 | 9 | 80% |
| S4 (edges + refusals) | 0 | 0 | 5 | 7 | 6 | 7 | 0 | 100% |
| **Totals** | **20** | **15** | **15** | **10** | **10** | **15** | **15** | |

S1 deliberately targets the categories that compile into the densest output: phrase_bank, voice_fingerprint, taste_disgusts, surface refusals.

Sample bootstrap (alternate to S1) targets the same density via pattern extraction from real writing — sentence length, vocabulary, punctuation, recurring phrases, openers, closers, tone markers, conspicuously absent AI patterns. ~35% fidelity standalone, since samples can't surface refusals or beliefs. Combine with S1 for ~65%.

---

## 9. Source references (canonical, do not edit)

These live in Chris's private workspace and are the design DNA:

- `planning/skool-design/skool-roadmap/voice-interview.md` — Taste Interviewer (100q, 7 categories)
- `planning/skool-design/skool-roadmap/voice-compiler.md` — Voice Compiler (XML about_me schema)

The skill ships with operational distillations of both at `voice-calibration/context/`. Members do not need access to the sources.

---

## 10. Skool lesson coupling

The Quick Win lesson at module `4816d975da284ae58d64ed523069eee5` (Founder's Toolkit course `6fb4abc404024d60b2d8b1fba43133d6`, short_id `08b93416`) makes promises this skill must fulfill:

- ~30 minutes for the core win → S1 delivers (~30 min, 50% fidelity)
- Voice file at `~/.claude/voice.md` → compile.md writes it
- BEFORE/AFTER demo → demo.md provides it
- Two paths (samples or interview) → sample-bootstrap.md + sequence-1.md cover both
- CLAUDE.md NEVER rule pinned → compile.md handles it idempotently
- Refine loop → refine.md provides it

If lesson copy and skill behavior diverge, **update lesson copy first** (`planning/skool-design/skool-roadmap/quick-win-lesson-v2.md`) and push to Skool via `mcp__skool__skool_classroom_update_lesson`. The skill is source of truth for what actually happens.

---

## 11. Known limitations and open questions

1. **Member input quality is the floor.** Push-back rules help, but vague answers produce vague files. Mitigated by the demo step (makes deficit visible) and refine.md (closes the gap over time).
2. **GitHub repo name.** The fork is `github.com/ChristopherKahler/humanizer` but installs as `voice-system`. Optional rename of the GitHub repo would tighten branding (`git clone .../voice-system .../voice-system`). Not blocking.
3. **CARL integration.** The pinned CLAUDE.md NEVER rule could move to a CARL global domain instead. Currently the lesson mentions this as a pro tip; the compiler doesn't auto-detect CARL. Future enhancement.
4. **OpenCode parity.** The slash command symlink only matters for Claude Code. OpenCode users must invoke calibration by asking the skill directly, not via `/calibrate-voice`. Listed as a known limitation in the README.
5. **Speech-to-text not enforced.** Recommended in the SKILL.md greeting and lesson copy, but not gated. Typed answers will run 45-60 min instead of 30 because typing self-edits. Members are warned but not blocked.

---

## 12. Maintenance protocol

When changing skill behavior:

1. Edit files in `apps/humanizer/` (this dev path).
2. Test locally by running `/calibrate-voice` against your `~/.claude/skills/voice-system/` install. (Symlink the dev dir or re-clone for testing.)
3. Commit and push to `github.com/ChristopherKahler/humanizer`.
4. If user-facing behavior changed, update:
   - `README.md` (this repo)
   - Skool lesson copy (`planning/skool-design/skool-roadmap/quick-win-lesson-v2.md`)
   - Push lesson via Skool MCP

When adding a new sequence or task:

1. Create the task file in `voice-calibration/tasks/`.
2. Add it to the dispatch table in `commands/calibrate-voice.md`.
3. Update `voice-calibration/README.md` layout section.
4. Update this file's section 5 (calibration flow) and section 8 (question distribution) if applicable.
5. Update the README's subcommand table.

---

## 13. North Star reminder

The skill's job is not to be impressive software. The skill's job is to make a brand new Skool member feel, in under 30 minutes, that AI can produce work in their voice. That feeling is the Day 1 win. Everything else is mechanics.

Build for the feeling, not for feature completeness. Then ship.
