-- =============================================================================
-- Hyprland Keybindings Architecture
-- =============================================================================
-- Flow Constitution:
--   Universal HJKL Navigation:
--     SUPER + [HJKL]        : Move focus
--     SUPER + SHIFT + [HJKL]: Move active window
--     SUPER + CTRL + [HJKL] : Resize active window
--
--   Launcher & HUDs:
--     SUPER + Space         : Vicinae application launcher
--     SUPER + C             : Vicinae clipboard manager
--     SUPER + Return        : Ghostty terminal
--     SUPER + S             : Special workspace: terminal scratchpad
--     SUPER + A             : Special workspace: notes scratchpad (Obsidian)
-- =============================================================================

local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "nautilus"

-- --- App Launchers & HUDs ---
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"), { description = "Vicinae HUD launcher" })
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "Primary terminal" })
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal .. " --working-directory=~/"), { description = "Terminal in ~" })

-- --- Clipboard Manager ---
hl.bind(
  mainMod .. " + C",
  hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history?toggle=true"),
  { description = "Vicinae clipboard history" }
)

-- --- Quick Apps ---
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("zen-browser"), { description = "Zen browser" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "File manager" })
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("lutris"), { description = "Lutris" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("Telegram"), { description = "Telegram" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("spotify-launcher"), { description = "Spotify" })

-- --- Window Management ---
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "Fullscreen window" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 1 }), { description = "Maximize window" })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle float" })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.pin(), { description = "Pin floating window" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo tile" })

-- Layout toggles
hl.bind(mainMod .. " + ALT + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.layout("master"))
hl.bind(mainMod .. " + ALT + T", hl.dsp.layout("dwindle"))
hl.bind(mainMod .. " + O", hl.dsp.layout("orientationnext"))

-- --- Universal HJKL Focus Movement ---
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))

-- --- Move Active Windows ---
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))

-- --- Resize Windows (Sub-millisecond dynamic resize) ---
hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -60 0"), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 60"), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -60"), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 60 0"), { repeating = true })

-- --- Workspaces (1-10) ---
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. i))
end

-- --- Scratchpads ---
-- SUPER + S: Terminal scratchpad
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace terminal"), { description = "Toggle terminal scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:terminal"), { description = "Move to terminal scratchpad" })

-- SUPER + A: Obsidian notes scratchpad
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace notes"), { description = "Toggle notes scratchpad" })
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:notes"), { description = "Move to notes scratchpad" })

-- Scroll workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- --- Multimedia & Hardware Keys ---
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volume mic-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- --- Screenshots ---
hl.bind("Print", hl.dsp.exec_cmd("screenshot region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot full"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("screenshot copy"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("screenshot active"))

-- --- Utilities & Quick Actions ---
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("picker"), { description = "Color picker" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("recorder toggle"), { description = "Screen recorder" })
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("caffeine"), { description = "Caffeine / idle inhibitor" })
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("dnd"), { description = "Do Not Disturb" })
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("powerprofile"), { description = "Power profile" })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("power-menu"), { description = "Power menu" })
hl.bind(mainMod .. " + SHIFT + F12", hl.dsp.exec_cmd("focus"), { description = "Focus mode" })
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/vicinae/search-emojis"), { description = "Emoji picker" })
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("shells"), { description = "Shell switcher" })
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("hyprctl dispatch dpms off"), { description = "Turn off monitors" })
