<purpose>
Read-only state report on the voice-calibration pipeline. Tells the user how many questions are answered, which sequences are complete, current voice.md fidelity, and what to do next. No interview, no compile.
</purpose>

<user-story>
As a member returning to a calibration in progress, I want to see exactly where I left off, so that I know whether to resume, recompile, or refine without guessing.
</user-story>

<when-to-use>
- User runs `/calibrate-voice status`
- User asks "where am I in the calibration" or "what's my voice file fidelity"
- Used by `/calibrate-voice` (no args) to detect prior runs before routing
</when-to-use>

<steps>

<step name="read_state" priority="first">
1. Read `~/.claude/voice-archive.md`. If missing, report: "No archive yet. Run `/calibrate-voice` to start Sequence 1." Stop.
2. Count Q+A entries. Parse which sequences are complete:
   - 25 entries → S1 done
   - 50 entries → S1+S2 done
   - 75 entries → S1+S2+S3 done
   - 100 entries → all four done
   - Other counts → mid-sequence (note the partial)
3. Read `~/.claude/voice.md` if it exists. Note its modification time and approximate token count (rough word count × 1.3).
4. Read `~/.claude/CLAUDE.md` if it exists. Check whether the humanizer NEVER rule is pinned.
</step>

<step name="report">
Output a tight status block:

```
Voice Calibration — Status

Archive:        ~/.claude/voice-archive.md
Q+A entries:    {N}/100
Sequences:      {S1 ✓ | S2 ✓ | ...}
Fidelity:       ~{50/65/80/100}%

Voice file:     ~/.claude/voice.md
Last refresh:   {ISO date or "never"}
Approx tokens:  {N}

Humanizer rule pinned in CLAUDE.md: {yes/no}

Suggested next:
- {one specific recommendation based on state}
```

Recommendation logic:
- If 0 entries: "Start with `/calibrate-voice` (Sequence 1, ~30 min)."
- If S1 done, no compile: "Run `/calibrate-voice compile` to generate voice.md."
- If S1+ done and voice.md exists: "Either continue with `/calibrate-voice s{next}` to deepen, or run `/calibrate-voice demo` to feel the win."
- If 100/100 done: "Voice file is at full fidelity. Run `/calibrate-voice refine` periodically to update based on real AI output."
- If voice.md older than 30 days AND archive unchanged: "Consider a `/calibrate-voice refine` pass — taste drifts."
</step>

</steps>

<output>
## Artifact
Status report displayed to the user. No files written.
</output>

<acceptance-criteria>
- [ ] Archive read and entry count reported
- [ ] Sequence completion mapped from entry count
- [ ] Voice file existence + freshness reported
- [ ] CLAUDE.md rule presence checked
- [ ] One specific next-action suggestion offered
</acceptance-criteria>
