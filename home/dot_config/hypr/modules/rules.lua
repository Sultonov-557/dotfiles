-- =============================================================================
-- Hyprland Window Rules
-- =============================================================================

-- Scratchpad rules
hl.window_rule({
  name = "scratch-terminal",
  match = { class = "^(ghostty-scratch)$" },
  workspace = "special:terminal",
  float = true,
  size = "75% 70%",
  center = true,
})

hl.window_rule({
  name = "scratch-obsidian",
  match = { class = "^(obsidian)$" },
  workspace = "special:notes",
  float = true,
  size = "80% 80%",
  center = true,
})

-- Picture-in-Picture
hl.window_rule({
  name = "float-pip",
  match = { title = "^(Picture-in-Picture)$" },
  float = true,
  pin = true,
  size = "480 270",
  center = true,
})

-- Common dialogs & floaters
hl.window_rule({ name = "float-dropdown", match = { class = "^(dropdown)$" }, float = true, no_blur = true })
hl.window_rule({ name = "ws-dropdown", match = { class = "^(dropdown)$" }, workspace = "special:dropdown" })
hl.window_rule({ name = "float-volume", match = { title = "^(Volume Control)$" }, float = true })
hl.window_rule({ name = "float-pavucontrol", match = { class = "^(pavucontrol)$" }, float = true })
hl.window_rule({ name = "float-swappy", match = { class = "^(swappy)$" }, float = true })
hl.window_rule({ name = "float-progress", match = { class = "^(file_progress)$" }, float = true })
hl.window_rule({ name = "float-confirm", match = { class = "^(confirm)$" }, float = true })
hl.window_rule({ name = "float-dialog", match = { class = "^(dialog)$" }, float = true })
hl.window_rule({ name = "float-download", match = { class = "^(download)$" }, float = true })
hl.window_rule({ name = "float-notification", match = { class = "^(notification)$" }, float = true })
hl.window_rule({ name = "float-error", match = { class = "^(error)$" }, float = true })
hl.window_rule({ name = "float-calculator", match = { class = "^(org.gnome.Calculator)$" }, float = true })
hl.window_rule({ name = "float-nautilus", match = { class = "^(org.gnome.Nautilus)$" }, float = true })
hl.window_rule({ name = "float-blueman", match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({ name = "float-nm-editor", match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ name = "float-xdg-portal", match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })

-- File dialogs (Open, Save, Select, Choose)
hl.window_rule({ name = "float-open-file", match = { title = "^(Open File)(.*)$" }, float = true })
hl.window_rule({ name = "float-save-file", match = { title = "^(Save File)(.*)$" }, float = true })
hl.window_rule({ name = "float-select", match = { title = "^(Select a)(.*)$" }, float = true })
hl.window_rule({ name = "float-choose", match = { title = "^(Choose )(.*)$" }, float = true })
hl.window_rule({ name = "float-open-folder", match = { title = "^(Open Folder)(.*)$" }, float = true })

-- Dim polkit
hl.window_rule({
  name = "dim-polkit",
  match = { class = "^(polkit-gnome-authentication-agent-1)$" },
  float = true,
  pin = true,
})

-- Launchers & overlays
hl.window_rule({ name = "noblur-wofi", match = { class = "^(wofi)$" }, no_blur = true })
hl.window_rule({ name = "noblur-deadlock-overlay", match = { title = "^(deadlocked_overlay)$" }, no_blur = true })

-- Workspace assignments
hl.window_rule({ name = "ws-terminal", match = { class = "^(com\\.mitchellh\\.ghostty|ghostty)$" }, workspace = "1" })
hl.window_rule({ name = "ws-browsers", match = { class = "^(firefox|floorp|brave|chromium)$" }, workspace = "2" })

-- Terminal & Browser opacity and blur
hl.window_rule({ name = "opacity-terminal", match = { class = "^(com\\.mitchellh\\.ghostty|ghostty)$" }, opacity = "0.85 0.80" })
hl.window_rule({ name = "opacity-browsers", match = { class = "^(floorp|firefox|brave|zen)$" }, opacity = "0.98 0.90" })

-- Fullscreen window borders
hl.window_rule({ name = "noborder-fullscreen", match = { fullscreen = true }, border_size = 0 })

-- Fix XWayland drags
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
  no_initial_focus = true,
})
