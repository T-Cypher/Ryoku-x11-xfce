# Continuation (v0.2.0) — what changed vs the archived v0.1
Archive downloaded from Google Drive (67.8 kB zip, 31 files) and continued in-place.
## Fixed (would error / misbehave)
- `Bar.qml`: added missing `import QtQuick.Layouts` (RowLayout/Layout.* failed to load); active-window title now reads an instance (`id: workspaces`) not the `WorkspacesWidget` type.
- `HSlider`: renamed user signal to `moved()` — redeclaring `valueChanged` clashed with the auto-generated property signal; Control-Center/media sliders no longer fight pollers (feedback loop). Media progress slider is read-only (`interactive:false`).
- `ShellState`: overlays are now mutually exclusive (`openOnly`); added Calendar + OSD state.
- Pollers: guard `if (!proc.running)` everywhere; Control Center only polls while visible and now also refreshes volume/brightness procs.
- `NetworkWidget`: state was computed before the SSID line arrived (line order WIFI/CONN/SSID) — now stored `wired` + `recompute()` after every line.
- Typo `wmctl` -> `wmctrl` in Workspaces docstring.
## Added
- Calendar popup (click clock; `qs -c ryoku-xfce ipc call calendar toggle`), OSD for volume/brightness, named-config install (`~/.config/quickshell/ryoku-xfce`, backs up previous), `scripts/{check-deps,xfce-setup,xfce-restore}.sh`, local `PKGBUILD`.
- Palette: default `solitude` now matches upstream Ryoku `ryoku/ui/Singletons/Tokens.qml` (paper `#000000`, ink `#cdc4ba`, sun/alert `#e2342a`, Space Grotesk/SpaceMono) instead of the archive's invented `#de6145`/`#101315`. `mocha`/`light` unchanged.
## Not ported (no X11/xfwm4 equivalent)
Layer-shell exclusivity/blur, Hyprland/niri workspaces, screencopy, Go `ryoku-shell` daemon, wallpaper-retint (matugen) — see README "X11 mapping". Suggested next: EWMH tasklist, org.freedesktop.Notifications popups, wallpaper tint via `matugen` on xfdesktop change.

## v0.2.1 (hotfix, reported 2026-10-20)
- `theme/Theme.qml`: renamed `property var P` -> `pal` — QML property names cannot begin with an upper-case letter (`Theme.qml[68:27]`); all 27 `P.*` refs updated. This was in the original archive, not introduced in v0.2.
- `modules/bar/ClockWidget.qml`: `letterSpacing: 1` -> `font.letterSpacing: 1` (same class of runtime error, caught pre-emptively by qmllint).
- Re-scanned all QML for capitalised property/signal names and syntax errors: clean.

## v0.2.2 (hotfix, reported 2026-10-20)
- All overlays `FloatingWindow` -> `PanelWindow`: QsWindow (v0.3 docs) has no `x`/`y` at all, so every overlay using them (`ControlCenter`, `Launcher`, `PowerMenu`, `Calendar`, `Osd`) would have failed in turn. Placement now via `anchors`+`margins` (centred margins computed from screen size), `implicitWidth/Height`, `focusable: true`.
- `ShellScreen.geometry.*` -> `.width/.height` (ShellScreen has x/y/width/height, no `geometry`).
- Removed `forceActiveFocus()` on windows (not a QsWindow method); Esc handlers moved from window roots (Keys is Item-only) to focused child Items.
- ObjectModel API audit vs docs: `Mpris.players`/`UPower.devices`/`SystemTray.items` `.count`/`.get(i)` -> `.values.length`/`.values[i]`; `player.playPause()` (does not exist) -> `togglePlaying()`.

## v0.2.3 (hotfix, reported 2026-10-20)
- Renamed singleton `State` -> `ShellState` (`components/ShellState.qml`, qmldir, all 31 refs). `State` collides with QtQuick's built-in `State` type: `visible: State.controlCenter` evaluated to undefined (popups defaulted to visible/open, X button set a property on the wrong type) and `State.toggleLauncher()` failed with "Property 'toggleLauncher' of object QtQuick/State is not a function".
- Removed dead `Connections { onDevicesChanged/onPlayersChanged }` (no such signals; warned in log) from Battery/Media/MediaCard: battery and player are now declarative bindings on `UPower.displayDevice` / `Mpris.players.values[0]`.
- Note: `Duplicate unique style id` / icon-theme and portal warnings in the log are from the user's icon theme / session, unrelated to this shell.
