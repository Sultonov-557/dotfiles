-- =============================================================================
-- Hyprland Lua Configuration — Riced af
-- =============================================================================
-- Source: ~/dotfiles/hypr
-- Managed with GNU Stow
-- Full Lua migration for Hyprland v0.55.4+
--
-- NOTE: Some settings are still in hyprland.conf because the Lua API
-- doesn't expose them yet. Both files are loaded (conf sources lua).
-- =============================================================================

-- Colors (Gruvbox Dark, synced with Noctalia)
require("noctalia.noctalia-colors")

-- Global color variables
local ac     = accent
local ac_sec = accent_secondary
local bg     = background

-- ------------------
--     MONITORS
-- ------------------
-- Per-hostname monitor layouts
-- Customize for your machines: archbook (laptop), vanguard (desktop), server
local hostname = io.popen("hostname"):read("*l"):gsub("%s+", "")

if hostname == "archbook" then
    hl.monitor({
        output   = "eDP-1",
        mode     = "preferred",
        position = "0x0",
        scale    = "1.25",
    })
elseif hostname == "vanguard" then
    hl.monitor({
        output   = "DP-1",
        mode     = "2560x1440@165",
        position = "0x0",
        scale    = "1.0",
    })
    hl.monitor({
        output   = "HDMI-A-1",
        mode     = "1920x1080@60",
        position = "2560x0",
        scale    = "1.0",
    })
else
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })
end

-- -------------------------------
--   ENVIRONMENT VARIABLES
-- -------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("NIXOS_OZONE_WL", "1")

-- =============================================================================
--     LOOK AND FEEL  (Lua-supported keys only)
-- =============================================================================
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = { ac, ac_sec }, angle = 45 },
            inactive_border = bg,
        },

        resize_on_border = true,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.90,

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = "rgba(1c1c1cff)",
        },

        blur = {
            enabled   = true,
            size      = 6,
            passes    = 3,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- --- Input ---
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- --- Layouts ---
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})

-- --- Misc ---
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})

-- =============================================================================
--     GESTURES
-- =============================================================================
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- =============================================================================
--     BEZIER CURVES
-- =============================================================================
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("smoothOut",      { type = "bezier", points = { {0.25, 0.46}, {0.45, 0.94} } })
hl.curve("softBounce",     { type = "bezier", points = { {0.34, 1.56}, {0.64, 1}    } })
hl.curve("snappy",         { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}     } })

-- =============================================================================
--     ANIMATIONS
-- =============================================================================
hl.animation({ leaf = "global",           enabled = true, speed = 10,    bezier = "default" })
hl.animation({ leaf = "border",           enabled = true, speed = 5.39,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",          enabled = true, speed = 4.79,  bezier = "smoothOut",   style = "slide" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 4.79,  bezier = "smoothOut",   style = "slide" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 1.49,  bezier = "linear",      style = "slide" })
hl.animation({ leaf = "fadeIn",           enabled = true, speed = 2.73,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 1.46,  bezier = "almostLinear" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3.03,  bezier = "quick" })
hl.animation({ leaf = "layers",           enabled = true, speed = 3.81,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 4,     bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1.5,   bezier = "linear",      style = "fade" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 1.79,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1.39,  bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 2.5,   bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn",     enabled = true, speed = 4,     bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut",    enabled = true, speed = 1.94,  bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.79,  bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 4.79,  bezier = "easeOutQuint" })

-- =============================================================================
--     KEYBINDINGS
-- =============================================================================
local mainMod      = "SUPER"
local terminal     = "ghostty"
local fileManager  = "nautilus"
local noci         = "qs -c noctalia-shell ipc --any-display call"

-- --- App launchers ---
hl.bind(mainMod .. " + SPACE",         hl.dsp.exec_cmd(noci .. " launcher toggle"), { description = "App launcher" })
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd(noci .. " launcher command"), { description = "Command launcher" })
hl.bind(mainMod .. " + Return",        hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Return",hl.dsp.exec_cmd(terminal .. " --working-directory=~/"))

-- --- Most used apps (one-key access) ---
hl.bind(mainMod .. " + W",             hl.dsp.exec_cmd("zen"), { description = "Zen browser" })
hl.bind(mainMod .. " + A",             hl.dsp.exec_cmd("obsidian"), { description = "Obsidian" })
hl.bind(mainMod .. " + G",             hl.dsp.exec_cmd("steam"), { description = "Steam" })
hl.bind(mainMod .. " + E",             hl.dsp.exec_cmd(fileManager))

-- --- Clipboard ---
hl.bind(mainMod .. " + C",             hl.dsp.exec_cmd(noci .. " launcher clipboard"), { description = "Clipboard picker" })
hl.bind(mainMod .. " + ALT + X",       hl.dsp.exec_cmd("cliphist delete-prime && cliphist delete-prime"), { description = "Clear clipboard" })

-- --- Screenshots ---
hl.bind("Print",                         hl.dsp.exec_cmd("screenshot region"))
hl.bind(mainMod .. " + SHIFT + S",       hl.dsp.exec_cmd("screenshot region"), { description = "Screenshot region" })
hl.bind("SHIFT + Print",               hl.dsp.exec_cmd("screenshot full"))
hl.bind("CTRL + Print",                hl.dsp.exec_cmd("screenshot copy"))
hl.bind("CTRL + SHIFT + Print",        hl.dsp.exec_cmd("screenshot active"))

-- --- Window management ---
hl.bind(mainMod .. " + Q",             hl.dsp.window.close())
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F",     hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + V",             hl.dsp.window.float({ action = "toggle" }), { description = "Toggle float" })
hl.bind(mainMod .. " + SHIFT + V",     hl.dsp.window.pin())
hl.bind(mainMod .. " + P",             hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",             hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + T",             hl.dsp.layout("dwindle"))
hl.bind(mainMod .. " + SHIFT + T",     hl.dsp.layout("master"))
hl.bind(mainMod .. " + O",             hl.dsp.layout("orientationnext"))

-- --- Focus movement ---
hl.bind(mainMod .. " + H",            hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J",            hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K",            hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L",            hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + left",         hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + down",         hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + up",           hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + right",        hl.dsp.focus({ direction = "r" }))

-- --- Move windows ---
hl.bind(mainMod .. " + SHIFT + H",    hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J",    hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L",    hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + up",   hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + right",hl.dsp.window.move({ direction = "r" }))

-- --- Resize windows ---
hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -60 0"))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 60"))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -60"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 60 0"))

-- --- Workspace switching ---
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,      hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. i))
end

-- --- Special workspace (scratchpad) ---
hl.bind(mainMod .. " + S",              hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S",      hl.dsp.window.move({ workspace = "special:magic" }))

-- --- Scroll workspaces ---
hl.bind(mainMod .. " + mouse_down",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",      hl.dsp.focus({ workspace = "e-1" }))

-- --- Mouse bindings for move/resize ---
hl.bind(mainMod .. " + mouse:272",     hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",     hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- --- Multimedia keys (via noctalia IPC) ---
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noci .. " volume increase"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noci .. " volume decrease"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noci .. " volume muteOutput"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noci .. " volume muteInput"),  { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd(noci .. " brightness increase"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd(noci .. " brightness decrease"),  { locked = true, repeating = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd(noci .. " media next"),       { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd(noci .. " media previous"),   { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd(noci .. " media playPause"),  { locked = true })
hl.bind("XF86AudioStop",        hl.dsp.exec_cmd(noci .. " media stop"),       { locked = true })

-- --- Lock screen ---
hl.bind(mainMod .. " + CTRL + L",         hl.dsp.exec_cmd(noci .. " sessionMenu lock"), { description = "Lock screen" })
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- --- Flow / Utility (via noctalia IPC) ---
hl.bind(mainMod .. " + SHIFT + C",     hl.dsp.exec_cmd("picker"), { description = "Color picker" })
hl.bind(mainMod .. " + SHIFT + R",     hl.dsp.exec_cmd("recorder toggle"), { description = "Toggle screen recording" })
hl.bind(mainMod .. " + SHIFT + I",     hl.dsp.exec_cmd(noci .. " idleInhibitor toggle"), { description = "Toggle caffeine (idle inhibit)" })
hl.bind(mainMod .. " + SHIFT + D",     hl.dsp.exec_cmd(noci .. " notifications toggleDND"), { description = "Toggle Do Not Disturb" })
hl.bind(mainMod .. " + SHIFT + P",     hl.dsp.exec_cmd(noci .. " powerProfile cycle"), { description = "Toggle performance mode" })
hl.bind(mainMod .. " + Escape",        hl.dsp.exec_cmd(noci .. " sessionMenu toggle"), { description = "Power menu" })
hl.bind(mainMod .. " + SHIFT + F12",   hl.dsp.exec_cmd("focus"), { description = "Toggle focus mode" })

-- --- Dropdown terminal (quake-style) ---
hl.bind("F12", hl.dsp.exec_cmd("ghostty --class=dropdown"), { description = "Dropdown terminal" })

-- --- Emoji picker ---
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(noci .. " launcher emoji"), { description = "Emoji picker" })

-- --- Shell switcher ---
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("shells"), { description = "Switch QuickShell config" })

-- --- Noctalia extras ---
hl.bind(mainMod .. " + D",             hl.dsp.exec_cmd(noci .. " controlCenter toggle"), { description = "Toggle control center" })
hl.bind(mainMod .. " + SHIFT + O",     hl.dsp.exec_cmd(noci .. " monitors off"), { description = "Turn off monitors" })

-- =============================================================================
--     WINDOW RULES
-- =============================================================================

-- Floating windows
hl.window_rule({ name = "float-pip",    match = { title = "^(Picture-in-Picture)$" },     float = true })
hl.window_rule({ name = "float-dropdown", match = { class = "^(dropdown)$" }, float = true, no_blur = true, })
hl.window_rule({ name = "ws-dropdown", match = { class = "^(dropdown)$" }, workspace = "special:dropdown" })
hl.window_rule({ name = "float-volume", match = { title = "^(Volume Control)$" },          float = true })
hl.window_rule({ name = "float-pavucontrol", match = { class = "^(pavucontrol)$" },        float = true })
hl.window_rule({ name = "float-swappy", match = { class = "^(swappy)$" },                  float = true })
hl.window_rule({ name = "float-progress", match = { class = "^(file_progress)$" },         float = true })
hl.window_rule({ name = "float-confirm", match = { class = "^(confirm)$" },                float = true })
hl.window_rule({ name = "float-dialog", match = { class = "^(dialog)$" },                  float = true })
hl.window_rule({ name = "float-download", match = { class = "^(download)$" },              float = true })
hl.window_rule({ name = "float-notification", match = { class = "^(notification)$" },      float = true })
hl.window_rule({ name = "float-error", match = { class = "^(error)$" },                    float = true })
hl.window_rule({ name = "float-calculator", match = { class = "^(org.gnome.Calculator)$" }, float = true })
hl.window_rule({ name = "float-nautilus", match = { class = "^(org.gnome.Nautilus)$" },     float = true })
hl.window_rule({ name = "float-blueman", match = { class = "^(blueman-manager)$" },         float = true })
hl.window_rule({ name = "float-nm-editor", match = { class = "^(nm-connection-editor)$" },  float = true })
hl.window_rule({ name = "float-xdg-portal", match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })

-- No blur for launchers (no_blur is supported in Lua API)
hl.window_rule({ name = "noblur-rofi", match = { class = "^(rofi)$" }, no_blur = true })
hl.window_rule({ name = "noblur-wofi", match = { class = "^(wofi)$" }, no_blur = true })

-- Workspace assignments
hl.window_rule({ name = "ws-terminal", match = { class = "^(ghostty)$" },  workspace = "1" })
hl.window_rule({ name = "ws-browsers", match = { class = "^(firefox|floorp|brave|chromium)$" }, workspace = "2" })

-- Fix XWayland empty windows
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus          = true,
    no_initial_focus  = true,
})

-- =============================================================================
--     AUTOSTART
-- =============================================================================
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("sleep 1 && hyprctl setcursor Bibata-Modern-Classic 24")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("cliphist-wl")
    hl.exec_cmd("dunst")
    hl.exec_cmd("qs -c noctalia-shell")
    hl.exec_cmd("sleep 3 && hyprctl reload")
end)
