<purpose>
Run Sequence 3: 25 questions deepening Aesthetic Crimes, completing Structural Preferences, and adding tone variants from Voice & Personality. Adds ~15% fidelity (65% → 80%).
</purpose>

<user-story>
As a writer mid-calibration, I want to map my full aesthetic vocabulary and structural moves, so that my voice file catches the smaller patterns that make my work recognizable — not just the obvious tells.
</user-story>

<when-to-use>
- After S1 and S2 are complete
- User wants the aesthetic and structural depth pass
- Entry point routes here via `/calibrate-voice s3`
</when-to-use>

<context>
@../context/interviewer.md
</context>

<references>
@./compile.md (run after the sequence completes)
</references>

<steps>

<step name="preflight" priority="first">
1. Confirm `~/.claude/voice-archive.md` contains 50 entries (S1 + S2). If not, redirect.
2. Reload interviewer rules.
3. Set expectation: 25 questions, ~30 minutes.
4. **Wait for go-ahead.**
</step>

<step name="run_aesthetic_deepening">
Ask 10 AESTHETIC CRIMES questions, deeper than S1. Stems:

- A verbal tic you've started spotting in other people's work that drives you up the wall.
- An AI tell that goes beyond the obvious (em dashes, "delve") — something subtler.
- A formatting smell that signals "this writer is performing".
- A pattern that feels rented — like the writer borrowed someone else's voice and didn't fit it.
- Faux-vulnerability. What does it sound like when someone fakes openness?
- Faux-expertise. What's the tell?
- False intimacy — writers who try to be your friend in paragraph one.
- False certainty — what does over-confidence sound like to you?
- A word or phrase that used to feel fine and now feels poisoned. What changed?
- A move you respected once and now find lazy. Why did your taste shift?
</step>

<step name="run_structure_deepening">
Ask 9 STRUCTURAL PREFERENCES questions, completing the category. Stems:

- Bullets — when do they earn their place? When do they betray it?
- Headers — what makes a header pull weight vs. just decorate?
- Callouts, blockquotes, pull-quotes — your relationship with them.
- Transitions — explicit ("Here's the thing"), implicit (white space), or do you avoid both?
- How do you signal a new section without a header?
- How do you handle digressions? Embrace, parenthesize, or cut?
- Linear vs. branching — when does each fit?
- Where do you leave gaps for the reader to fill? When do you close them?
- An example of structure as content — where the shape carried meaning, not just the words.
</step>

<step name="run_voice_variants">
Ask 6 VOICE & PERSONALITY questions covering modulation. Stems:

- Sarcasm — yes, no, sparingly? Give a real instance.
- Irony — your relationship with it.
- How do you handle disagreement in writing — direct, oblique, with humor?
- What does your voice sound like when you're frustrated?
- What does it sound like when you're celebrating something?
- A voice you slide into when you're tired vs. when you're sharp. Same person?
</step>

<step name="confirm_and_compile">
1. Confirm: "Sequence 3 complete. 75/100 questions answered. Recompiling."
2. Load `tasks/compile.md`.
3. Ask: "Final sequence now, defer, or stop here?"
</step>

</steps>

<output>
## Archive
75 total Q+A entries.

## Compiled voice file
`~/.claude/voice.md` — refreshed with aesthetic depth and structural completeness.
</output>

<acceptance-criteria>
- [ ] Archive contains 75 total entries
- [ ] Quotas hit: 10 aesthetic + 9 structure + 6 voice = 25
- [ ] Voice file refreshed
- [ ] User chose continue/defer/stop
</acceptance-criteria>
