<purpose>
Run a side-by-side BEFORE/AFTER demo. Generate the same writing prompt twice — once WITHOUT `~/.claude/voice.md`, once WITH it — and present both side by side. The point is to make the calibration win felt: members see their voice file working in under 60 seconds.
</purpose>

<user-story>
As a member who just compiled their voice file, I want to see the difference between voice-on and voice-off output, so that I feel — viscerally, not abstractly — what the calibration earned me.
</user-story>

<when-to-use>
- Immediately after the first compile (Sequence 1 just finished)
- User runs `/calibrate-voice demo` manually
- User says "show me the difference" or "does this even work"
</when-to-use>

<context>
@../context/compiler.md
</context>

<steps>

<step name="preflight" priority="first">
1. Read `~/.claude/voice.md`. If missing or empty, stop and tell the user to run a sequence + compile first.
2. Pick the demo prompt. Ask the user:

> "Pick a demo:
> - (a) LinkedIn post about something you just learned
> - (b) Cold email opener to a potential client
> - (c) Quick personal note explaining a decision
> - (d) Custom — tell me the topic and format"

**Wait for choice.** If custom, ask one follow-up: topic + format + audience.
</step>

<step name="generate_without_voice">
Generate the chosen piece WITHOUT loading voice.md. Use a generic capable-writer voice. Keep length appropriate for the format (LinkedIn post: 100-200 words; email opener: 3-5 sentences; personal note: 50-100 words).

Apply the humanizer pattern list from the parent voice-system `SKILL.md` (one directory up: `../../SKILL.md`) to remove obvious AI tells, but do NOT use voice.md for matching. The point is to show what generic-but-clean looks like.

Label the output: `--- WITHOUT YOUR VOICE FILE ---`
</step>

<step name="generate_with_voice">
Generate the SAME piece using `~/.claude/voice.md` as standing reference. Apply every section of the voice file: voice_fingerprint for rhythm, phrase_bank for word choice, taste_disgusts for what to avoid, hard_refusals as gates, golden_examples for sentence shapes.

Same length range. Same topic. Different voice.

Label the output: `--- WITH YOUR VOICE FILE ---`
</step>

<step name="present_side_by_side">
Display both pieces with clear labels. Brief framing — one short line above each, not paragraphs.

Then ask the user one question:

> "Which feels more like you, and which line specifically tipped it?"

**Wait for response.** This is signal — if they cite a specific line, that line is a strong candidate for adding to `<golden_examples>` in voice.md on the next refine pass.
</step>

<step name="capture_signal">
If the user identified a specific line that "felt like them":
1. Append a new entry to `~/.claude/voice-archive.md` under a `## Demo Signal` heading:
```
### Demo: {date} — {format chosen}

Line that landed: "{quoted line}"
Why (user's words): "{user's response}"
```
2. Mention to the user: "Captured that as a signal for next refine pass. If you ever run `/calibrate-voice refine`, this gets weighted into golden_examples."

If they say neither felt like them, capture that too — that's a sign voice.md needs a refine pass or another sequence.
</step>

</steps>

<output>
## Artifact
Two pieces of writing labeled WITHOUT and WITH the voice file, presented inline. Optional archive entry capturing demo signal.

## No file write
Demo output is ephemeral — shown to user, not saved as a deliverable. Only signal capture writes to disk.
</output>

<acceptance-criteria>
- [ ] User picked a demo format
- [ ] WITHOUT version generated using generic voice + humanizer patterns
- [ ] WITH version generated using full voice.md as standing reference
- [ ] Both presented side by side with clear labels
- [ ] User asked which felt more like them and what specifically tipped it
- [ ] If specific line cited, captured to archive as demo signal
</acceptance-criteria>
