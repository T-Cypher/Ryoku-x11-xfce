// Ryoku → Quickshell conversion for XFCE (xfwm4) on X11 / Arch.
//
// This is a self-contained shell: it reuses Ryoku's visual language (the Solitude
// Dark palette, the monochrome "sumi" pill, the warm-coral accent, the rounded
// translucent panels) but replaces Ryoku's Wayland/Hyprland + Go-daemon stack with
// portable Quickshell modules and standard Arch tooling (wpctl, nmcli, brightnessctl,
// bluetoothctl, redshift, powerprofilesctl, wmctrl/xdotool, xfce4-session).
//
// On X11, PanelWindow maps to an X11 dock (_NET_WM_STRUT_PARTIAL) so xfwm4 reserves
// the top strip automatically — no layer-shell required.
//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io

import qs.theme
import qs.components
import qs.modules.bar
import qs.modules.controlcenter
import qs.modules.launcher
import qs.modules.powermenu
import qs.modules.calendar
import qs.modules.osd

ShellRoot {
    // One pill bar per connected screen.
    Variants {
        model: Quickshell.screens
        delegate: Component { Bar {} }
    }

    // Overlays (single instances, shown on the primary screen).
    ControlCenter { }
    Launcher { }
    PowerMenu { }
    Calendar { }
    Osd { }

    // IPC toggles — bind these from XFCE's keyboard shortcuts:
    //   qs -c ryoku-xfce ipc call launcher toggle
    //   qs -c ryoku-xfce ipc call controlcenter toggle
    //   qs -c ryoku-xfce ipc call powermenu toggle
    IpcHandler {
        target: "launcher"
        function toggle(): void { ShellState.toggleLauncher() }
        function show(): void { ShellState.launcher = true }
        function hide(): void { ShellState.launcher = false }
    }
    IpcHandler {
        target: "controlcenter"
        function toggle(): void { ShellState.toggleControlCenter() }
        function show(): void { ShellState.controlCenter = true }
        function hide(): void { ShellState.controlCenter = false }
    }
    IpcHandler {
        target: "calendar"
        function toggle(): void { ShellState.toggleCalendar() }
    }
    IpcHandler {
        target: "powermenu"
        function toggle(): void { ShellState.togglePowerMenu() }
        function show(): void { ShellState.powerMenu = true }
        function hide(): void { ShellState.powerMenu = false }
    }
}
