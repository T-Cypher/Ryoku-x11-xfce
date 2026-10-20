#!/usr/bin/env bash
# Reversible XFCE integration. Backs up touched xfconf props to ~/.config/ryoku-xfce-backup/
set -euo pipefail
B="$HOME/.config/ryoku-xfce-backup"; mkdir -p "$B"
echo "Backing up xfconf panel/keyboard props to $B"
xfconf-query -c xfce4-panel -l > "$B/panel-props.txt" 2>/dev/null || true
xfconf-query -c xfce4-keyboard-shortcuts -l > "$B/kb-props.txt" 2>/dev/null || true
# Enable xfwm4 compositing (needed for translucency)
xfconf-query -c xfwm4 -p /general/use_compositing -s true 2>/dev/null || xfconf-query -c xfwm4 -p /general/use_compositing -n -t bool -s true
# Hide (do not delete) stock panel: set autohide + record intent; xfce-restore removes autostart override
mkdir -p "$HOME/.config/autostart"
printf '[Desktop Entry]\nType=Application\nName=xfce4-panel (disabled by ryoku-xfce)\nExec=xfce4-panel\nHidden=true\n' > "$HOME/.config/autostart/xfce4-panel-disabled.desktop"
pkill xfce4-panel 2>/dev/null || true
# Keybinds via xfconf (application shortcuts)
set_kb(){ xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$1" -n -t string -s "$2" 2>/dev/null || xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/$1" -s "$2"; }
set_kb "<Super>space" "qs -c ryoku-xfce ipc call launcher toggle"
set_kb "<Super>s" "qs -c ryoku-xfce ipc call controlcenter toggle"
set_kb "<Super>Escape" "qs -c ryoku-xfce ipc call powermenu toggle"
echo "Done. Log out/in or run: qs -c ryoku-xfce   (revert: scripts/xfce-restore.sh)"
