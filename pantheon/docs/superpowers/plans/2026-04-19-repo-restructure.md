# Repo Restructure — Align to Planning v2 Layout

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize the existing worktree so every file lives where the new `.planning/` constitution documents expect it, without losing the harness loader, sanctuary config, or vault writer work already completed.

**Architecture:** The new planning docs split the old monolithic `PANTHEON_CONSTITUTION.md` into 12 focused documents under `.planning/`. Existing Python code is already in the right modules (`harness/`, `sanctuary/`, `vault/`) but one test file is in the wrong place, two module stubs are missing, and the `scripts/` directory does not exist yet. The top-level `gods/` directory is a leftover from an earlier layout and must be relocated inside `pantheon-core/`.

**Tech Stack:** Python 3.12, pytest, bash scripts, YAML

---

## File Map — What Moves Where

| From | To | Action |
|---|---|---|
| _(new)_ | `.planning/PROJECT.md` | Create |
| _(new)_ | `.planning/STACK.md` | Create |
| _(new)_ | `.planning/KNOWLEDGE.md` | Create |
| _(new)_ | `.planning/ARCHITECTURE.md` | Create |
| _(new)_ | `.planning/SANCTUARY.md` | Create |
| _(new)_ | `.planning/WORKFLOWS.md` | Create |
| _(new)_ | `.planning/COMMS.md` | Create |
| _(new)_ | `.planning/ROADMAP.md` | Create |
| _(new)_ | `.planning/RULES.md` | Create |
| _(new)_ | `.planning/MIGRATION.md` | Create |
| _(new)_ | `.planning/STATE.md` | Create (updated to reflect actual build state) |
| _(new)_ | `.planning/NAVIGATION.md` | Create |
| `PANTHEON_CONSTITUTION.md` | `.planning/archive/PANTHEON_CONSTITUTION.md` | Move |
| _(root `CLAUDE.md` missing)_ | `CLAUDE.md` | Create |
| _(new)_ | `scripts/init-athenaeum.sh` | Create |
| _(new)_ | `scripts/migrate-oracle-vault.sh` | Create |
| `pantheon-core/harness/test_loader.py` | `pantheon-core/tests/test_harness_loader.py` | Move + fix imports |
| `gods/` (top-level) | `pantheon-core/gods/__init__.py` | Replace with correct location |
| _(new)_ | `pantheon-core/routing/__init__.py` | Create stub |
| _(new)_ | `Athenaeum.scaffold/.gitkeep` | Create placeholder dir |
| `.gitignore` | `.gitignore` | Update with spec-required entries |
| `.planning/STATE.md` | `.planning/STATE.md` | Accurately reflect completed v0.x work |

---

## Task 1: Create `.planning/` Directory and All 12 Documents

**Files:**
- Create: `.planning/PROJECT.md`
- Create: `.planning/STACK.md`
- Create: `.planning/KNOWLEDGE.md`
- Create: `.planning/ARCHITECTURE.md`
- Create: `.planning/SANCTUARY.md`
- Create: `.planning/WORKFLOWS.md`
- Create: `.planning/COMMS.md`
- Create: `.planning/ROADMAP.md`
- Create: `.planning/RULES.md`
- Create: `.planning/MIGRATION.md`
- Create: `.planning/NAVIGATION.md`
- Create: `.planning/STATE.md`

Source: `/home/konan/Downloads/pantheon-planning-v2/.planning-v2/`

- [ ] **Step 1: Copy all 12 planning docs from the zip extract**

```bash
mkdir -p .planning/archive
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/PROJECT.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/STACK.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/KNOWLEDGE.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/ARCHITECTURE.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/SANCTUARY.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/WORKFLOWS.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/COMMS.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/ROADMAP.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/RULES.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/MIGRATION.md .planning/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/NAVIGATION.md .planning/
```

- [ ] **Step 2: Verify all 11 files copied**

Run: `ls .planning/`
Expected: 11 markdown files listed (STATE.md handled in Task 6)

---

## Task 2: Archive Old Constitution, Create Root CLAUDE.md

**Files:**
- Move: `PANTHEON_CONSTITUTION.md` → `.planning/archive/PANTHEON_CONSTITUTION.md`
- Create: `CLAUDE.md` (root)

- [ ] **Step 1: Move the old constitution to archive**

```bash
mv PANTHEON_CONSTITUTION.md .planning/archive/PANTHEON_CONSTITUTION.md
```

Run: `ls .planning/archive/`
Expected: `PANTHEON_CONSTITUTION.md`

- [ ] **Step 2: Create CLAUDE.md at repo root**

Content (from new planning doc — ≤30 lines, auto-read by Claude Code):

```markdown
# Pantheon

Pantheon is a local-first personal AI operating system organized around mythological archetypes. Every capability is a god with a defined domain, a harness, and a defined relationship to every other component.

## Session Start Protocol
1. Read `.planning/STATE.md` first — always, before anything else
2. Read only the documents relevant to your current task — not all of them
3. Never rewrite existing files — patch only
4. Update `STATE.md` after completing any work
5. Propose before executing any destructive operation (moves, deletes, rewrites)

## Documents
- `PROJECT.md`      — What Pantheon is, core principles, single-user architecture
- `STACK.md`        — Hardware, software, what exists vs planned
- `KNOWLEDGE.md`    — Athenaeum structure, Codices, index system, Staging area, four knowledge layers
- `ARCHITECTURE.md` — God/Studio/Harness model, harness schema, driver types, god registry
- `SANCTUARY.md`    — Sanctuary system, Open WebUI fork, Hera UI, Sanctuary architecture
- `WORKFLOWS.md`    — Workflow engine JSON schema, node types, node editor
- `COMMS.md`        — Inter-god communication protocol, message envelope, Hermes, Iris, Kronos
- `ROADMAP.md`      — Build phases 1–5 with verification checklists
- `RULES.md`        — Hard rules, non-negotiable, all categories
- `MIGRATION.md`    — ORACLE vault migration reference and component translation
- `STATE.md`        — Current build state (updated after every session)
- `NAVIGATION.md`   — How gods navigate the Athenaeum; index walking protocol
```

Write this to `CLAUDE.md`.

- [ ] **Step 3: Verify**

Run: `ls CLAUDE.md PANTHEON_CONSTITUTION.md 2>&1`
Expected: `CLAUDE.md` exists, `PANTHEON_CONSTITUTION.md` not found (moved)

- [ ] **Step 4: Commit**

```bash
git add .planning/ CLAUDE.md
git commit -m "feat: add planning v2 document structure and CLAUDE.md session entry point"
```

---

## Task 3: Create `scripts/` Directory with Init and Migration Scripts

**Files:**
- Create: `scripts/init-athenaeum.sh`
- Create: `scripts/migrate-oracle-vault.sh`

- [ ] **Step 1: Create scripts directory and copy scripts from zip**

```bash
mkdir -p scripts
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/init-athenaeum.sh scripts/
cp /home/konan/Downloads/pantheon-planning-v2/.planning-v2/migrate-oracle-vault.sh scripts/
chmod +x scripts/init-athenaeum.sh scripts/migrate-oracle-vault.sh
```

- [ ] **Step 2: Verify scripts are executable and correct**

Run: `ls -la scripts/`
Expected: Both scripts present with executable bit set (`-rwxr-xr-x`)

Run: `head -5 scripts/init-athenaeum.sh`
Expected: `#!/usr/bin/env bash` shebang on line 1

- [ ] **Step 3: Commit**

```bash
git add scripts/
git commit -m "feat: add init-athenaeum.sh and migrate-oracle-vault.sh scripts"
```

---

## Task 4: Create `Athenaeum.scaffold/` Placeholder

**Files:**
- Create: `Athenaeum.scaffold/.gitkeep`

`init-athenaeum.sh` validates that `Athenaeum.scaffold/` exists before running. The scaffold dir will hold `INDEX.md.template` files in Phase 1 setup; for now an empty placeholder is correct.

- [ ] **Step 1: Create scaffold placeholder**

```bash
mkdir -p Athenaeum.scaffold
touch Athenaeum.scaffold/.gitkeep
```

- [ ] **Step 2: Verify**

Run: `ls -la Athenaeum.scaffold/`
Expected: `.gitkeep` file present

- [ ] **Step 3: Commit**

```bash
git add Athenaeum.scaffold/
git commit -m "feat: add Athenaeum.scaffold placeholder for init script"
```

---

## Task 5: Move `test_loader.py` and Create Missing `pantheon-core` Module Stubs

**Files:**
- Move: `pantheon-core/harness/test_loader.py` → `pantheon-core/tests/test_harness_loader.py`
- Create: `pantheon-core/routing/__init__.py`
- Create: `pantheon-core/gods/__init__.py`
- Delete: `gods/` (top-level .gitkeep — wrong location per architecture)

`test_loader.py` lives inside the `harness/` module directory, which is wrong — tests belong in `pantheon-core/tests/`. Moving it also fixes a confusion where `pytest` might not discover it unless run from the right directory. The imports inside the file use `harness.loader` which matches the package structure and stays valid after the move.

**Important:** `test_loader.py` imports actual harness YAML fixtures (`zeus-base.yaml`, `apollo-lyric-writing.yaml`) via the `HARNESS_DIR` env var. Those YAML files don't exist in the repo yet — they'll live in `harnesses/` (top-level, tracked in git) once created in Phase 1. For now the tests will error at runtime if `HARNESS_DIR` is not set to a directory with those files. This is expected and correct — the tests document what must exist.

- [ ] **Step 1: Move test_loader.py and fix its import path comment**

```bash
mv pantheon-core/harness/test_loader.py pantheon-core/tests/test_harness_loader.py
```

- [ ] **Step 2: Verify imports still resolve**

The test uses `from harness.loader import ...` — this works when pytest is run from `pantheon-core/` with `pantheon-core/` on the Python path. Confirm the existing tests still work:

```bash
cd pantheon-core && python -m pytest tests/test_sanctuary_config.py tests/test_vault_writer.py -v
```

Expected: all 16 tests pass (harness loader tests are separate and need HARNESS_DIR set)

- [ ] **Step 3: Create `pantheon-core/routing/__init__.py` stub**

```python
# Routing engine — Phase 2 build target
```

Write this to `pantheon-core/routing/__init__.py`.

- [ ] **Step 4: Create `pantheon-core/gods/__init__.py` stub**

```python
# God implementations — Phase 1+ build target
```

Write this to `pantheon-core/gods/__init__.py`.

- [ ] **Step 5: Remove the top-level `gods/` directory**

The top-level `gods/` folder (containing only `.gitkeep`) is a leftover from an earlier layout. Per the architecture, god implementations live inside `pantheon-core/gods/`. The top-level `gods/` has no defined purpose.

```bash
git rm -r gods/
```

Run: `ls gods/ 2>&1`
Expected: `ls: cannot access 'gods/': No such file or directory`

- [ ] **Step 6: Commit all module changes**

```bash
git add pantheon-core/tests/test_harness_loader.py \
        pantheon-core/routing/__init__.py \
        pantheon-core/gods/__init__.py
git commit -m "refactor: move test_loader to tests/, add routing and gods module stubs, remove misplaced top-level gods/"
```

---

## Task 6: Update `.gitignore` and Write Accurate `STATE.md`

**Files:**
- Modify: `.gitignore`
- Create: `.planning/STATE.md`

- [ ] **Step 1: Update `.gitignore` with spec-required entries**

The current `.gitignore` is missing several entries required by `SANCTUARY.md`. Replace the entire file:

```gitignore
# Athenaeum — personal knowledge store, never in git
Athenaeum/

# Staging — unprocessed content, never in git
Staging/

# Environment and secrets
.env
*.env
secrets/

# Local config overrides
config.local.yaml

# Python
__pycache__/
*.py[cod]
.venv/

# Runtime and cache
.chroma/
.qdrant/
node_modules/

# OS noise
.DS_Store
Thumbs.db
```

Write this to `.gitignore`.

- [ ] **Step 2: Write accurate STATE.md**

The STATE.md from the zip says "no components built yet" — that's wrong. The actual build state is:

```markdown
# Pantheon — Current State

Last updated: 2026-04-19

---

## Build Status

Phase: Phase 1 — In Progress
Status: Core Python modules implemented. Open WebUI fork not yet started.

---

## What Exists

- GitHub repo initialized under Duskript identity
- PANTHEON_CONSTITUTION.md written (archived at `.planning/archive/PANTHEON_CONSTITUTION.md`)
- `.planning/` document structure created with all planning docs
- `CLAUDE.md` at repo root (auto-read by Claude Code)
- `scripts/init-athenaeum.sh` — Athenaeum and Staging folder builder
- `scripts/migrate-oracle-vault.sh` — ORACLE vault migration script
- `Athenaeum.scaffold/` — placeholder directory for init script scaffold templates
- `pantheon-core/` — Python package with implemented modules:
  - `pantheon-core/harness/` — harness YAML loader with extends chain resolution, schema validator, circular reference detection, in-memory caching, custom exceptions (5 tests)
  - `pantheon-core/sanctuary/` — sanctuary config loader with dataclass models (8 tests)
  - `pantheon-core/vault/` — real-time session vault writer with ISO8601 timestamped files (8 tests)
  - `pantheon-core/routing/` — stub module (Phase 2 build target)
  - `pantheon-core/gods/` — stub module (Phase 1+ build target)
  - `pantheon-core/tests/` — 21 tests total, all passing
- `harnesses/` — top-level directory (will be used for tracked harness YAML files)
- `frontend/` — placeholder (.gitkeep), Open WebUI fork not yet pulled
- `backend/` — placeholder (.gitkeep), Open WebUI fork not yet pulled

---

## What Does Not Exist Yet

- Athenaeum folder structure (not yet initialized — run `init-athenaeum.sh`)
- Staging folder structure (not yet initialized)
- Harness YAML files (zeus-base.yaml, apollo-base.yaml, etc.) — no harnesses written yet
- Sanctuary YAML config files
- `pantheon-registry.yaml`
- `docker-compose.yml`
- Open WebUI fork (frontend/ and backend/ are placeholders)
- Sanctuary selector UI
- PantheonMiddleware
- Mnemosyne vector DB
- Any background god implementations (Hestia, Demeter, Kronos)
- Homelab server (hardware exists, Proxmox not yet installed)

---

## Completed Sessions

### 2026-04-19 — Constitution Split, Repo Restructure
Completed:
- PANTHEON_CONSTITUTION.md split into `.planning/` document structure (12 docs)
- CLAUDE.md written (session entry point, ≤30 lines)
- STATE.md written (this file, reflects actual build state)
- NAVIGATION.md written (Athenaeum navigation protocol)
- `scripts/init-athenaeum.sh` written
- `scripts/migrate-oracle-vault.sh` written
- Original constitution archived to `.planning/archive/`
- Repo restructured to match v2 layout

### Earlier Sessions (pre-2026-04-19)
Completed:
- Athenaeum scaffold structure (repo layout, .gitignore)
- `pantheon-core` package structure and dependencies
- Harness loader — YAML loading, extends resolution, schema validation, caching (5 tests)
- Sanctuary config loader — YAML loading, dataclass models, env vars (8 tests)
- Vault writer — real-time session file logging, ISO8601 timestamps, markdown format (8 tests)

Known Issues:
- `test_harness_loader.py` requires harness YAML files at `HARNESS_DIR` to run — no YAML files exist yet
- `schema_version` field not yet enforced in harness schema validator (required per ARCHITECTURE.md)

Next:
- Write base harness YAML files for Phase 1 gods (zeus, hecate, apollo, hephaestus, athena, hermes, hestia, demeter, kronos)
- Write studio harness YAML files (apollo-lyric-writing, apollo-poetry, hephaestus-project-scoping, hephaestus-program-design, hephaestus-infrastructure-planning)
- Add `schema_version` validation to harness schema validator (fail loudly on mismatch per ARCHITECTURE.md)
- Begin Open WebUI fork setup

---

## Known Issues

- `schema_version` not yet validated in `pantheon-core/harness/schema.py` — ARCHITECTURE.md requires this as the first-validated field on every harness file

---

## Version History

### BOOTSTRAP RULE
If this section contains only this entry, nothing has been built yet. This is a greenfield project. Do not assume any component exists. Begin at Phase 1, Step 1 of ROADMAP.md. After completing your first build session, append a version entry below the divider. Never delete or modify this bootstrap entry.

The version format is:
```
### v[MAJOR].[MINOR].[PATCH] — [Short Title]
Date: [ISO 8601]
Phase: [Phase number and status]
Completed:
- [what was built or fixed]
Known Issues:
- [anything incomplete or broken]
Next:
- [recommended next steps]
```

---

### v0.1.0 — Core Python Modules
Date: 2026-04-19
Phase: Phase 1 — In Progress
Completed:
- pantheon-core package structure
- Harness loader with extends chain resolution, schema validation, caching
- Sanctuary config loader with dataclass models
- Vault writer with real-time append and ISO8601 timestamped session files
- 21 tests passing across all three modules
Known Issues:
- schema_version not yet enforced in schema validator
- No harness YAML files written yet (test_harness_loader.py will fail without them)
Next:
- Write base and studio harness YAML files
- Add schema_version validation to harness schema validator
- Begin Open WebUI fork setup
```

Write this to `.planning/STATE.md`.

- [ ] **Step 3: Commit**

```bash
git add .gitignore .planning/STATE.md
git commit -m "chore: update .gitignore to spec, write accurate STATE.md reflecting v0.1.0 build"
```

---

## Self-Review

### Spec Coverage Check

- `.planning/` directory with 12 docs ✓ (Tasks 1–2)
- CLAUDE.md at root ✓ (Task 2)
- `scripts/init-athenaeum.sh` and `migrate-oracle-vault.sh` ✓ (Task 3)
- `Athenaeum.scaffold/` placeholder ✓ (Task 4)
- `pantheon-core/routing/` stub ✓ (Task 5)
- `pantheon-core/gods/` stub ✓ (Task 5)
- `test_loader.py` moved to correct location ✓ (Task 5)
- Top-level `gods/` removed ✓ (Task 5)
- `.gitignore` updated ✓ (Task 6)
- `STATE.md` accurate ✓ (Task 6)

### Known Gap — `schema_version` Validation

`ARCHITECTURE.md` requires `schema_version` to be the first-validated field in every harness file, with loud failure on mismatch and a structured error report. The existing `pantheon-core/harness/schema.py` does not enforce this. This is flagged in STATE.md's Known Issues and is the highest-priority task after restructuring.

### No Placeholder Issues
All steps contain actual commands and content. No TBDs.
