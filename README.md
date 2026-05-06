# voice-system

A Claude Code skill that strips signs of AI-generated writing and matches your calibrated voice on every output. The first slot in the Operator Build.

Two capabilities, one install:

1. **Humanizer.** Detects and rewrites 29 AI-writing patterns (em dash overuse, AI vocabulary, rule of three, sycophancy, hyphenated pairs, fragmented headers, and more). Based on Wikipedia's "Signs of AI writing" guide.
2. **Voice matching.** Auto-detects `~/.claude/voice.md` (built via the `/calibrate-voice` slash command) and applies it as standing voice reference. The file gets loaded silently on every output. No prompt engineering.

Fork of [github.com/blader/humanizer](https://github.com/blader/humanizer) 2.5.1, extended with voice.md auto-detection, the `/calibrate-voice` slash command, and the 4-sequence calibration system.

## Install

Two steps. One bash command, one prose prompt.

**1. Clone:**

```bash
git clone https://github.com/ChristopherKahler/humanizer ~/.claude/skills/voice-system
```

**2. Tell Claude to finish setup.** Open Claude Code in any directory and say:

> Set up voice-system and run voice calibration.

Claude detects the fresh clone, wires the `/calibrate-voice` slash command (one symlink), warns you if you have a separate humanizer install at `~/.claude/skills/humanizer/` (it stays untouched), then walks you into calibration. About 30 minutes for the quick win.

After setup, `/calibrate-voice` is invokable from any Claude Code session via subcommands (`samples`, `s2`/`s3`/`s4`, `compile`, `demo`, `refine`, `status`).

### OpenCode

OpenCode scans `~/.claude/skills/` for skill compatibility, so the same clone works. The slash command symlink only matters for Claude Code; OpenCode users invoke calibration by asking the skill directly ("calibrate my voice").

## Usage

### Humanizer (auto-activates)

Ask Claude to write or revise anything:

```
Humanize this text: [your text]
```

Or just write normally. The skill auto-activates on writing tasks and strips AI patterns silently. If `~/.claude/voice.md` exists, it also matches your voice.

### Voice calibration

Run the slash command:

```
/calibrate-voice
```

That builds your voice file via a 4-sequence interview. Sequence 1 alone is the quick win: 25 questions, ~30 minutes, 50% calibration fidelity. Sequences 2-4 deepen to 100%.

Alternate path if you have writing samples handy:

```
/calibrate-voice samples
```

Paste 3-5 emails, posts, or doc snippets. The system extracts your patterns. ~15 minutes, ~35% fidelity. Faster but doesn't surface your refusals or beliefs (run Sequence 1 after for the full picture).

### Subcommands

| Command | What it does |
|---------|--------------|
| `/calibrate-voice` | Start calibration (Sequence 1) or resume from prior state |
| `/calibrate-voice samples` | Sample bootstrap path (paste writing) |
| `/calibrate-voice s2` / `s3` / `s4` | Run additional sequences for deeper fidelity |
| `/calibrate-voice compile` | Recompile voice.md from current archive |
| `/calibrate-voice demo` | Side-by-side BEFORE/AFTER on a real prompt |
| `/calibrate-voice refine` | Feed back real AI output, refine the file |
| `/calibrate-voice status` | Pipeline state report (no compile) |

### Files written

| Path | Purpose |
|------|---------|
| `~/.claude/voice.md` | Compiled XML voice profile. Read by the skill on every output. Regenerated on every compile. |
| `~/.claude/voice-archive.md` | Raw Q+A transcript, append-only across sequences. Source for the compiler. |
| `~/.claude/voice.backup.md` | One-step rollback (created automatically before each recompile). |
| `~/.claude/CLAUDE.md` | Receives a NEVER rule on first compile, gating all output through the humanizer against voice.md. |

### Recommended for the interview

- **Voice-to-text dictation.** Typing self-edits while you go. Speaking keeps answers raw. Any local dictation works (macOS dictation, SuperWhisper, MacWhisper, Wispr Flow).
- **Opus 4.7 with extended thinking on.** The interviewer pushes back on vague answers and follows threads. Bigger model plus extended thinking produces sharper push-back.

The compiler step doesn't need extended thinking. The interview does.

## How calibration works

The interviewer follows six locked rules to extract behavioral DNA:

1. One question at a time. Wait for the answer.
2. Push back on vague answers. Demand specifics.
3. Demand specific examples ("show me a sentence you've written").
4. Call out contradictions across answers.
5. Don't accept "I don't know" without two reframes.
6. Follow threads when something unusual emerges.

The compiler distills the raw archive against one test for every line:

> "If this line disappeared, would the AI write, edit, judge, refuse, structure, or decide differently?"

Yes → keep. No → cut. Output is a compact XML profile under 5,000 tokens.

## What's in voice.md

The compiled profile uses XML structure:

- `<voice_fingerprint>` — operational voice description (rhythm, density, directness)
- `<writing_laws>` — specific do/avoid rules with examples
- `<communication_laws>` — rules for emails, replies, disagreement, refusals
- `<hard_refusals>` — things the AI should never write or imply
- `<taste_loves>` / `<taste_disgusts>` — what to gravitate toward and reject
- `<phrase_bank>` — words and phrases to use vs. avoid
- `<signature_tells>` — small recurring details that make you recognizable
- `<decision_rules>` — how you judge quality, honesty, competence, bullshit
- `<productive_contradictions>` — tensions to preserve, not smooth out
- `<golden_examples>` — 3-6 BAD/GOOD pairs teaching high-value patterns

## 29 Humanizer Patterns Detected

### Content patterns

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 1 | **Significance inflation** | "marking a pivotal moment in the evolution of..." | "was established in 1989 to collect regional statistics" |
| 2 | **Notability name-dropping** | "cited in NYT, BBC, FT, and The Hindu" | "In a 2024 NYT interview, she argued..." |
| 3 | **Superficial -ing analyses** | "symbolizing... reflecting... showcasing..." | Remove or expand with actual sources |
| 4 | **Promotional language** | "nestled within the breathtaking region" | "is a town in the Gonder region" |
| 5 | **Vague attributions** | "Experts believe it plays a crucial role" | "according to a 2019 survey by..." |
| 6 | **Formulaic challenges** | "Despite challenges... continues to thrive" | Specific facts about actual challenges |

### Language patterns

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 7 | **AI vocabulary** | "Actually... additionally... testament... landscape... showcasing" | "also... remain common" |
| 8 | **Copula avoidance** | "serves as... features... boasts" | "is... has" |
| 9 | **Negative parallelisms / tailing negations** | "It's not just X, it's Y", "..., no guessing" | State the point directly |
| 10 | **Rule of three** | "innovation, inspiration, and insights" | Use natural number of items |
| 11 | **Synonym cycling** | "protagonist... main character... central figure... hero" | "protagonist" (repeat when clearest) |
| 12 | **False ranges** | "from the Big Bang to dark matter" | List topics directly |
| 13 | **Passive voice / subjectless fragments** | "No configuration file needed" | Name the actor when it helps clarity |

### Style patterns

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 14 | **Em dash overuse** | "institutions—not the people—yet this continues—" | Prefer commas or periods |
| 15 | **Boldface overuse** | "**OKRs**, **KPIs**, **BMC**" | "OKRs, KPIs, BMC" |
| 16 | **Inline-header lists** | "**Performance:** Performance improved" | Convert to prose |
| 17 | **Title Case Headings** | "Strategic Negotiations And Partnerships" | "Strategic negotiations and partnerships" |
| 18 | **Emojis** | "🚀 Launch Phase: 💡 Key Insight:" | Remove emojis |
| 19 | **Curly quotes** | `said "the project"` (curly) | `said "the project"` (straight) |
| 26 | **Hyphenated word pairs** | "cross-functional, data-driven, client-facing" | Drop hyphens on common word pairs |
| 27 | **Persuasive authority tropes** | "At its core, what matters is..." | State the point directly |
| 28 | **Signposting announcements** | "Let's dive in", "Here's what you need to know" | Start with the content |
| 29 | **Fragmented headers** | "## Performance" + "Speed matters." | Let the heading do the work |

### Communication patterns

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 20 | **Chatbot artifacts** | "I hope this helps! Let me know if..." | Remove entirely |
| 21 | **Cutoff disclaimers** | "While details are limited in available sources..." | Find sources or remove |
| 22 | **Sycophantic tone** | "Great question! You're absolutely right!" | Respond directly |

### Filler and hedging

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 23 | **Filler phrases** | "In order to", "Due to the fact that" | "To", "Because" |
| 24 | **Excessive hedging** | "could potentially possibly" | "may" |
| 25 | **Generic conclusions** | "The future looks bright" | Specific plans or facts |

## References

- [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) — primary source for humanizer patterns
- [WikiProject AI Cleanup](https://en.wikipedia.org/wiki/Wikipedia:WikiProject_AI_Cleanup) — maintaining organization
- Upstream: [github.com/blader/humanizer](https://github.com/blader/humanizer)

## Version history

- **1.0.0** (voice-system, this fork) — Renamed install identity to voice-system. Added `~/.claude/voice.md` auto-detection in the skill. Added `/calibrate-voice` slash command with 4-sequence interview, sample-bootstrap path, compiler, demo, status, and refine subcommands. Added `install.sh` for one-command setup. Pins NEVER rule to `~/.claude/CLAUDE.md` on first compile.
- **2.5.1** (upstream) — Added passive-voice / subjectless-fragment rule, total 29 patterns
- **2.5.0** — Persuasive framing, signposting, fragmented headers; expanded negative parallelisms to tailing negations
- **2.4.0** — Voice calibration via inline samples (predecessor to voice.md auto-detection)
- **2.3.0** — Pattern #26 (hyphenated word pair overuse)
- **2.2.0** — Final "obviously AI generated" audit + second-pass rewrite
- **2.1.x** — Examples and curly-quote fixes
- **2.0.0** — Complete rewrite based on Wikipedia article
- **1.0.0** — Initial release

## License

MIT
