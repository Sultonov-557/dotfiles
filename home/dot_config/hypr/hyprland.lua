-- =============================================================================
-- Hyprland Lua Configuration — Modular Gruvbox Edition
-- =============================================================================
-- Managed via dotfiles repository
-- Target: CachyOS / Arch Linux

-- Systemd environment setup
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

-- Load modular configuration in strict order
require("modules.monitors")
require("modules.env")
require("modules.theme")
require("modules.animations")
require("modules.layouts")
require("modules.keybinds")
require("modules.rules")
require("modules.autostart")
