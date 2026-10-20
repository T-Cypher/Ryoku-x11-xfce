#!/usr/bin/env bash
# Reports missing runtime deps; exit 1 if a core dep is missing.
core=(qs wmctrl xdotool wpctl nmcli); opt=(brightnessctl bluetoothctl redshift powerprofilesctl xflock4 xfce4-session-logout)
miss=0
for c in "${core[@]}"; do command -v "$c" >/dev/null && echo "ok      $c" || { echo "MISSING $c (core)"; miss=1; }; done
for c in "${opt[@]}"; do command -v "$c" >/dev/null && echo "ok      $c" || echo "missing $c (optional feature disabled)"; done
echo "session: ${XDG_SESSION_TYPE:-unknown} (want x11)  desktop: ${XDG_CURRENT_DESKTOP:-unknown}"
[ "${XDG_SESSION_TYPE:-}" = "wayland" ] && echo "WARN: Wayland session - this build targets X11/xfwm4"
exit $miss
