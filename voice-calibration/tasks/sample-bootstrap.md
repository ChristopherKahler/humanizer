<purpose>
Bootstrap a starter voice file from 3-5 pasted writing samples — no interview required. Faster path to a working `~/.claude/voice.md` for members who already have writing they're proud of. Targets the same densest categories as Sequence 1 (voice_fingerprint, phrase_bank, signature_tells, golden_examples) without asking a single question. Roughly 35-40% calibration fidelity in ~15 minutes. Sequence 1 stays available afterward to add the categories samples cannot reach (hard_refusals, taste_disgusts, beliefs, red flags).
</purpose>

<user-story>
As a writer who already has emails, posts, or doc snippets I'm happy with, I want to paste them and get a working voice file in 15 minutes, so that I get to a felt win fast and can decide whether to invest in the deeper interview later.
</user-story>

<when-to-use>
- Member has 3-5 pieces of writing handy and wants the fastest path
- User runs `/calibrate-voice samples` or says "I'd rather paste samples than answer questions"
- Pre-existing voice file feels off and member wants to refresh from real writing
</when-to-use>

<context>
@../context/compiler.md
</context>

<references>
@../../SKILL.md (voice-system parent — humanizer pattern list used during sample analysis)
</references>

<steps>

<step name="preflight" priority="first">
1. Read `~/.claude/voice-archive.md`. If it exists with prior entries (interview or bootstrap), ask: "Existing archive found with {N} entries. Add this bootstrap as a new pass, or back up old archive and start fresh?" **Wait for choice.**
2. If no archive, create with header (same format used by sequence tasks).
3. Set expectation: 3-5 samples, ~10-15 minutes, voice file at the end. Mention the gap honestly: "Samples teach me your mechanics — rhythm, words, sentence shapes. They don't teach me your refusals, your contrarian takes, or what you'd never write. Sequence 1 covers that. You can run it after if you want."
4. Confirm ready. **Wait for go-ahead.**
</step>

<step name="capture_samples">
Ask: "Paste 3-5 pieces of your writing. Anything works — emails, LinkedIn posts, a Skool comment, a blog draft, a DM you sent that you liked. Topic doesn't matter. Mix formats if you want — diversity helps. Paste them one at a time or as a single block, whatever's easier."

**Wait for samples.**

For each sample, confirm receipt and any context the user offers (e.g. "this was a cold email" or "this was a tough reply"). Do not analyze yet.

If fewer than 3 samples are provided, push back: "Three minimum. Two samples teach me your defaults; the third tells me when you break them. Anything you can dig up?" Don't accept "I don't have anything" easily — reframe: "What was the last thing you wrote that you'd send to a stranger without editing?"
</step>

<step name="extract_patterns">
For each sample, extract the following patterns. Capture observations as raw notes — these become archive entries the compiler reads.

| Pattern | What to look for |
|---------|------------------|
| Sentence length distribution | Average + variance. Punchy short, long-flowing, mixed? |
| Vocabulary level | Casual / technical / mixed. Specific high-frequency words. |
| Sentence openers | How does the user start sentences? Subject-first? Adverb? Fragment? |
| Sentence enders | How do they land? Trail off, button hard, question? |
| Punctuation habits | Em dash usage (count actual instances), hyphenated pairs, parentheticals, ellipses, colons. |
| Paragraph breaks | When does a new paragraph start? Topic shift, breath, emphasis? |
| Transitions | Explicit ("but", "so", "however") or jump-cut between paragraphs? |
| First/second/third person tendency | Who's the subject of most sentences? |
| Recurring phrases or verbal tics | Anything that shows up across multiple samples. Quote them verbatim. |
| Tone markers | Direct, dry, warm, sharp, sardonic, earnest. Cite specific lines as evidence. |
| Things conspicuously absent | What AI patterns are NOT in these samples? (em dashes, "delve", rule of three, bolded inline headers, etc.) Note these — they become hard_refusals signals. |

Be specific. "Average sentence length is short" is weak. "Average sentence ~12 words; opens with subject in 8/10 cases; ends with period in 9/10 cases; one fragment per ~4 sentences" is strong.
</step>

<step name="write_to_archive">
Append a structured Sample Bootstrap entry to `~/.claude/voice-archive.md`:

```
## Sample Bootstrap — {ISO date}

Samples provided: {N}
Sample contexts: {brief list, e.g. "1 LinkedIn post, 2 client emails, 1 blog draft opener"}

### Pattern: Sentence length and rhythm

{specific observations with numbers}

Evidence: "{quoted sentence from sample 2}"
        "{quoted sentence from sample 4}"

### Pattern: Vocabulary

High-frequency words: {list}
Notable absences: {list}

Evidence: {quoted phrases}

### Pattern: Punctuation

{specific observations}

Evidence: {quoted lines}

### Pattern: Openers and closers

{observations}

Evidence: {opener and closer pairs}

### Pattern: Recurring phrases

{verbatim list}

### Pattern: Tone markers

{observations with cited lines}

### Pattern: Conspicuously absent

{AI patterns not present in samples}

---
```

Each `### Pattern:` block becomes a high-leverage entry the compiler distills into voice_fingerprint, phrase_bank, signature_tells, and golden_examples sections.
</step>

<step name="compile">
Load and execute `tasks/compile.md`. The compiler reads the bootstrap entries (and any prior interview entries) and writes `~/.claude/voice.md`.

After compile finishes, report what came in strong (likely voice_fingerprint, phrase_bank, signature_tells) and what stayed sparse (likely hard_refusals, decision_rules, productive_contradictions — these need interview answers).
</step>

<step name="offer_demo_and_next">
1. Offer immediate demo: "Want to see the file working? `/calibrate-voice demo` runs a side-by-side WITHOUT and WITH your voice file on a test piece. Takes a minute."
2. Offer Sequence 1: "Sequence 1 is 25 questions, ~30 min. Adds the categories samples can't surface — what you refuse, what you distrust, what makes you cringe. Pushes fidelity from ~35% to ~65% combined. Up to you."
3. Honor whichever they pick (or neither).
</step>

</steps>

<output>
## Artifact 1: Archive
`~/.claude/voice-archive.md` with a Sample Bootstrap entry containing structured pattern extractions.

## Artifact 2: Compiled voice file
`~/.claude/voice.md` — XML profile populated from sample patterns.

## Artifact 3: Pinned humanizer rule
`~/.claude/CLAUDE.md` updated with NEVER rule (via compile.md).
</output>

<acceptance-criteria>
- [ ] At least 3 samples captured
- [ ] Pattern extraction covers all 11 categories from the table
- [ ] Each pattern observation cites evidence (quoted lines from samples)
- [ ] Bootstrap entry appended to archive
- [ ] Voice file compiled and pinned rule confirmed
- [ ] Demo and Sequence 1 offered as next steps
- [ ] User informed honestly that hard_refusals and beliefs sections are sparse without interview
</acceptance-criteria>
