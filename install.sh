#!/usr/bin/env bash
# Install Ryoku-XFCE as a *named* Quickshell config: ~/.config/quickshell/ryoku-xfce
# So it never clobbers a default ~/.config/quickshell/shell.qml. Run: qs -c ryoku-xfce
set -euo pipefail
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="ryoku-xfce"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/$NAME"
DRY=0; [ "${1:-}" = "--dry-run" ] && DRY=1
echo "==> Installing to: $DEST"
if [ -e "$DEST" ] && [ $DRY -eq 0 ]; then
  BK="$DEST.bak.$(date +%Y%m%d-%H%M%S)"; echo "==> Backing up existing to $BK"; mv "$DEST" "$BK"
fi
if [ $DRY -eq 1 ]; then echo "[dry-run] would copy shell.qml theme components modules"; exit 0; fi
mkdir -p "$DEST"
cp -r "$SRC/shell.qml" "$SRC/theme" "$SRC/components" "$SRC/modules" "$DEST/"
mkdir -p "$HOME/.config/autostart"
cp "$SRC/assets/quickshell.desktop" "$HOME/.config/autostart/ryoku-xfce-shell.desktop"
cat <<'EOF'

==> Done. Start now:
    qs -c ryoku-xfce
Stop / reload:
    qs -c ryoku-xfce kill   # or: pkill -f 'qs -c ryoku-xfce'
Dependencies (Arch):
    sudo pacman -S quickshell pipewire wireplumber pipewire-pulse \
        networkmanager brightnessctl bluez bluez-utils upower \
        wmctrl xdotool redshift power-profiles-daemon
Optional XFCE integration (disables xfce4-panel, adds keybinds, enables compositing):
    ./scripts/xfce-setup.sh        # reversible: ./scripts/xfce-restore.sh
Keybinds (XFCE Settings > Keyboard > Application Shortcuts):
    Super+Space -> qs -c ryoku-xfce ipc call launcher toggle
    Super+S     -> qs -c ryoku-xfce ipc call controlcenter toggle
    Super+Esc   -> qs -c ryoku-xfce ipc call powermenu toggle
EOF
