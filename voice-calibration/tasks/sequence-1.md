<purpose>
Run Sequence 1 of the voice calibration: 25 questions across the highest-leverage categories (Writing Mechanics, Aesthetic Crimes, Voice & Personality, Hard Nos, Red Flags). Produces 50% of the full calibration fidelity in ~30 minutes — the quick win. Targets the densest behavioral output per token: phrase_bank, voice_fingerprint, taste_disgusts, surface refusals.
</purpose>

<user-story>
As a writer who just installed the humanizer skill, I want to spend 30 minutes answering targeted questions, so that I get a working `~/.claude/voice.md` file my AI sessions read every time — even if I never run sequences 2-4.
</user-story>

<when-to-use>
- First-time calibration (no `~/.claude/voice-archive.md` yet)
- User wants the quick win and may stop here
- Entry point routes here via `/calibrate-voice`
</when-to-use>

<context>
@../context/interviewer.md
</context>

<references>
@./compile.md (run after the sequence completes)
</references>

<steps>

<step name="preflight" priority="first">
1. Read `~/.claude/voice-archive.md`. If it exists with prior sequences, ask the user if they want to start fresh (back up old archive) or resume from a different sequence. Do not silently overwrite.
2. If archive does not exist, create it with the header from `context/interviewer.md`.
3. Set the user expectation in one short paragraph: 25 questions, ~30 minutes, voice.md will be usable at the end. Mention that S2-S4 are optional and deepen the profile.
4. Confirm they're ready. **Wait for go-ahead.**
</step>

<step name="run_writing_mechanics_block">
Ask 9 questions from WRITING MECHANICS. Quota is firm; question wording is yours, drawn from these stems (one stem per question, not all in one):

- Words you reach for too often. Name 3-5.
- Words you genuinely love using. Why those?
- Words you would never use. What's wrong with them in your mouth?
- Default sentence shape — short and punchy, long and rolling, mixed? Give a real example.
- How do you open a piece of writing? Pattern or vibe?
- How do you close one? Land hard, trail off, button it?
- Punctuation you lean on. Punctuation you avoid. Why?
- Paragraph breaks — what triggers a new paragraph for you?
- Transitions — explicit connectors ("however", "but"), or do you just jump?

Apply the locked rules from `context/interviewer.md`: one at a time, push back on vague, demand examples, call contradictions, don't accept "I don't know", follow threads.

After each answer, append verbatim Q+A to `~/.claude/voice-archive.md`.
</step>

<step name="run_aesthetic_crimes_block">
Ask 5 questions from AESTHETIC CRIMES. Stems:

- What makes you cringe in other people's writing?
- A specific phrase or pattern that feels like nails on a chalkboard.
- What kind of content reads as lazy or assembled to you?
- A formatting move that signals AI to you immediately.
- A trope you can't unsee once you've spotted it.

Same rules. Verbatim capture.
</step>

<step name="run_voice_personality_block">
Ask 4 questions from VOICE & PERSONALITY. Stems:

- Default tone when nothing's at stake. Direct? Warm? Dry?
- How do you use humor — or do you?
- How do you sound when you're being serious?
- How do you sound when you're excited about something?

Same rules. Verbatim capture.
</step>

<step name="run_hard_nos_block">
Ask 3 questions from HARD NOS. Stems:

- Topics you would never write about publicly. Why?
- An approach you would never take, even if it worked.
- A line you wouldn't cross — what's on the other side?

Same rules. Verbatim capture.
</step>

<step name="run_red_flags_block">
Ask 4 questions from RED FLAGS. Stems:

- What makes you immediately distrust a piece of content?
- Signals that the writer doesn't actually know the subject.
- Signs of borrowed authority — fake expertise.
- A tell that someone used AI and didn't edit it.

Same rules. Verbatim capture.
</step>

<step name="confirm_and_compile">
1. Confirm to the user: "Sequence 1 complete. 25/100 questions answered. Compiling your voice file now."
2. Load and execute `tasks/compile.md`.
3. After compile finishes, report the file location and ask: "Continue with Sequence 2 now, save it for another session, or stop here?"
4. Honor their choice. If they continue, load `tasks/sequence-2.md`. If they stop, end cleanly.
</step>

</steps>

<output>
## Artifact 1: Archive
Append-only file at `~/.claude/voice-archive.md`. After S1: 25 verbatim Q+A entries plus header.

## Artifact 2: Compiled voice file
`~/.claude/voice.md` — XML about_me profile. Usable immediately by sibling humanizer skill.
</output>

<acceptance-criteria>
- [ ] Archive file exists with 25 verbatim Q+A entries
- [ ] Quotas hit: 9 mechanics + 5 aesthetic + 4 voice + 3 hard nos + 4 red flags = 25
- [ ] Interviewer pushed back at least 3 times on vague answers across the sequence
- [ ] Voice file at `~/.claude/voice.md` exists and contains all required XML sections
- [ ] User confirmed whether to continue, defer, or stop
</acceptance-criteria>
