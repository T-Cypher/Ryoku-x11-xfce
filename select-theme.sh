#!/usr/bin/env bash
# Select a Ryoku-XFCE palette: solitude (default) | mocha | light.
# The palette is chosen at launch from RYOKU_XFCE_THEME, so this just tells you
# how to apply it — no files are edited.
set -euo pipefail

THEME="${1:-}"
if [ -z "$THEME" ]; then
    echo "usage: $0 [solitude|mocha|light]"
    echo "current: ${RYOKU_XFCE_THEME:-solitude}"
    exit 1
fi
case "$THEME" in
    solitude|mocha|light) ;;
    *) echo "unknown theme: $THEME (use solitude|mocha|light)"; exit 1 ;;
esac

echo "To apply '$THEME', export it for your session and restart quickshell:"
echo "  export RYOKU_XFCE_THEME=$THEME   # add to ~/.xprofile or ~/.config/xfce4/xinitrc"
echo "  pkill qs && qs"
