<purpose>
Run Sequence 2: 25 questions deepening Writing Mechanics, surfacing Beliefs & Contrarian Takes, and laying Structural Preferences foundations. Adds ~15% to calibration fidelity (50% → 65%).
</purpose>

<user-story>
As a writer who completed Sequence 1, I want to deepen my voice file with mechanics-level detail and the opinions that drive my voice, so that the AI doesn't just sound like me — it argues like me.
</user-story>

<when-to-use>
- After Sequence 1 is complete and archived
- User wants more depth on writing mechanics + their beliefs about their craft
- Entry point routes here via `/calibrate-voice s2` or post-S1 continuation
</when-to-use>

<context>
@../context/interviewer.md
</context>

<references>
@./compile.md (run after the sequence completes)
</references>

<steps>

<step name="preflight" priority="first">
1. Read `~/.claude/voice-archive.md`. Confirm S1 entries are present. If not, redirect user to `tasks/sequence-1.md`.
2. Reload the locked interviewer rules from `context/interviewer.md`.
3. Set expectation: 25 more questions, ~30 minutes. Voice file refreshes after this.
4. **Wait for go-ahead.**
</step>

<step name="run_mechanics_deepening">
Ask 11 WRITING MECHANICS questions, going deeper than S1. Stems:

- Relationship with line breaks — when do you double-space? Why?
- Lists. Love them, hate them, when do you use them?
- Headers — frequent, rare, never? What earns one?
- Formality scale — where do you live by default? When do you slide up or down?
- A signature construction. Name one and write a sentence using it.
- An unusual syntactic move you make — something most writers don't.
- A pet phrase — something you say a lot you only half-realize.
- A writer or post you've stolen a move from. Which move?
- A move you'd never copy, even from a writer you respect. Why?
- When do you break your own rules? Give a real example.
- The thing about your writing that took you the longest to figure out.
</step>

<step name="run_contrarian_beliefs">
Ask 8 BELIEFS & CONTRARIAN TAKES questions. Stems:

- Something you believe that most people in your field don't.
- A hot take you'd defend in public.
- Conventional wisdom in your space that you think is wrong.
- What people most often misunderstand about your work.
- A belief you hold that you can't yet justify with evidence — but you'd still bet on.
- A belief that has cost you something. What was it worth?
- A belief you've changed your mind about in the last 2 years. What flipped it?
- Something you used to defend that you'd now mock.
</step>

<step name="run_structure_foundations">
Ask 6 STRUCTURAL PREFERENCES questions. Stems:

- How do you organize ideas — outline first, write to find them, or both?
- A default structure you fall back on when you're tired.
- Do you lead with the conclusion or build to it? Why?
- How do you handle complexity — flatten it or layer it?
- Ordering principle — what comes first when you have multiple points?
- When do you deliberately break structure?
</step>

<step name="confirm_and_compile">
1. Confirm: "Sequence 2 complete. 50/100 questions answered. Recompiling your voice file."
2. Load and execute `tasks/compile.md`.
3. Ask: "Sequence 3 now, defer, or stop here?"
</step>

</steps>

<output>
## Archive
Updated `~/.claude/voice-archive.md` with 25 new Q+A entries (50 total).

## Compiled voice file
`~/.claude/voice.md` — refreshed with deeper mechanics, beliefs, and structural foundations.
</output>

<acceptance-criteria>
- [ ] Archive contains 50 total Q+A entries
- [ ] Quotas hit: 11 mechanics + 8 beliefs + 6 structure = 25
- [ ] Interviewer called out at least 1 contradiction with S1 answers if any surfaced
- [ ] Voice file refreshed
- [ ] User chose continue/defer/stop
</acceptance-criteria>
