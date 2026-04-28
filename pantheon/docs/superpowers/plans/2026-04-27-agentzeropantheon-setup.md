# Agent Zero Pantheon Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rename the existing Pantheon repo to Pantheon-old, clone the Agent Zero fork as the new base, layer all surviving Pantheon code under a `pantheon/` subdirectory, install the new planning structure, and leave the project ready for Phase 0 execution.

**Architecture:** Agent Zero fork is the runtime base. All Pantheon code lives inside a `pantheon/` subdirectory — never touching Agent Zero files at this stage. New planning docs go into `pantheon/.planning/phases/`. Existing working modules (harness, sanctuary, vault) are copied over as-is. New stub modules (graph, mnemosyne, iris, charon) are created empty so GitNexus can index them in Phase 1.

**Tech Stack:** Git, Python 3.x, bash. No new dependencies introduced in this plan.

---

## File Map

### Renamed
- `/c/projects/Pantheon` → `/c/projects/Pantheon-old`

### Cloned
- `/c/projects/Pantheon/` (entire Agent Zero fork from `https://github.com/Duskript/agent-zero`)

### Created — Planning Structure
- `/c/projects/Pantheon/CLAUDE.md`
- `/c/projects/Pantheon/pantheon/.planning/STATE.md`
- `/c/projects/Pantheon/pantheon/.planning/HANDOFF.md`
- `/c/projects/Pantheon/pantheon/.planning/BACKLOG.md`
- `/c/projects/Pantheon/pantheon/.planning/GRAPH_LAYER.md`
- `/c/projects/Pantheon/pantheon/.planning/GENEALOGY.md`
- `/c/projects/Pantheon/pantheon/.planning/AGENT_ZERO_DEP_MAP.md`
- `/c/projects/Pantheon/pantheon/.planning/phases/PHASE_0.md`
- `/c/projects/Pantheon/pantheon/.planning/phases/PHASE_1.md`
- `/c/projects/Pantheon/pantheon/.planning/phases/PHASE_2.md`
- `/c/projects/Pantheon/pantheon/.planning/phases/PHASE_3.md` through `PHASE_9.md` (stubs)
- `/c/projects/Pantheon/pantheon/.planning/phases/APPENDICES.md` (stub)
- `/c/projects/Pantheon/pantheon/.planning/archive/` (old planning docs)

### Migrated from Pantheon-old
- `pantheon/pantheon-core/harness/` (loader.py, schema.py, exceptions.py, __init__.py)
- `pantheon/pantheon-core/sanctuary/` (config.py, __init__.py)
- `pantheon/pantheon-core/vault/` (writer.py, __init__.py)
- `pantheon/pantheon-core/gods/__init__.py`
- `pantheon/pantheon-core/routing/__init__.py`
- `pantheon/pantheon-core/requirements.txt`
- `pantheon/pantheon-core/tests/` (all test files and fixtures)
- `pantheon/Athenaeum.scaffold/` (entire directory)
- `pantheon/scripts/` (init-athenaeum.sh, migrate-oracle-vault.sh)
- `pantheon/docs/superpowers/` (existing specs and plans)

### Created — New Stubs
- `pantheon/pantheon-core/__init__.py`
- `pantheon/pantheon-core/graph/__init__.py`
- `pantheon/pantheon-core/graph/client.py`
- `pantheon/pantheon-core/graph/schema.py`
- `pantheon/pantheon-core/graph/exceptions.py`
- `pantheon/pantheon-core/mnemosyne/__init__.py`
- `pantheon/pantheon-core/mnemosyne/client.py`
- `pantheon/pantheon-core/mnemosyne/agent_zero_adapter.py`
- `pantheon/pantheon-core/iris.py`
- `pantheon/pantheon-core/charon.py`
- `pantheon/pantheon-core/session.py`
- `pantheon/pantheon-core/harness.py`
- `pantheon/pantheon-core/redistill_queue.py`

### Created — Placeholder Dirs and God Stubs
- `pantheon/gods/zeus/god.yaml`
- `pantheon/gods/zeus/harness.yaml`
- `pantheon/gods/hephaestus/god.yaml`
- `pantheon/gods/hephaestus/harness.yaml`
- `pantheon/gods-private/.gitkeep`
- `pantheon/skills/.gitkeep`
- `pantheon/flags/.gitkeep`
- `pantheon/.athenaeum/.gitkeep`
- `pantheon/harnesses/.gitkeep`

### Modified
- `/c/projects/Pantheon/.gitignore` (append Pantheon entries)

### Created — Docker
- `/c/projects/Pantheon/docker-compose.yml` (stub, port TBD in Phase 0 Step 0.2.6)

---

## Task 1: Rename existing repo and clone Agent Zero fork

**Files:**
- Rename: `/c/projects/Pantheon` → `/c/projects/Pantheon-old`
- Create: `/c/projects/Pantheon/` (cloned)

- [ ] **Step 1.1: Rename existing Pantheon repo**

```bash
mv /c/projects/Pantheon /c/projects/Pantheon-old
```

Verify:
```bash
ls /c/projects/ | grep Pantheon
```
Expected output includes both `Pantheon-old` and confirms `Pantheon` no longer exists.

- [ ] **Step 1.2: Clone Agent Zero fork**

```bash
git clone https://github.com/Duskript/agent-zero /c/projects/Pantheon
```

- [ ] **Step 1.3: Verify clone succeeded**

```bash
ls /c/projects/Pantheon
```
Expected: Agent Zero files present (e.g., `main.py`, `requirements.txt`, `.git/`).

- [ ] **Step 1.4: Confirm Agent Zero's remote is correct**

```bash
cd /c/projects/Pantheon && git remote -v
```
Expected: `origin  https://github.com/Duskript/agent-zero (fetch)` and `(push)`.

- [ ] **Step 1.5: Commit checkpoint note**

No commit needed yet — this is a fresh clone with no Pantheon changes. Continue to Task 2.

---

## Task 2: Install new planning structure

**Files:**
- Source zip extract: `/tmp/agentzeroPantheon/` (CLAUDE.md, STATE.md, PHASE_0.md, PHASE_1.md, PHASE_2.md)
- Create: `pantheon/.planning/phases/` directory tree
- Create: all planning files listed in File Map above

- [ ] **Step 2.1: Re-extract zip if needed**

Check the extract is still present:
```bash
ls /tmp/agentzeroPantheon/
```
If missing (shows error), re-extract:
```bash
mkdir -p /tmp/agentzeroPantheon && unzip -o "/c/Users/krudolph/Downloads/agentzeroPantheon.zip" -d /tmp/agentzeroPantheon/
```

- [ ] **Step 2.2: Create planning directory tree**

```bash
mkdir -p /c/projects/Pantheon/pantheon/.planning/phases
mkdir -p /c/projects/Pantheon/pantheon/.planning/archive
```

- [ ] **Step 2.3: Copy CLAUDE.md to repo root**

```bash
cp /tmp/agentzeroPantheon/CLAUDE.md /c/projects/Pantheon/CLAUDE.md
```

- [ ] **Step 2.4: Copy STATE.md**

```bash
cp /tmp/agentzeroPantheon/STATE.md /c/projects/Pantheon/pantheon/.planning/STATE.md
```

- [ ] **Step 2.5: Copy phase files from zip**

```bash
cp /tmp/agentzeroPantheon/PHASE_0.md /c/projects/Pantheon/pantheon/.planning/phases/PHASE_0.md
cp /tmp/agentzeroPantheon/PHASE_1.md /c/projects/Pantheon/pantheon/.planning/phases/PHASE_1.md
cp /tmp/agentzeroPantheon/PHASE_2.md /c/projects/Pantheon/pantheon/.planning/phases/PHASE_2.md
```

- [ ] **Step 2.6: Create stub phase files (PHASE_3 through PHASE_9)**

```bash
for n in 3 4 5 6 7 8 9; do
  cat > /c/projects/Pantheon/pantheon/.planning/phases/PHASE_${n}.md << EOF
# PHASE ${n} — Not Yet Written
> Content added when Phase $((n-1)) is complete.
EOF
done
```

- [ ] **Step 2.7: Create APPENDICES.md stub**

```bash
cat > /c/projects/Pantheon/pantheon/.planning/phases/APPENDICES.md << 'EOF'
# APPENDICES — Not Yet Written
> FREE_CHAT test definition, Git workflow reference, backlog format.
> Content added during Phase 0.
EOF
```

- [ ] **Step 2.8: Create HANDOFF.md from template**

```bash
cat > /c/projects/Pantheon/pantheon/.planning/HANDOFF.md << 'EOF'
# HANDOFF — 2026-04-27

## Current Phase
Phase 0 — Environment & Tooling Setup

## Completed This Session
- Agent Zero fork cloned to /c/projects/Pantheon
- Pantheon directory structure installed under pantheon/
- Planning docs installed (CLAUDE.md, STATE.md, PHASE_0-2.md)
- Existing modules migrated (harness, sanctuary, vault, tests)
- New stubs created (graph, mnemosyne, iris, charon, session, harness.py, redistill_queue)
- .gitignore updated, docker-compose.yml stub created

## In Progress (CRITICAL)
- None

## Decisions Made
- Approach: Option A — clone fresh, layer Pantheon on top of Agent Zero fork
- Old Pantheon repo archived at /c/projects/Pantheon-old

## Blockers or Questions
- Agent Zero boot status: not yet verified (Phase 0 Step 0.2)
- GLM-5.1 fallback status: not yet tested (Phase 0 Step 0.1)
- Web UI port: not yet chosen (Phase 0 Step 0.2.6)
- Git remote URL confirmed: https://github.com/Duskript/agent-zero

## Next Step (one sentence, specific)
Begin Phase 0 Step 0.1 — ask user about GLM-5.1 fallback test status.

## Stub Status
- pantheon/pantheon-core/gods/demeter.py: not yet created (Phase 3)
- pantheon/pantheon-core/gods/hades.py: not yet created (Phase 6)
- pantheon/pantheon-core/gods/zeus.py: not yet created (Phase 8)
- pantheon/pantheon-core/gods/registry.py: not yet created (Phase 8)
- pantheon/pantheon-core/graph/client.py: stub
- pantheon/pantheon-core/graph/schema.py: stub
- pantheon/pantheon-core/mnemosyne/client.py: stub
- pantheon/pantheon-core/mnemosyne/agent_zero_adapter.py: stub
- pantheon/pantheon-core/session.py: stub
- pantheon/pantheon-core/harness.py: stub
- pantheon/pantheon-core/iris.py: stub
- pantheon/pantheon-core/charon.py: stub
- pantheon/pantheon-core/redistill_queue.py: stub

## GitNexus Index
Last analyzed: not yet run
Needs re-analyze before next session: yes

## Git State at Session End
Remote: https://github.com/Duskript/agent-zero
Branch: main
Last commit pushed: initial setup commit (see Task 10)
Uncommitted work remaining: no

## Agent Zero FREE_CHAT Status
Tested this session: not applicable
EOF
```

- [ ] **Step 2.9: Create remaining stub planning docs**

```bash
cat > /c/projects/Pantheon/pantheon/.planning/BACKLOG.md << 'EOF'
# BACKLOG — Known Gaps and Future Work
> Populated as phases surface gaps. Not yet written.
EOF

cat > /c/projects/Pantheon/pantheon/.planning/GRAPH_LAYER.md << 'EOF'
# GRAPH_LAYER — GraphClient Architecture Spec
> Read in Phase 4. Not yet written.
EOF

cat > /c/projects/Pantheon/pantheon/.planning/GENEALOGY.md << 'EOF'
# GENEALOGY — Project Lineage Reference
> Tracks fork history and key architectural decisions. Not yet written.
EOF

cat > /c/projects/Pantheon/pantheon/.planning/AGENT_ZERO_DEP_MAP.md << 'EOF'
# AGENT_ZERO_DEP_MAP — Agent Zero Dependency Map
> Built in Phase 1. Critical from Phase 7 onward. Not yet written.
EOF
```

- [ ] **Step 2.10: Verify planning structure**

```bash
find /c/projects/Pantheon/pantheon/.planning -type f | sort
```
Expected: 14+ files including CLAUDE.md at repo root, STATE.md, HANDOFF.md, BACKLOG.md, GRAPH_LAYER.md, GENEALOGY.md, AGENT_ZERO_DEP_MAP.md, all phase files, APPENDICES.md, and the archive dir.

---

## Task 3: Archive old planning docs

**Files:**
- Source: `/c/projects/Pantheon-old/.planning/` (12 docs)
- Dest: `/c/projects/Pantheon/pantheon/.planning/archive/`

- [ ] **Step 3.1: Copy all old planning docs to archive**

```bash
cp /c/projects/Pantheon-old/.planning/*.md /c/projects/Pantheon/pantheon/.planning/archive/
```

- [ ] **Step 3.2: Copy archive subdirectory if present**

```bash
ls /c/projects/Pantheon-old/.planning/archive/ 2>/dev/null && \
  cp -r /c/projects/Pantheon-old/.planning/archive /c/projects/Pantheon/pantheon/.planning/archive/old-archive || \
  echo "No archive subdir — skipping"
```

- [ ] **Step 3.3: Verify archive**

```bash
ls /c/projects/Pantheon/pantheon/.planning/archive/
```
Expected: ARCHITECTURE.md, COMMS.md, KNOWLEDGE.md, MIGRATION.md, NAVIGATION.md, PROJECT.md, ROADMAP.md, RULES.md, SANCTUARY.md, STACK.md, STATE.md, WORKFLOWS.md (12 files minimum).

---

## Task 4: Migrate existing pantheon-core modules

**Files:**
- Source: `/c/projects/Pantheon-old/pantheon-core/`
- Dest: `/c/projects/Pantheon/pantheon/pantheon-core/`

- [ ] **Step 4.1: Create pantheon-core directory**

```bash
mkdir -p /c/projects/Pantheon/pantheon/pantheon-core
```

- [ ] **Step 4.2: Copy all existing modules**

```bash
cp -r /c/projects/Pantheon-old/pantheon-core/harness /c/projects/Pantheon/pantheon/pantheon-core/harness
cp -r /c/projects/Pantheon-old/pantheon-core/sanctuary /c/projects/Pantheon/pantheon/pantheon-core/sanctuary
cp -r /c/projects/Pantheon-old/pantheon-core/vault /c/projects/Pantheon/pantheon/pantheon-core/vault
cp -r /c/projects/Pantheon-old/pantheon-core/gods /c/projects/Pantheon/pantheon/pantheon-core/gods
cp -r /c/projects/Pantheon-old/pantheon-core/routing /c/projects/Pantheon/pantheon/pantheon-core/routing
cp -r /c/projects/Pantheon-old/pantheon-core/tests /c/projects/Pantheon/pantheon/pantheon-core/tests
cp /c/projects/Pantheon-old/pantheon-core/requirements.txt /c/projects/Pantheon/pantheon/pantheon-core/requirements.txt
```

- [ ] **Step 4.3: Create pantheon-core __init__.py**

```bash
echo "# Pantheon Core — main package" > /c/projects/Pantheon/pantheon/pantheon-core/__init__.py
```

- [ ] **Step 4.4: Verify migrated files**

```bash
find /c/projects/Pantheon/pantheon/pantheon-core -type f | sort
```
Expected: all harness, sanctuary, vault, gods, routing, and tests files present.

---

## Task 5: Create new stub modules

**Files:**
- Create: `pantheon/pantheon-core/graph/` (3 stubs)
- Create: `pantheon/pantheon-core/mnemosyne/` (2 stubs)
- Create: 5 root-level stubs (iris, charon, session, harness, redistill_queue)

- [ ] **Step 5.1: Create graph module stubs**

```bash
mkdir -p /c/projects/Pantheon/pantheon/pantheon-core/graph

echo "# GraphClient package — implemented in Phase 4" > /c/projects/Pantheon/pantheon/pantheon-core/graph/__init__.py

cat > /c/projects/Pantheon/pantheon/pantheon-core/graph/client.py << 'EOF'
# GraphClient — SQLite relationship graph
# Stub — implemented in Phase 4 (GraphClient & Entity Extraction)


class GraphClient:
    pass
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/graph/schema.py << 'EOF'
# Graph schema definitions
# Stub — implemented in Phase 4
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/graph/exceptions.py << 'EOF'
# Graph layer exceptions
# Stub — implemented in Phase 4
EOF
```

- [ ] **Step 5.2: Create mnemosyne module stubs**

```bash
mkdir -p /c/projects/Pantheon/pantheon/pantheon-core/mnemosyne

echo "# Mnemosyne package — ChromaDB vector store adapter, implemented in Phase 5" > /c/projects/Pantheon/pantheon/pantheon-core/mnemosyne/__init__.py

cat > /c/projects/Pantheon/pantheon/pantheon-core/mnemosyne/client.py << 'EOF'
# Mnemosyne — ChromaDB vector store client
# Stub — implemented in Phase 5


class MnemosyneClient:
    pass
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/mnemosyne/agent_zero_adapter.py << 'EOF'
# Agent Zero memory interface adapter for Mnemosyne
# Stub — implemented in Phase 7 (Agent Zero Memory Swap)
EOF
```

- [ ] **Step 5.3: Create root-level stubs**

```bash
cat > /c/projects/Pantheon/pantheon/pantheon-core/iris.py << 'EOF'
# Iris — flagging system
# Stub — implemented in Phase 2
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/charon.py << 'EOF'
# Charon — session ferry / context bridge
# Stub — implemented in Phase 2
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/session.py << 'EOF'
# Pantheon session model
# Stub — implemented in Phase 2
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/harness.py << 'EOF'
# Pantheon harness runtime (not to be confused with the harness/ loader module)
# Stub — implemented in Phase 2
EOF

cat > /c/projects/Pantheon/pantheon/pantheon-core/redistill_queue.py << 'EOF'
# RedistillQueue — re-embedding queue for updated knowledge nodes
# Stub — implemented in Phase 5
EOF
```

- [ ] **Step 5.4: Verify stub files**

```bash
find /c/projects/Pantheon/pantheon/pantheon-core/graph /c/projects/Pantheon/pantheon/pantheon-core/mnemosyne -type f | sort
ls /c/projects/Pantheon/pantheon/pantheon-core/*.py
```
Expected: 4 graph files, 3 mnemosyne files, 5 root stubs.

---

## Task 6: Create placeholder directories and god stubs

**Files:**
- Create: `pantheon/gods/zeus/`, `pantheon/gods/hephaestus/`
- Create: `pantheon/gods-private/`, `pantheon/skills/`, `pantheon/flags/`, `pantheon/.athenaeum/`, `pantheon/harnesses/`
- Copy: `Athenaeum.scaffold/`, `scripts/`, `docs/superpowers/`

- [ ] **Step 6.1: Create god stub directories**

```bash
mkdir -p /c/projects/Pantheon/pantheon/gods/zeus
mkdir -p /c/projects/Pantheon/pantheon/gods/hephaestus
```

- [ ] **Step 6.2: Write Zeus stubs**

```bash
cat > /c/projects/Pantheon/pantheon/gods/zeus/god.yaml << 'EOF'
# Zeus — Orchestrator God
# Stub — filled in Phase 8 (Zeus & God Registry)
schema_version: 1
name: zeus
domain: orchestration
description: Primary orchestrator. Routes requests to domain Gods.
EOF

cat > /c/projects/Pantheon/pantheon/gods/zeus/harness.yaml << 'EOF'
# Zeus harness
# Stub — filled in Phase 8
schema_version: 1
name: zeus
driver: llm
EOF
```

- [ ] **Step 6.3: Write Hephaestus stubs**

```bash
cat > /c/projects/Pantheon/pantheon/gods/hephaestus/god.yaml << 'EOF'
# Hephaestus — Builder God
# Stub — filled in Phase 8
schema_version: 1
name: hephaestus
domain: engineering
description: Software engineering and tooling domain agent.
EOF

cat > /c/projects/Pantheon/pantheon/gods/hephaestus/harness.yaml << 'EOF'
# Hephaestus harness
# Stub — filled in Phase 8
schema_version: 1
name: hephaestus
driver: llm
EOF
```

- [ ] **Step 6.4: Create .gitkeep placeholder directories**

```bash
mkdir -p /c/projects/Pantheon/pantheon/gods-private && touch /c/projects/Pantheon/pantheon/gods-private/.gitkeep
mkdir -p /c/projects/Pantheon/pantheon/skills && touch /c/projects/Pantheon/pantheon/skills/.gitkeep
mkdir -p /c/projects/Pantheon/pantheon/flags && touch /c/projects/Pantheon/pantheon/flags/.gitkeep
mkdir -p /c/projects/Pantheon/pantheon/.athenaeum && touch /c/projects/Pantheon/pantheon/.athenaeum/.gitkeep
mkdir -p /c/projects/Pantheon/pantheon/harnesses && touch /c/projects/Pantheon/pantheon/harnesses/.gitkeep
```

- [ ] **Step 6.5: Copy Athenaeum.scaffold**

```bash
cp -r /c/projects/Pantheon-old/Athenaeum.scaffold /c/projects/Pantheon/pantheon/Athenaeum.scaffold
```

- [ ] **Step 6.6: Copy scripts**

```bash
cp -r /c/projects/Pantheon-old/scripts /c/projects/Pantheon/pantheon/scripts
```

- [ ] **Step 6.7: Copy docs/superpowers (including this plan)**

```bash
mkdir -p /c/projects/Pantheon/pantheon/docs
cp -r /c/projects/Pantheon-old/docs/superpowers /c/projects/Pantheon/pantheon/docs/superpowers
```

- [ ] **Step 6.8: Verify structure**

```bash
ls /c/projects/Pantheon/pantheon/
```
Expected: `.athenaeum`, `.planning`, `Athenaeum.scaffold`, `docs`, `flags`, `gods`, `gods-private`, `harnesses`, `pantheon-core`, `scripts`, `skills`.

---

## Task 7: Update .gitignore and create docker-compose stub

**Files:**
- Modify: `/c/projects/Pantheon/.gitignore`
- Create: `/c/projects/Pantheon/docker-compose.yml`

- [ ] **Step 7.1: Append Pantheon entries to Agent Zero's .gitignore**

```bash
cat >> /c/projects/Pantheon/.gitignore << 'EOF'

# ── Pantheon ──────────────────────────────────────────────────────────────────

# Pantheon runtime data — never commit
pantheon/.athenaeum/.chromadb/
pantheon/.athenaeum/*.db
pantheon/.athenaeum/*.db-shm
pantheon/.athenaeum/*.db-wal
pantheon/.athenaeum/.state.json
pantheon/.athenaeum/.hades.lock

# Private Gods — never commit
pantheon/gods-private/*
!pantheon/gods-private/.gitkeep

# Iris flags (runtime)
pantheon/flags/*.md
!pantheon/flags/.gitkeep

# GitNexus artifacts
gitnexus_analyze.log
.gitnexus/
EOF
```

- [ ] **Step 7.2: Verify .gitignore appended correctly**

```bash
tail -25 /c/projects/Pantheon/.gitignore
```
Expected: Pantheon section visible at end of file.

- [ ] **Step 7.3: Create docker-compose.yml stub**

```bash
cat > /c/projects/Pantheon/docker-compose.yml << 'EOF'
# Pantheon docker-compose.yml
# DO NOT extend or modify Agent Zero's docker configuration here.
# Port and volume mounts are set interactively in Phase 0 Step 0.2.6.
#
# TODO (Phase 0, Step 0.2.6): replace TODO_PORT with chosen port and confirm volumes
services:
  pantheon:
    build: .
    ports:
      - "TODO_PORT:80"
    volumes:
      - ./pantheon/.athenaeum:/app/pantheon/.athenaeum
      - ./pantheon/.planning:/app/pantheon/.planning
      - ./pantheon/flags:/app/pantheon/flags
    environment:
      - OLLAMA_HOST=http://host.docker.internal:11434
    extra_hosts:
      - "host.docker.internal:host-gateway"
    restart: unless-stopped
EOF
```

---

## Task 8: Verify tests still pass

**Files:**
- Run: `pantheon/pantheon-core/tests/`

- [ ] **Step 8.1: Install pantheon-core dependencies**

```bash
cd /c/projects/Pantheon/pantheon/pantheon-core && pip install -r requirements.txt
```

- [ ] **Step 8.2: Run test suite**

```bash
cd /c/projects/Pantheon/pantheon/pantheon-core && python -m pytest tests/ -v
```

Expected output:
```
test_api.py - varies
test_sanctuary_config.py - 8 PASSED
test_vault_writer.py - 8 PASSED
test_harness_loader.py - 5 SKIPPED (needs harness YAML fixtures — expected, unchanged from before migration)

16 passed, 5 skipped
```

If any previously passing test now fails, investigate before committing. The migration must not break existing tests.

---

## Task 9: Create dev branch and initial commit

**Files:**
- All files created in Tasks 2–7

- [ ] **Step 9.1: Create dev branch**

```bash
cd /c/projects/Pantheon && git checkout -b dev
```

- [ ] **Step 9.2: Stage Pantheon files only**

```bash
cd /c/projects/Pantheon && git add CLAUDE.md pantheon/ docker-compose.yml .gitignore
```

- [ ] **Step 9.3: Confirm what will be committed**

```bash
cd /c/projects/Pantheon && git status
```

Verify: only Pantheon files appear. No Agent Zero source files appear as modified (they should be unchanged from the clone). If any Agent Zero files appear as modified, stop and investigate before committing.

- [ ] **Step 9.4: Commit**

```bash
cd /c/projects/Pantheon && git commit -m "[Phase 0 setup] Install Pantheon layer on Agent Zero fork"
```

- [ ] **Step 9.5: Verify commit**

```bash
cd /c/projects/Pantheon && git log --oneline -3
```
Expected: new commit at top, Agent Zero history below.

- [ ] **Step 9.6: Push dev branch**

```bash
cd /c/projects/Pantheon && git push origin dev
```

- [ ] **Step 9.7: Final state check**

```bash
ls /c/projects/Pantheon/pantheon/
ls /c/projects/Pantheon/pantheon/pantheon-core/
ls /c/projects/Pantheon/pantheon/.planning/phases/
```

All three should show complete directory contents matching the File Map at the top of this plan.

---

## End State

- `/c/projects/Pantheon` = Agent Zero fork on `dev` branch with Pantheon layer committed
- `/c/projects/Pantheon-old` = archived original repo (safe to delete once Phase 0 is stable)
- 16 passing tests, 5 skipped (unchanged from before migration)
- CLAUDE.md, STATE.md, HANDOFF.md, and PHASE_0-2.md installed and ready
- All stub files indexable by GitNexus in Phase 0 Step 0.4
- Ready for Phase 0 Step 0.1: GLM-5.1 fallback test
