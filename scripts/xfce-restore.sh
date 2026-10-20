#!/usr/bin/env bash
set -euo pipefail
rm -f "$HOME/.config/autostart/xfce4-panel-disabled.desktop" "$HOME/.config/autostart/ryoku-xfce-shell.desktop"
for k in "<Super>space" "<Super>s" "<Super>Escape"; do xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$k" -r 2>/dev/null || true; done
pkill -f 'qs -c ryoku-xfce' 2>/dev/null || true
nohup xfce4-panel >/dev/null 2>&1 &
echo "Restored xfce4-panel; ryoku-xfce autostart + keybinds removed."
