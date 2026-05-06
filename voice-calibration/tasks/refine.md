<purpose>
Calibration feedback loop. The user pastes a piece of AI output that was generated using their voice file, marks what does and doesn't sound like them line by line, and the deltas get captured back into the archive and recompiled. Closes the gap between *stated* taste (from interview answers) and *actual* taste (felt by reading output).
</purpose>

<user-story>
As a member whose voice file has been running for a few weeks, I want to feed back specific lines that sound off and lines that nailed it, so that the file evolves with my taste instead of ossifying at calibration day.
</user-story>

<when-to-use>
- User runs `/calibrate-voice refine`
- User says "my voice file is starting to feel off" or "this line doesn't sound like me"
- After the first month of use, recommended periodically
</when-to-use>

<context>
@../context/interviewer.md
@../context/compiler.md
</context>

<steps>

<step name="preflight" priority="first">
1. Confirm `~/.claude/voice.md` exists. If not, redirect to `tasks/sequence-1.md`.
2. Confirm `~/.claude/voice-archive.md` exists.
3. Set expectation: "I'll ask you to paste a piece of AI output that used your voice file. Then we mark what worked and what didn't, line by line. Should take 10-15 minutes. New voice file at the end."
4. **Wait for go-ahead.**
</step>

<step name="capture_sample">
Ask: "Paste the AI output you want to refine against. Anything generated with your voice file — could be a draft, an email, a post, a paragraph from a doc."

**Wait for paste.**

Echo back: "Got it. {N} lines/paragraphs. Now we go through it."
</step>

<step name="line_by_line_review">
For each meaningful unit (sentence, line, or short paragraph — your judgment based on length):

1. Quote the line back to the user.
2. Ask one question — pick whichever fits best:
   - "This sound like you?"
   - "This line — keep, kill, or rewrite?"
   - "What's off about this one?"
   - "This nailed it. What about it?"
3. Capture the response. If user says "off" or "not me," push: "Specifically — word choice, rhythm, register, refusal missed, what?"

Apply the locked interviewer rules from `context/interviewer.md`. No "I don't know" punts. Demand specifics.

Stop when the user says "we're done" or you've covered every meaningful line.
</step>

<step name="categorize_signals">
For each captured response, classify it into a voice.md section the compiler will update:

| Signal | Voice.md section affected |
|--------|---------------------------|
| "I'd never say this word" | `<phrase_bank><avoid>` |
| "This phrase nails it" | `<phrase_bank><use>` or `<golden_examples>` |
| "The rhythm is off" | `<voice_fingerprint>` |
| "This refusal should have fired" | `<hard_refusals>` |
| "This trope is exactly what I hate" | `<taste_disgusts>` |
| "This is the kind of judgment I'd make" | `<decision_rules>` |
| "This sounds like {writer-I'd-borrow-from}" | `<golden_examples>` |

If a signal doesn't fit cleanly, capture it under a free-form comment — the compiler will place it.
</step>

<step name="write_to_archive">
Append all captured signals to `~/.claude/voice-archive.md` under a new heading:

```
## Refinement Pass — {ISO date}

Sample reviewed: {one-line description, e.g. "LinkedIn post about Claude Code workflows"}

### Signal {N}: {category from table above}

Line: "{quoted line}"
User response: "{verbatim}"
Apply to: {section}

---
```

This keeps the archive append-only and gives the compiler new material on the next compile.
</step>

<step name="recompile">
Load and execute `tasks/compile.md`. The compiler reads the full archive — refinement signals get woven into the appropriate sections automatically (per `context/compiler.md` distillation rules).

After compile finishes, report: "{N} new signals captured. Voice file refreshed. Sections most affected: {list 2-3}."
</step>

<step name="closing">
Tell the user: "Refinement pass complete. Run this anytime your voice file starts to drift. The archive now has {total entries + refinement entries} items the compiler can draw from."
</step>

</steps>

<output>
## Artifact 1
Updated archive with refinement entries appended.

## Artifact 2
Recompiled `~/.claude/voice.md` reflecting refinement signals.
</output>

<acceptance-criteria>
- [ ] User pasted real AI output
- [ ] Each meaningful line reviewed with one specific question
- [ ] Push-back applied on vague responses
- [ ] All signals categorized to voice.md sections
- [ ] Refinement entries appended to archive (append-only)
- [ ] Voice file recompiled and report given
</acceptance-criteria>
