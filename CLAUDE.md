# CLAUDE.md — Pantheon Session Orientation
> **Read this file every session. It is the only file you must always load.**  
> **Last updated:** 2026-04-27

---

## What Pantheon Is

Pantheon is a fork of Agent Zero that replaces its memory system with a custom knowledge graph, vector store, and multi-domain agent architecture organized around Greek mythology naming conventions. It is designed to be published as Pantheon Core — a platform for extensible, domain-specific AI agents called Gods.

Key components: Mnemosyne (ChromaDB vector store), GraphClient (SQLite relationship graph), Athenaeum (file-based knowledge store), DemeterWatcher (file watcher), Hades (nightly archival), Zeus (orchestrator), Gods (domain sub-agents), Sanctuary (isolated session mode), Iris (flagging system).

---

## Instance Separation — Critical

Three tiers exist. Never mix them:

- **Personal Instance** — private, contains real Athenaeum + Apollo (proprietary). Never published. Accessed via Tailscale. This document does NOT build this instance.
- **Dev Instance** — THIS document's build target. Dummy/test data only. No Apollo. No personal Gods. Lives on dev branch.
- **Pantheon Core Release** — future published version. Stripped of `.planning/`. Built from dev branch when stable.

**If unsure which instance you are in — stop and ask the user.**

---

## Non-Negotiable Rules

- Never make decisions without asking the user first
- Never skip a phase — the dependency chain is strict
- Never modify an Agent Zero file without checking `AGENT_ZERO_DEP_MAP.md` first
- Never archive a document without running `dependency_check()` first
- Never delete a stub without replacing it completely
- Never recreate a document from scratch — always patch with targeted edits
- Never run `git add -A` before confirming `.gitignore` is in place and verified
- Never put personal data, Apollo, or personal God harnesses in the dev instance
- Never modify Pantheon's `docker-compose.yml` to extend Agent Zero's Docker config
- Never run a `[CONTAINER]` command on the host or vice versa
- Before any multi-cloud-model test, run `ollama ps` — confirm active cloud models < 3
- Always run the Git Sync Check before touching any file (see: How to Start a Session)
- Agent Zero must work in FREE_CHAT mode after every change to an Agent Zero file (see: APPENDICES.md)

---

## Tooling Stack

- **Ollama** — runs on HOST machine. Container reaches it via `host.docker.internal:11434`
- **Ollama Cloud** — Pro tier = 3 concurrent models max
- **Docker** — Pantheon owns its own `docker-compose.yml`. Agent Zero is a code dependency only.
- **GitNexus** — MCP codebase graph. Commands: `impact()`, `context()`, `query()`, `detect_changes()`
- **ChromaDB** — vector store, runs in container
- **SQLite** — graph DB, runs in container
- **watchdog** — DemeterWatcher file events, runs in container

### Command Context Convention
- `[HOST]` — runs on user's machine
- `[CONTAINER]` — runs inside Pantheon Docker container
- Unlabeled = `[HOST]`

---

## File Map

```
CLAUDE.md                          ← HERE (read every session)
pantheon/.planning/
  HANDOFF.md                       ← read every session — current session state
  STATE.md                         ← read every session — phase completion tracker
  BACKLOG.md                       ← known gaps and future work
  GRAPH_LAYER.md                   ← graph architecture spec (read in Phase 4)
  GENEALOGY.md                     ← project lineage reference
  AGENT_ZERO_DEP_MAP.md            ← built in Phase 1, critical from Phase 7 onward
  phases/
    PHASE_0.md                     ← Environment & Tooling Setup
    PHASE_1.md                     ← Agent Zero Dependency Map
    PHASE_2.md                     ← Pantheon Foundation
    PHASE_3.md                     ← DemeterWatcher
    PHASE_4.md                     ← GraphClient & Entity Extraction
    PHASE_5.md                     ← Mnemosyne
    PHASE_6.md                     ← Hades
    PHASE_7.md                     ← Agent Zero Memory Swap
    PHASE_8.md                     ← Zeus & God Registry
    PHASE_9.md                     ← Integration Testing
    APPENDICES.md                  ← FREE_CHAT test definition, Git workflow, backlog
```

---

## How to Start a Session

**Step 1 — Load orientation**
1. Read this file (`CLAUDE.md`)
2. Read `pantheon/.planning/HANDOFF.md`
3. Read `pantheon/.planning/STATE.md`

**Step 2 — Git Sync Check (mandatory before touching anything)**

```bash
# [HOST]
git branch --show-current
git status
git fetch origin
git status
git log --oneline -5
git log --oneline -5 origin/$(git branch --show-current)
```

Report to user:
```
GIT SYNC STATUS
Branch: [name]
Local uncommitted changes: [none | list]
Local vs remote: [up to date | X ahead | X behind | DIVERGED]
Last local commit: [hash and message]
Last remote commit: [hash and message]
```

Then ask:
- BEHIND → "Should I pull before we start?"
- AHEAD → "Should I push now or at end of session?"
- DIVERGED → "WARNING: diverged. Must resolve before any work. Review now?"
- Up to date → "Git is in sync. Ready to proceed."

**Do not proceed until user acknowledges Git state.**

**Step 3 — GitNexus**
```bash
# [HOST]
npx gitnexus status
```
If stale, run `npx gitnexus analyze` before anything else.

**Step 4 — Load phase file**
Check `STATE.md` for current phase. Load only that phase file from `phases/`. Tell user current phase and next step. Ask to confirm before proceeding.

---

## How to End a Session

**Step 1 — Commit and push**
```bash
# [HOST]
git add -A
git status
```
Show user what will be committed. Ask for commit message approval. Then:
```bash
# [HOST]
git commit -m "[approved message]"
git push origin $(git branch --show-current)
```
Confirm push succeeded. If push fails, see APPENDICES.md — Git Workflow Reference.

Do not write HANDOFF until push confirmed or user explicitly says to skip.

**Step 2 — Write HANDOFF.md**
```
# HANDOFF — [DATE TIME]

## Current Phase
Phase [X] — [phase name]

## Completed This Session
- [list]

## In Progress (CRITICAL)
- File: [exact path]
- What was being written: [description]
- How far complete: [detail]

## Decisions Made
- [list with reasoning]

## Blockers or Questions
- [anything unresolved]

## Next Step (one sentence, specific)
[Exact next action]

## Stub Status
- pantheon-core/gods/demeter.py: [stub | partial | complete]
- pantheon-core/gods/hades.py: [stub | partial | complete]
- pantheon-core/graph/client.py: [stub | partial | complete]
- pantheon-core/mnemosyne/client.py: [stub | partial | complete]
- pantheon-core/session.py: [stub | partial | complete]

## GitNexus Index
Last analyzed: [datetime]
Needs re-analyze before next session: [yes | no]

## Git State at Session End
Remote: [URL]
Branch: [name]
Last commit pushed: [hash and message]
Uncommitted work remaining: [yes — describe | no]

## Agent Zero FREE_CHAT Status
Tested this session: [yes | no | not applicable]
```

Tell user HANDOFF written and work committed. Stop.

---

## If You Are GLM-5.1

You are the fallback model. Claude Code hit its context limit.

1. Read `CLAUDE.md` (this file)
2. Read `pantheon/.planning/HANDOFF.md`
3. Read `pantheon/.planning/STATE.md`
4. Run Git Sync Check (Step 2 above)
5. Run `npx gitnexus status`
6. Load current phase file from `phases/`
7. Tell user current state and next step. Ask to confirm.

If GitNexus MCP is unavailable:
> "GitNexus MCP tools are not available. I will continue but without blast radius analysis. I will ask before modifying any existing file. Proceed on this basis?"

Do not modify any Agent Zero file without GitNexus impact analysis OR explicit user approval.
