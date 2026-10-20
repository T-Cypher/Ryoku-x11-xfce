// Ryoku-inspired design tokens, adapted for X11 / xfwm4.
//
// Three palettes ship out of the box, selected by the RYOKU_XFCE_THEME env var
// (solitude [default] | mocha | light):
//   - solitude : the original "Solitude Dark" near-black Material-3 base
//   - mocha    : Catppuccin Mocha
//   - light    : a Solitude Light variant for bright XFCE sessions
// Every other component reads these tokens, so switching themes touches nothing
// but this file. Radii / typography are shared across palettes.
pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property string themeName: Quickshell.env("RYOKU_XFCE_THEME") || "solitude"

    // --- Palettes -------------------------------------------------------------
    readonly property var palettes: ({
        solitude: {
            surface: "#000000", surfaceVariant: "#0a0a0a",
            surfaceContainerLow: "#0a0a0a", surfaceContainer: "#111111",
            surfaceContainerHigh: "#1c1c1c", surfaceContainerHighest: "#2a2a2a",
            inverseSurface: "#cdc4ba", surfaceTint: "#b0a9a0",
            primary: "#e2342a", primaryContainer: "#1a1d1f", secondary: "#b0a9a0",
            tertiary: "#e2342a", error: "#e2342a",
            outline: "#4a4642", outlineVariant: "#262422",
            onSurface: "#cdc4ba", onSurfaceVariant: "#b0a9a0",
            onPrimary: "#000000", onTertiary: "#ffffff",
            barFill: "#050505", barOpacity: 0.88,
            panelFill: "#0a0a0a", panelHover: "#1c1c1c", panelBorder: "#2a2a2a",
            accent: "#e2342a", accentSoft: "#f08a72",
            sheen: "#ffffff", glassTop: 0.10
        },
        mocha: {
            surface: "#1e1e2e", surfaceVariant: "#181825",
            surfaceContainerLow: "#181825", surfaceContainer: "#313244",
            surfaceContainerHigh: "#45475a", surfaceContainerHighest: "#585b70",
            inverseSurface: "#cdd6f4", surfaceTint: "#9399b2",
            primary: "#9399b2", primaryContainer: "#313244", secondary: "#cdd6f4",
            tertiary: "#fab387", error: "#f38ba8",
            outline: "#585b70", outlineVariant: "#45475a",
            onSurface: "#cdd6f4", onSurfaceVariant: "#a6adc8",
            onPrimary: "#1e1e2e", onTertiary: "#1e1e2e",
            barFill: "#1e1e2e", barOpacity: 0.88,
            panelFill: "#181825", panelHover: "#313244", panelBorder: "#45475a",
            accent: "#fab387", accentSoft: "#f9e2af",
            sheen: "#ffffff", glassTop: 0.10
        },
        light: {
            surface: "#f4f5f7", surfaceVariant: "#e7e9ee",
            surfaceContainerLow: "#e7e9ee", surfaceContainer: "#dde0e7",
            surfaceContainerHigh: "#cdd2dc", surfaceContainerHighest: "#bcc3d0",
            inverseSurface: "#1c1f24", surfaceTint: "#7d8694",
            primary: "#5b6470", primaryContainer: "#dde0e7", secondary: "#3d4450",
            tertiary: "#c2410c", error: "#b91c1c",
            outline: "#b6bcc8", outlineVariant: "#cdd2dc",
            onSurface: "#1c1f24", onSurfaceVariant: "#4a525e",
            onPrimary: "#f4f5f7", onTertiary: "#ffffff",
            barFill: "#ffffff", barOpacity: 0.82,
            panelFill: "#fbfcfe", panelHover: "#eef0f4", panelBorder: "#d3d8e0",
            accent: "#c2410c", accentSoft: "#ea580c",
            sheen: "#ffffff", glassTop: 0.55
        }
    })

    readonly property var pal: root.palettes[(root.themeName in root.palettes) ? root.themeName : "solitude"]

    // --- Surfaces (per palette) ----------------------------------------------
    readonly property color surface:                 pal.surface
    readonly property color surfaceVariant:          pal.surfaceVariant
    readonly property color surfaceContainerLow:     pal.surfaceContainerLow
    readonly property color surfaceContainer:        pal.surfaceContainer
    readonly property color surfaceContainerHigh:    pal.surfaceContainerHigh
    readonly property color surfaceContainerHighest: pal.surfaceContainerHighest
    readonly property color inverseSurface:          pal.inverseSurface
    readonly property color surfaceTint:             pal.surfaceTint
    readonly property color primary:                pal.primary
    readonly property color primaryContainer:       pal.primaryContainer
    readonly property color secondary:              pal.secondary
    readonly property color tertiary:               pal.tertiary
    readonly property color error:                  pal.error
    readonly property color outline:                pal.outline
    readonly property color outlineVariant:         pal.outlineVariant
    readonly property color onSurface:              pal.onSurface
    readonly property color onSurfaceVariant:       pal.onSurfaceVariant
    readonly property color onPrimary:              pal.onPrimary
    readonly property color onTertiary:             pal.onTertiary

    // --- Panel / bar (per palette) ------------------------------------------
    readonly property color barFill:                pal.barFill
    readonly property real  barOpacity:             pal.barOpacity
    readonly property color panelFill:              pal.panelFill
    readonly property color panelHover:             pal.panelHover
    readonly property color panelBorder:            pal.panelBorder
    readonly property color accent:                 pal.accent
    readonly property color accentSoft:            pal.accentSoft

    // --- Frosted-glass sheen (used by GlassSheen) ---------------------------
    readonly property color sheen:                  pal.sheen
    readonly property real  glassTop:              pal.glassTop
    readonly property bool  isLight:               root.themeName === "light"

    // --- Radii (shared) ------------------------------------------------------
    readonly property int rXs: 6
    readonly property int rSm: 10
    readonly property int rMd: 14
    readonly property int rLg: 18
    readonly property int rPill: 22

    // --- Typography (shared) -------------------------------------------------
    readonly property string fontSans: "\"Space Grotesk\", Inter, \"Noto Sans\", sans-serif"
    readonly property string fontMono: "\"SpaceMono Nerd Font\", \"JetBrains Mono\", \"Noto Sans Mono\", monospace"
}
