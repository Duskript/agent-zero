#!/usr/bin/env bash
# init-athenaeum.sh
# Builds the real Athenaeum and Staging folder structure from Athenaeum.scaffold/
# Idempotent — safe to run multiple times. Never overwrites existing content.
# Usage: ./scripts/init-athenaeum.sh [optional: /custom/athenaeum/path]

set -euo pipefail

# ─── Configuration ────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCAFFOLD_DIR="$REPO_ROOT/Athenaeum.scaffold"

# Default paths — override by passing a custom path as first argument
PANTHEON_ROOT="${1:-$HOME/Pantheon}"
ATHENAEUM_ROOT="$PANTHEON_ROOT/Athenaeum"
STAGING_ROOT="$PANTHEON_ROOT/Staging"

# ─── Counters ─────────────────────────────────────────────────────────────────

created_dirs=0
skipped_dirs=0
created_files=0
skipped_files=0

# ─── Helpers ──────────────────────────────────────────────────────────────────

make_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "  [created] $dir"
        ((created_dirs++)) || true
    else
        echo "  [exists]  $dir"
        ((skipped_dirs++)) || true
    fi
}

make_file() {
    local src="$1"
    local dest="$2"
    if [ ! -f "$dest" ]; then
        cp "$src" "$dest"
        echo "  [created] $dest"
        ((created_files++)) || true
    else
        echo "  [exists]  $dest"
        ((skipped_files++)) || true
    fi
}

make_index() {
    local dest="$1"
    local title="$2"
    local parent_link="$3"
    if [ ! -f "$dest" ]; then
        cat > "$dest" <<EOF
# ${title}
Parent: ${parent_link}
Last updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

## Subfolders

| Folder | Description | Index |
|---|---|---|

## Files

| File | Summary |
|---|---|
EOF
        echo "  [created] $dest"
        ((created_files++)) || true
    else
        echo "  [exists]  $dest"
        ((skipped_files++)) || true
    fi
}

# ─── Validate scaffold exists ──────────────────────────────────────────────────

if [ ! -d "$SCAFFOLD_DIR" ]; then
    echo "ERROR: Scaffold directory not found at $SCAFFOLD_DIR"
    echo "       Run this script from the repo root or ensure Athenaeum.scaffold/ exists."
    exit 1
fi

# ─── Create Pantheon root ──────────────────────────────────────────────────────

echo ""
echo "━━━ Pantheon Init ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Pantheon root : $PANTHEON_ROOT"
echo "  Athenaeum     : $ATHENAEUM_ROOT"
echo "  Staging       : $STAGING_ROOT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

make_dir "$PANTHEON_ROOT"

# ─── Build Staging ─────────────────────────────────────────────────────────────

echo "▸ Staging"
make_dir "$STAGING_ROOT"
make_dir "$STAGING_ROOT/inbox"
make_dir "$STAGING_ROOT/processing"
make_dir "$STAGING_ROOT/rejected"
echo ""

# ─── Build Athenaeum from scaffold ────────────────────────────────────────────

echo "▸ Athenaeum"
make_dir "$ATHENAEUM_ROOT"

# Root INDEX.md
ROOT_INDEX="$ATHENAEUM_ROOT/INDEX.md"
if [ ! -f "$ROOT_INDEX" ]; then
    cat > "$ROOT_INDEX" <<'EOF'
# Athenaeum — Master Index
Last updated: TIMESTAMP

## Codices

| Codex | Description | Index |
|---|---|---|
| Codex-SKC | Music, lyrics, sonic identity, and style for the SKC project | [→](Codex-SKC/INDEX.md) |
| Codex-Infrastructure | Homelab, networking, IT systems, and Proxmox | [→](Codex-Infrastructure/INDEX.md) |
| Codex-Pantheon | System documentation, harnesses, workflows, and session logs | [→](Codex-Pantheon/INDEX.md) |
| Codex-Forge | Planning sessions, blueprints, and project specs | [→](Codex-Forge/INDEX.md) |
| Codex-Fiction | Long form narrative, worldbuilding, and The Cantor's Tale | [→](Codex-Fiction/INDEX.md) |
| Codex-Asclepius | Medical research, health knowledge, and treatment references | [→](Codex-Asclepius/INDEX.md) |
| Codex-General | Uncategorized notes and personal knowledge | [→](Codex-General/INDEX.md) |
EOF
    # Replace TIMESTAMP placeholder
    sed -i "s/TIMESTAMP/$(date -u +"%Y-%m-%dT%H:%M:%SZ")/" "$ROOT_INDEX"
    echo "  [created] $ROOT_INDEX"
    ((created_files++)) || true
else
    echo "  [exists]  $ROOT_INDEX"
    ((skipped_files++)) || true
fi

echo ""

# ─── Walk scaffold and mirror structure ───────────────────────────────────────

# Define Codices and their subfolders explicitly
# Format: "CodexName:subfolder1,subfolder2,..."
declare -A CODEX_SUBFOLDERS
CODEX_SUBFOLDERS["Codex-SKC"]="lyrics,style,references,distilled,archive"
CODEX_SUBFOLDERS["Codex-Infrastructure"]="homelab,networking,proxmox,distilled,archive"
CODEX_SUBFOLDERS["Codex-Pantheon"]="constitution,harnesses,workflows,sessions,distilled,archive"
CODEX_SUBFOLDERS["Codex-Forge"]="blueprints,sessions,distilled,archive"
CODEX_SUBFOLDERS["Codex-Fiction"]="cantors-tale,worldbuilding,distilled,archive"
CODEX_SUBFOLDERS["Codex-General"]="notes,distilled,archive"
CODEX_SUBFOLDERS["Codex-Asclepius"]="research,references,conditions,treatments,distilled,archive"

for codex in "${!CODEX_SUBFOLDERS[@]}"; do
    echo "▸ $codex"
    codex_path="$ATHENAEUM_ROOT/$codex"
    make_dir "$codex_path"

    # Codex-level INDEX.md
    make_index \
        "$codex_path/INDEX.md" \
        "$codex" \
        "[Athenaeum](../INDEX.md)"

    # Subfolders
    IFS=',' read -ra subfolders <<< "${CODEX_SUBFOLDERS[$codex]}"
    for subfolder in "${subfolders[@]}"; do
        sub_path="$codex_path/$subfolder"
        make_dir "$sub_path"
        make_index \
            "$sub_path/INDEX.md" \
            "$subfolder" \
            "[$codex](../INDEX.md)"
    done

    # Codex-Pantheon needs sessions/kronos/ and sessions/archive/ subdirs
    if [ "$codex" = "Codex-Pantheon" ]; then
        make_dir "$codex_path/sessions/kronos"
        make_dir "$codex_path/sessions/archive"
        make_index \
            "$codex_path/sessions/kronos/INDEX.md" \
            "kronos" \
            "[sessions](../INDEX.md)"
        make_index \
            "$codex_path/sessions/archive/INDEX.md" \
            "archive" \
            "[sessions](../INDEX.md)"
    fi

    echo ""
done

# ─── Copy scaffold templates if present ───────────────────────────────────────

if [ -d "$SCAFFOLD_DIR" ]; then
    echo "▸ Scaffold templates"
    while IFS= read -r -d '' template; do
        rel_path="${template#$SCAFFOLD_DIR/}"
        # Strip .template extension for destination
        dest_rel="${rel_path%.template}"
        dest="$ATHENAEUM_ROOT/$dest_rel"
        if [ ! -f "$dest" ] && [ -f "$template" ]; then
            make_dir "$(dirname "$dest")"
            cp "$template" "$dest"
            echo "  [created] $dest (from template)"
            ((created_files++)) || true
        fi
    done < <(find "$SCAFFOLD_DIR" -name "*.template" -print0 2>/dev/null)
    echo ""
fi

# ─── Summary ──────────────────────────────────────────────────────────────────

echo "━━━ Summary ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Directories created : $created_dirs"
echo "  Directories skipped : $skipped_dirs (already existed)"
echo "  Files created       : $created_files"
echo "  Files skipped       : $skipped_files (already existed)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Athenaeum initialized at: $ATHENAEUM_ROOT"
echo "Staging initialized at:   $STAGING_ROOT"
echo ""
echo "Next steps:"
echo "  1. Run migrate-oracle-vault.sh if you have an existing ORACLE vault"
echo "  2. Begin Phase 1 harness YAML schema definition"
echo ""
