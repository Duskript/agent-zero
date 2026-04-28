# Design: Agent Zero Pantheon Migration Setup
**Date:** 2026-04-27  
**Status:** Approved  
**Scope:** Migrate existing Pantheon repo to Agent Zero fork base and install new planning structure, leaving the project ready for Phase 0 execution.

---

## Context

Pantheon is pivoting from a from-scratch Open WebUI-based runtime to a fork of Agent Zero. The new direction replaces Agent Zero's memory system with Pantheon's custom knowledge graph, vector store, and multi-domain agent architecture. The mythology naming conventions, Gods/Harness model, Athenaeum, and Sanctuary concepts all survive — only the runtime base changes.

The existing Pantheon repo (v0.1.0, Phase 1 in progress) has three working Python modules and a complete planning document set. These are preserved where compatible with the new direction.

---

## Instance Separation

Three tiers exist and must never be mixed:
- **Personal Instance** — private, contains real Athenaeum + Apollo. Never published.
- **Dev Instance** — THIS setup's build target. Dummy/test data only. No Apollo.
- **Pantheon Core Release** — future published version, built from dev branch when stable.

---

## Section 1 — Repository Surgery

1. Rename `/c/projects/Pantheon` → `/c/projects/Pantheon-old` (safety net, not deleted)
2. Clone `https://github.com/Duskript/agent-zero` → `/c/projects/Pantheon`
3. Verify Agent Zero boots (`python main.py`) before any further steps

Agent Zero's existing `.gitignore`, `docker-compose.yml`, and all source files remain untouched at this stage. Pantheon code lives entirely within a `pantheon/` subdirectory.

---

## Section 2 — Planning Structure

New files installed at:

```
/c/projects/Pantheon/
  CLAUDE.md                              ← from agentzeroPantheon.zip
  pantheon/
    .planning/
      STATE.md                           ← from zip (Phase 0 not started)
      HANDOFF.md                         ← empty template
      BACKLOG.md                         ← empty stub
      GRAPH_LAYER.md                     ← empty stub
      GENEALOGY.md                       ← empty stub
      AGENT_ZERO_DEP_MAP.md              ← empty stub (built in Phase 1)
      phases/
        PHASE_0.md                       ← from zip
        PHASE_1.md                       ← from zip
        PHASE_2.md                       ← from zip
        PHASE_3.md → PHASE_9.md          ← empty stubs
        APPENDICES.md                    ← empty stub
    archive/                             ← old .planning/ docs from Pantheon-old
```

Old `.planning/` docs (12 files) from Pantheon-old move to `pantheon/.planning/archive/`. Nothing is deleted.

---

## Section 3 — Code Migration

Preserved modules from `Pantheon-old` move into `pantheon/`:

### Kept as-is
| Source (Pantheon-old) | Destination |
|---|---|
| `pantheon-core/harness/` | `pantheon/pantheon-core/harness/` |
| `pantheon-core/sanctuary/` | `pantheon/pantheon-core/sanctuary/` |
| `pantheon-core/vault/` | `pantheon/pantheon-core/vault/` |
| `pantheon-core/gods/__init__.py` | `pantheon/pantheon-core/gods/__init__.py` |
| `pantheon-core/routing/__init__.py` | `pantheon/pantheon-core/routing/__init__.py` |
| `pantheon-core/tests/` | `pantheon/pantheon-core/tests/` |
| `pantheon-core/requirements.txt` | `pantheon/pantheon-core/requirements.txt` |
| `Athenaeum.scaffold/` | `pantheon/Athenaeum.scaffold/` |
| `scripts/` | `pantheon/scripts/` |
| `docs/superpowers/` | `pantheon/docs/superpowers/` |

### New stubs (empty, indexable by GitNexus in Phase 1)
```
pantheon/pantheon-core/
  graph/
    __init__.py
    client.py         ← stub
    schema.py         ← stub
    exceptions.py     ← stub
  mnemosyne/
    __init__.py
    client.py         ← stub
    agent_zero_adapter.py  ← stub
  iris.py             ← stub
  charon.py           ← stub
  session.py          ← stub
  harness.py          ← stub
  redistill_queue.py  ← stub
```

### New placeholder directories
```
pantheon/
  gods/
    zeus/             ← god.yaml + harness.yaml stubs
    hephaestus/       ← god.yaml + harness.yaml stubs
  gods-private/       ← .gitkeep
  skills/             ← .gitkeep
  flags/              ← .gitkeep
  .athenaeum/         ← .gitkeep
  harnesses/          ← .gitkeep
```

---

## Section 4 — .gitignore & Docker

### .gitignore
Append to Agent Zero's existing `.gitignore` (never overwrite):

```gitignore
# Pantheon runtime data — never commit
pantheon/.athenaeum/.chromadb/
pantheon/.athenaeum/*.db
pantheon/.athenaeum/*.db-shm
pantheon/.athenaeum/*.db-wal
pantheon/.athenaeum/.state.json
pantheon/.athenaeum/.hades.lock

# Private Gods — never commit
pantheon/gods-private/
!pantheon/gods-private/.gitkeep

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

### docker-compose.yml
A Pantheon-owned `docker-compose.yml` at repo root — stub only, port TBD in Phase 0 Step 0.2.6. Never extends Agent Zero's Docker config.

---

## End State

After this setup is complete:
- `/c/projects/Pantheon` = clean Agent Zero fork with Pantheon code layered in `pantheon/`
- `/c/projects/Pantheon-old` = archived original repo (can be deleted once Phase 0 is stable)
- All existing tests still pass (16 passing, 5 skipped pending YAML fixtures — unchanged)
- New CLAUDE.md and phase files installed, ready for Phase 0 Step 0.1
- No Agent Zero files have been touched

---

## What This Does NOT Do

- Does not execute any Phase 0 steps (that is interactive, user-driven)
- Does not write HANDOFF.md content (Phase 0 Step 0.6)
- Does not set Agent Zero to boot or fix any errors
- Does not write harness YAML files (Phase 1+)
- Does not install GitNexus (Phase 0 Step 0.3)
