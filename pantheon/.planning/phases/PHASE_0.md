# PHASE 0 — Environment & Tooling Setup
> **Self-contained phase file. Read CLAUDE.md + HANDOFF.md + STATE.md first, then this file.**  
> **Goal:** Everything in place before writing a line of Pantheon code.  
> **You may proceed when:** User confirms they are ready for Phase 0.  
> **On completion:** Update STATE.md Phase 0 to ✅ Complete, set Current Phase to Phase 1.

---

## Phase Rules (applies to this phase only)
- Ask before every action — this phase sets up the environment other phases depend on
- Do not proceed past any step that ends in an error
- Every shell command is labeled [HOST] or [CONTAINER]. Unlabeled = [HOST].
- At every CHECKPOINT: write HANDOFF.md, commit all work, ask user to confirm before continuing

## Commit Format for This Phase
`[Phase 0.X] description of what was done`

---

## Step 0.1 — Test GLM-5.1 Fallback

Ask the user:
> "Have you already tested GLM-5.1 via `ollama run glm-5.1:cloud`? If yes, did GitNexus MCP tools work in that session? If no, would you like to test it now?"

If MCP did NOT carry over to GLM-5.1, ask:
> "GitNexus MCP tools are not available in GLM-5.1 sessions. Would you like to: (A) Accept this limitation and use manual context dumps as fallback, or (B) Investigate a workaround first?"

Do not proceed until user has answered.

**CHECKPOINT 0.1**
- Write HANDOFF.md: GLM-5.1 status, user's MCP fallback decision
- Commit: `[Phase 0.1] GLM-5.1 fallback status confirmed`
- Ask: "Ready to move to Step 0.2?"

---

## Step 0.2 — Fork and Verify Agent Zero

Ask:
> "Do you already have Agent Zero forked and cloned locally? If yes, what is the path? If no, should I walk you through the fork process?"

Once path is confirmed:
```bash
# [HOST]
cd [agent-zero-path]
python main.py
```

If it fails, show the error and ask:
> "Agent Zero failed to start: [error]. Resolve now or is there a different setup process?"

Do not proceed until Agent Zero boots successfully.

**CHECKPOINT 0.2**
- Write HANDOFF.md: Agent Zero path, boot status
- Commit: `[Phase 0.2] Agent Zero fork verified`
- Ask: "Ready to move to Step 0.2.5?"

---

## Step 0.2.5 — Clear Stale FAISS Index

This resolves a known Agent Zero issue where a cached FAISS index causes 400 errors on `/api/embed` after Ollama or the container restarts. Must be done before any further setup.

```bash
# [HOST]
docker exec agent-zero rm -f /a0/usr/memory/default/index.faiss /a0/usr/memory/default/index.pkl
docker restart agent-zero
```

Send a test message. Watch console for embedding errors. If errors persist after clearing:
> "Embedding errors still present: [error]. Resolve before continuing?"

Do not proceed until embedding calls complete without errors.

**CHECKPOINT 0.2.5**
- Write HANDOFF.md: FAISS cleared yes/no, embedding errors after restart
- Commit: `[Phase 0.2.5] Stale FAISS index cleared`
- Ask: "Ready to move to Step 0.2.6?"

---

## Step 0.2.6 — Create Pantheon docker-compose.yml

Ask:
> "I'm creating Pantheon's own docker-compose.yml — separate from Agent Zero's config. Confirm:
> 1. What port for the Pantheon web UI? (Agent Zero default is 50001)
> 2. Any additional volume mounts needed beyond Athenaeum and planning directories?"

Write `docker-compose.yml` at repo root:
```yaml
# [HOST] — run from host machine
services:
  pantheon:
    build: .
    ports:
      - "[user-chosen-port]:80"
    volumes:
      - ./pantheon/athenaeum:/app/pantheon/athenaeum
      - ./pantheon/.planning:/app/pantheon/.planning
      - ./pantheon/flags:/app/pantheon/flags
    environment:
      - OLLAMA_HOST=http://host.docker.internal:11434
    extra_hosts:
      - "host.docker.internal:host-gateway"    # required for Linux
    restart: unless-stopped
```

Write minimal `Dockerfile` at repo root:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "main.py"]
```

Note: `extra_hosts` is required for Linux (CachyOS). Windows and Mac resolve `host.docker.internal` automatically.

Test the build:
```bash
# [HOST]
docker compose build
```

Do not proceed until build succeeds.

**CHECKPOINT 0.2.6**
- Write HANDOFF.md: docker-compose created, Dockerfile created, build status, port chosen
- Update STATE.md Key Decisions: Web UI port
- Commit: `[Phase 0.2.6] Pantheon docker-compose and Dockerfile created`
- Ask: "Ready to move to Step 0.3?"

---

## Step 0.3 — Verify GitNexus Installation

```bash
# [HOST]
npx gitnexus --version
```

If not installed:
> "GitNexus is not installed. Install now with `npm install -g gitnexus`? This is load-bearing for Phase 1."

Confirm required commands exist:
```bash
# [HOST]
npx gitnexus --help | grep -E "impact|context|query|detect_changes"
```

If any command missing:
> "GitNexus is missing [command]. May be an older version. Update it?"

Do not proceed until all commands confirmed.

**CHECKPOINT 0.3**
- Write HANDOFF.md: GitNexus version, all commands confirmed yes/no
- Commit: `[Phase 0.3] GitNexus installation verified`
- Ask: "Ready to move to Step 0.4?"

---

## Step 0.4 — Set Up GitNexus on the Fork

```bash
# [HOST]
cd [agent-zero-path]
npx gitnexus analyze --embeddings --verbose 2>&1 | tee gitnexus_analyze.log
grep -i "skip\|warn\|error" gitnexus_analyze.log
npx gitnexus status
```

Show user any skipped files. Ask:
> "GitNexus skipped: [list]. Note manually in MANUAL_DEPS.md, or unimportant?"

**CHECKPOINT 0.4**
- Write HANDOFF.md: GitNexus index status, skipped files, user's decision
- Commit: `[Phase 0.4] GitNexus analyzed Agent Zero fork`
- Ask: "Ready to move to Step 0.5?"

---

## Step 0.5 — Create Pantheon Directory Structure and .gitignore

Show user this structure and ask for confirmation before creating anything:

```
pantheon/
  .planning/
    STATE.md
    BACKLOG.md
    GRAPH_LAYER.md
    GENEALOGY.md
    HANDOFF.md              ← created in Step 0.6
    AGENT_ZERO_DEP_MAP.md   ← created in Phase 1
    phases/
      PHASE_0.md through PHASE_9.md + APPENDICES.md
  pantheon-core/
    __init__.py
    graph/
      __init__.py
      client.py, schema.py, exceptions.py    ← stubs
    mnemosyne/
      __init__.py
      client.py, agent_zero_adapter.py       ← stubs
    gods/
      __init__.py
      demeter.py, hades.py, zeus.py, registry.py  ← stubs
    session.py, harness.py, iris.py, charon.py, redistill_queue.py  ← stubs
  gods/
    hephaestus/
      god.yaml, harness.yaml, prompts/, README.md
    zeus/
      god.yaml, harness.yaml, prompts/, README.md
  gods-private/
    .gitkeep
  skills/
    .gitkeep
  flags/
    .gitkeep
  .athenaeum/
    .gitkeep
```

After user confirms, create structure. Then immediately write `.gitignore` — check for existing Agent Zero `.gitignore` first and append rather than overwrite:

```bash
# [HOST]
cat .gitignore
```

Add to `.gitignore`:
```gitignore
# Pantheon runtime data — never commit
pantheon/.athenaeum/.chromadb/
pantheon/.athenaeum/*.db
pantheon/.athenaeum/*.db-shm
pantheon/.athenaeum/*.db-wal
pantheon/.athenaeum/.state.json
pantheon/.athenaeum/.hades.lock

# Private Gods — never commit
gods-private/
!gods-private/.gitkeep

# Iris flags (runtime)
pantheon/flags/*.md
!pantheon/flags/.gitkeep

# GitNexus artifacts
gitnexus_analyze.log
.gitnexus/

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.env
```

Verify `.gitignore` works:
```bash
# [HOST]
git status
```

Confirm none of the gitignored paths appear as untracked. If they do, fix the pattern before continuing.

Then copy existing planning documents into `pantheon/.planning/`. Ask user where they currently live.

**CHECKPOINT 0.5**
- Write HANDOFF.md: structure created, .gitignore written and verified, planning docs copied
- Commit: `[Phase 0.5] Pantheon directory structure and .gitignore created`
- Ask: "Ready to move to Step 0.6?"

---

## Step 0.6 — Create CLAUDE.md and HANDOFF.md

Ask:
> "Before writing CLAUDE.md, I need to confirm:
> 1. What Gods do you plan to have besides Zeus and Hephaestus?
> 2. What is your primary machine's OS and Python version?
> 3. What Git remote are you using and what is the repo URL?
> 4. What port is the Pantheon web UI on? (set in Step 0.2.6)
> 5. Anything about how you work both models should know?"

Write CLAUDE.md. Show it to user and ask:
> "Does this accurately describe the project? What would you change?"

Revise until approved. Then create the HANDOFF.md template.

**CHECKPOINT 0.6 — Phase 0 Complete**
- Write HANDOFF.md: CLAUDE.md approved, HANDOFF template created, all stub statuses
- Update STATE.md: Phase 0 ✅ Complete, Current Phase → Phase 1, Key Decisions (Git remote URL)
- Commit: `[Phase 0.6] CLAUDE.md and HANDOFF.md created — Phase 0 complete`
- Push and confirm
- Ask: "Phase 0 is complete. Ready to begin Phase 1 — the Agent Zero dependency map?"
