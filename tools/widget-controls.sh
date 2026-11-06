#!/usr/bin/env bash
# List Elementor controls for a widget: tab › section › label [key] → selector: css
# Usage: tools/widget-controls.sh <widget_type> [keyword]
# Uses manifest.json files when the widget is listed there; otherwise greps PHP add_control calls.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MU="$ROOT/storefront-wp/wp-content/mu-plugins"
WT="${1:?usage: widget-controls.sh <widget_type> [keyword]}"; KW="${2:-}"

hits=$(find "$MU" -name 'manifest*.json' -print0 | xargs -0 jq -r --arg wt "$WT" --arg kw "$KW" '
  .widgets[]? | select(.widget_type == $wt) | .controls[]
  | select($kw == "" or ((.key + " " + (.name // "") + " " + (.section // "") + " " + ((.selectors // {}) | tostring)) | ascii_downcase | contains($kw | ascii_downcase)))
  | "\(.tab // "-") › \(.section // "-") › \(.name // "-")  [\(.key)]"
    + (if .condition then "  (if \(.condition|tostring))" else "" end)
    + (if .selectors then "\n    → " + ((.selectors|to_entries|map("\(.key): \(.value)")|join(" | "))) else "" end)
' 2>/dev/null | head -80 || true)

if [ -n "$hits" ]; then echo "$hits"; exit 0; fi

# Fallback (v2 widgets etc.): locate the widget file and grep control definitions.
FILE=$("$ROOT/tools/widget-locate.sh" "$WT" 2>/dev/null | head -1 | cut -d: -f1 || true)
[ -z "$FILE" ] && { echo "widget_type '$WT' not found"; exit 1; }
PAT="add_(responsive_)?control\(|add_group_control\(|start_controls_section\(|Controls::register|'label'|'selectors'"
filt() { if [ -n "$KW" ]; then grep -i -C2 -- "$KW" || true; else cat; fi; }
echo "# no manifest entry; controls parsed from widget PHP"
echo "## $FILE"
grep -nE "$PAT" "$FILE" | filt | head -80
# v2: atom controls delegated via WizAtom_<Atom>_Controls::register($this) -> atoms/<Atom>/controls.php
for atom in $(grep -oE "WizAtom_[A-Za-z]+_Controls::register" "$FILE" | sed -E 's/WizAtom_([A-Za-z]+)_Controls.*/\1/' | sort -u); do
  af="$MU/atoms/$atom/controls.php"; [ -f "$af" ] || continue
  out=$(grep -nE "$PAT" "$af" | filt | head -30)
  [ -n "$out" ] && { echo "## atom $atom ($af) — also defaulted in Site Settings"; echo "$out"; }
done
