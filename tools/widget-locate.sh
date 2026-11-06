#!/usr/bin/env bash
# Find the source file of a widget by widget_type, CSS class or visible text.
# Usage: tools/widget-locate.sh <widget_type|css-class|text>
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MU="$ROOT/storefront-wp/wp-content/mu-plugins"
Q="${1:?usage: widget-locate.sh <widget_type|css-class|text>}"

# 1) Registry in elementor-addon.php: 'widget_type' => ['file' => __DIR__ . '/widgets/...']
f=$(awk -v q="'$Q'" 'index($0,q" =>"){found=1} found && /'"'"'file'"'"'/ {match($0,/\/widgets\/[^'"'"']+/); print substr($0,RSTART+1,RLENGTH-1); exit}' "$MU/elementor-addon.php")
if [ -n "$f" ]; then echo "$MU/$f:registry"; exit 0; fi

# 2) get_name() returning it
grep -rln --include='*.php' -E "return ['\"]$Q['\"]" "$MU/widgets" "$MU/atoms" 2>/dev/null | sed 's/$/:get_name/' && exit 0 || true

# 3) CSS class / text across widget + atom sources
grep -rln --include='*.php' --include='*.js' --include='*.css' -F "$Q" "$MU/widgets" "$MU/atoms" 2>/dev/null | head -10
