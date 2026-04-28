# PHASE 1 — Agent Zero Dependency Map
> **Self-contained phase file. Read CLAUDE.md + HANDOFF.md + STATE.md first, then this file.**  
> **Goal:** Know exactly what breaks before breaking anything.  
> **You may proceed when:** User confirms Phase 0 complete.  
> **Output:** `pantheon/.planning/AGENT_ZERO_DEP_MAP.md`  
> **On completion:** Update STATE.md Phase 1 to ✅ Complete, set Current Phase to Phase 2.

---

## Phase Rules
- This phase is READ ONLY — no Pantheon code is written here
- Every shell command is labeled [HOST] or [CONTAINER]. Unlabeled = [HOST].
- Do not make the Approach A/B decision yourself — present data and ask
- At every CHECKPOINT: write HANDOFF.md, commit all work, ask user to confirm

## Commit Format for This Phase
`[Phase 1.X] description of what was done`

---

## Before Starting

Tell the user:
> "Phase 1 produces the dependency map that every later phase depends on. This phase is read-only — we are mapping what Agent Zero does so we know exactly what to preserve when we replace its memory system. This should take one focused session."

---

## Step 1.1 — Map vector_db.py

```
impact({target: "vector_db", direction: "upstream", minConfidence: 0.7})
context({name: "vector_db"})
```

Create `pantheon/.planning/AGENT_ZERO_DEP_MAP.md` with:

```markdown
## vector_db.py

### Callers
| File | What it imports | What it expects returned | Has tests? |
|------|----------------|--------------------------|------------|

### Public API surface
[list every method/function callers use]

### FAISS-specific assumptions
[list places callers assume FAISS internals, not just the interface]
```

Open each caller file and read the relevant section before filling in the table.

**CHECKPOINT 1.1**
- Write HANDOFF.md: DEP_MAP created, number of callers found
- Commit: `[Phase 1.1] vector_db.py dependency map section created`
- Ask: "Does this look complete? Ready to move to Step 1.2?"

---

## Step 1.2 — Map document_query.py

```
impact({target: "document_query", direction: "upstream", minConfidence: 0.7})
context({name: "document_query"})
```

Add to `AGENT_ZERO_DEP_MAP.md`:

```markdown
## document_query.py

### Callers
| File | What it imports | What it expects returned | Has tests? |
|------|----------------|--------------------------|------------|

### Public API surface
[list every method/function callers use]

### Assumptions about query behavior
[list places callers assume specific query behavior]
```

**CHECKPOINT 1.2**
- Write HANDOFF.md: document_query.py section added
- Commit: `[Phase 1.2] document_query.py dependency map section created`
- Ask: "Ready to move to Step 1.3?"

---

## Step 1.3 — Map the Session Initialization Chain

```
query({query: "session initialization startup agent init"})
```

Trace manually from `main.py` to first LLM call. Open each file in the chain.

Add to `AGENT_ZERO_DEP_MAP.md`:

```markdown
## Session Initialization Chain

### Startup sequence (main.py → first LLM call)
1. [file] — [what it does at init]
2. [file] — [what it does at init]
...

### Where Sanctuary mode flag should be injected
Recommended injection point: [file and function]
Reasoning: [why here]
```

Before filling in injection point, ask:
> "I think the best place to inject the Sanctuary mode flag is [location] because [reason]. Does this make sense, or would you like to discuss options?"

Wait for confirmation.

**CHECKPOINT 1.3**
- Write HANDOFF.md: init chain documented, injection point agreed yes/no
- Update STATE.md Key Decisions: Sanctuary injection point
- Commit: `[Phase 1.3] Session initialization chain mapped`
- Ask: "Ready to move to Step 1.4?"

---

## Step 1.4 — Map the Agent Profile System

```
query({query: "agent profile config behavioral parameters"})
```

Add to `AGENT_ZERO_DEP_MAP.md`:

```markdown
## Agent Profile / Config System

### How Agent Zero defines agent behavior
[describe the current mechanism]

### Where harness YAML will integrate
[file and mechanism for injecting harness constraints]

### What Agent Zero expects vs. what Pantheon will provide
| Agent Zero expects | Pantheon will provide |
|--------------------|-----------------------|
| | |
```

**CHECKPOINT 1.4**
- Write HANDOFF.md: agent profile section added
- Commit: `[Phase 1.4] Agent profile system mapped`
- Ask: "Ready to move to Step 1.5?"

---

## Step 1.5 — The Approach Decision

**Do not make this decision. Present data and ask.**

Show user this table filled from the dep map:

```markdown
| Question | Answer |
|----------|--------|
| How many files call vector_db.py? | [count] |
| Are callers tightly coupled to FAISS internals? | [yes/no + evidence] |
| Can vector_db.py be replaced with a same-interface adapter? | [yes/no + evidence] |
| How many files would need changes if we swap it? | [count] |
| Does Agent Zero's profile system support external YAML injection? | [yes/no] |
```

Then ask:
> "Based on this data, two approaches:
>
> **Approach A — Wrap and Replace:** Keep Agent Zero's file structure. Create adapters matching its interfaces. Swap one file at a time. Agent Zero works throughout.
> *Best if:* Few callers, clean interfaces, no FAISS-internal coupling.
>
> **Approach B — Gut and Rebuild:** Remove Agent Zero's memory layer, build Pantheon's systems in the vacated space. More upfront work, cleaner result.
> *Best if:* Many callers, FAISS internals assumed, tangled dependencies.
>
> The data suggests [A/B] because [reason]. Which approach?"

Wait for user's decision. Write it and reasoning to dep map.

Run dynamic threat check:
```bash
# [HOST]
grep -r "importlib\|__import__\|getattr" [agent-zero-path] --include="*.py"
```

Add any dynamic imports found to dep map as a separate section.

**CHECKPOINT 1.5 — Phase 1 Complete**
- Write HANDOFF.md: dep map complete, approach decision, dynamic imports found
- Update STATE.md: Phase 1 ✅ Complete, Current Phase → Phase 2, Key Decisions (Approach A or B)
- Commit: `[Phase 1.5] Dependency map complete — Approach [A/B] decided — Phase 1 complete`
- Push and confirm
- Ask: "Phase 1 complete. Ready to begin Phase 2 — Pantheon Foundation?"
