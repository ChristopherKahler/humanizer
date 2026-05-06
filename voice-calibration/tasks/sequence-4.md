<purpose>
Run Sequence 4: 25 questions completing Beliefs & Contrarian Takes, Voice & Personality edges, Hard Nos, and Red Flags. Brings calibration to 100% (80% → 100%).
</purpose>

<user-story>
As a writer who has done the work through S3, I want to lock down the edges — what I refuse, what I distrust, what makes me different — so that my voice file carries the full 100 questions of behavioral DNA.
</user-story>

<when-to-use>
- After S1, S2, and S3 are complete
- User wants full 100-question fidelity
- Entry point routes here via `/calibrate-voice s4`
</when-to-use>

<context>
@../context/interviewer.md
</context>

<references>
@./compile.md (run after the sequence completes)
</references>

<steps>

<step name="preflight" priority="first">
1. Confirm `~/.claude/voice-archive.md` contains 75 entries (S1 + S2 + S3). If not, redirect.
2. Reload interviewer rules.
3. Set expectation: 25 final questions, ~30 minutes. Final compile after this.
4. **Wait for go-ahead.**
</step>

<step name="run_beliefs_remaining">
Ask 7 BELIEFS & CONTRARIAN TAKES questions, completing the category. Stems:

- A belief you hold strongly in private but soften in public. What's the gap?
- A contrarian position you'd defend on stage tomorrow.
- A belief about your craft that took years to earn.
- A belief about your audience that most people in your field would dispute.
- An older belief that you've abandoned but still notice the shadow of.
- Something you keep believing despite the evidence pointing the other way.
- A belief you can't articulate yet but you act on every day.
</step>

<step name="run_voice_edges">
Ask 5 VOICE & PERSONALITY questions covering edges. Stems:

- Voice when you're skeptical — what changes?
- Voice when you're curious — leaning in, asking, or quiet?
- Voice when you're angry. How does it land in writing vs. speech?
- Voice when you're tender — how do you keep it from going saccharine?
- Voice when you're teaching. Different from telling? How?
</step>

<step name="run_hard_nos_remaining">
Ask 7 HARD NOS questions completing the category. Stems:

- Words you would never use, even if asked nicely.
- Structures you reject — give one and say why.
- Postures you reject — what's a posture that's just not you?
- A claim you'd never make, even if it tested well.
- A comparison or analogy you'd avoid. Why's it loaded?
- A pattern that violates your code of how to write.
- A line you wouldn't cross even for money. What's on the other side?
</step>

<step name="run_red_flags_remaining">
Ask 6 RED FLAGS questions completing the category. Stems:

- A tell that signals a content piece is grift.
- A tell that signals intellectual laziness.
- A tell that signals emotional dishonesty in writing.
- A tell of borrowed authority — when someone is wearing someone else's expertise.
- A subtler AI signal beyond the obvious patterns.
- A tell of hired ghostwriting — what makes it not the credited person?
</step>

<step name="confirm_and_compile">
1. Confirm: "Sequence 4 complete. 100/100 questions answered. Final compile."
2. Load `tasks/compile.md`.
3. Report: file location, total tokens, summary of what got captured.
4. Suggest: "Voice file is at full fidelity. To refine over time, run `/calibrate-voice compile` after editing the archive, or rerun a specific sequence to deepen one area."
</step>

</steps>

<output>
## Archive
100 total Q+A entries.

## Compiled voice file
`~/.claude/voice.md` — full fidelity. All XML sections populated from the full archive.
</output>

<acceptance-criteria>
- [ ] Archive contains 100 total entries
- [ ] Quotas hit: 7 beliefs + 5 voice + 7 hard nos + 6 red flags = 25
- [ ] Voice file refreshed at full fidelity
- [ ] User informed of completion + maintenance options
</acceptance-criteria>
