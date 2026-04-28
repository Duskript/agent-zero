# CachyOS Dev Machine Setup
> Get from "Agent Zero running at home" to "ready to continue Phase 0 Step 0.3"

---

## Prerequisites (already done)
- Agent Zero is running on the CachyOS machine
- Docker is installed
- Git is installed

---

## Step 1 — Get the right fork and branch

If you cloned the Pantheon fork already:
```bash
cd [your-agent-zero-path]
git remote -v
```
Remote should show `https://github.com/Duskript/agent-zero`. If it shows the upstream Agent Zero instead, add the fork:
```bash
git remote set-url origin https://github.com/Duskript/agent-zero
```

Pull latest dev branch:
```bash
git fetch origin
git checkout dev
git pull origin dev
```

Confirm you're current:
```bash
git log --oneline -3
```
Expected top commit: `ed7c2920 [Phase 0.2.5/0.2.6] FAISS cleared, Pantheon port set to 50002`

---

## Step 2 — Verify Docker setup

```bash
docker --version
docker compose version
```

Start the Agent Zero container (uses the prebuilt image, port 50001):
```bash
docker compose -f docker-compose.local.yml up -d
```

Confirm it's running:
```bash
curl http://localhost:50001
```
Expected: HTTP 200.

> **Linux note:** `host.docker.internal` requires `extra_hosts: "host.docker.internal:host-gateway"` in docker-compose. This is already written in the PHASE_0.md spec for Step 0.2.6 and will be added when we create `docker-compose.yml` for Pantheon itself.

---

## Step 3 — Install Node.js (if not present)

```bash
node --version
npm --version
```

If missing:
```bash
sudo pacman -S nodejs npm
```

---

## Step 4 — Install GitNexus globally

```bash
npm install -g gitnexus
```

> This should build cleanly on Linux. The Windows machine had a `tree-sitter-dart` native module failure that broke `npx gitnexus` — not an issue on CachyOS.

---

## Step 5 — Verify GitNexus

```bash
gitnexus --version
```
Expected: `1.6.3` (or higher)

```bash
gitnexus --help | grep -E "impact|context|query|detect_changes"
```
All four commands must appear. If any are missing, update GitNexus:
```bash
npm update -g gitnexus
```

---

## Step 6 — Install Ollama + GLM-5.1 fallback

```bash
ollama --version
```

If not installed:
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Pull the fallback model:
```bash
ollama pull glm-5.1:cloud
```

---

## You're ready — start the session

Follow the standard session start from `CLAUDE.md`:

1. Read `CLAUDE.md`
2. Read `pantheon/.planning/HANDOFF.md`
3. Read `pantheon/.planning/STATE.md`
4. Run the Git Sync Check
5. Load `pantheon/.planning/phases/PHASE_0.md`
6. Pick up at **Step 0.3** — GitNexus is installed; run `gitnexus analyze` and verify all four commands work
