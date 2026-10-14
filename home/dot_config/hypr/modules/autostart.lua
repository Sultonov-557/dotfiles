-- =============================================================================
-- Hyprland Autostart & Plugins
-- =============================================================================

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("sleep 1 && hyprctl setcursor Bibata-Modern-Classic 24")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("blueman-applet")
  -- DankMaterialShell starts via quickshell or dms daemon
  hl.exec_cmd("dms run")
  -- Fallback wallpaper daemon if dms wallpaper is not running
  hl.exec_cmd("hyprpaper")
end)

-- Hyprglass config (if installed)
if hl.plugin.hyprglass then
  local hg = hl.plugin.hyprglass

  hg.config({
    default_theme = "dark",
    default_preset = "glass",
    tint_color = 0x8899aa22,
    brightness = 0.9,
    layers = { enabled = 1 },
  })

  hg.layer("waybar", { preset = "subtle", mask_threshold = 0.05 })
  hg.layer("swaync")
  hg.layer("quickshell:bezel", { preset = "ui", mask_threshold = 0.3 })
  hg.layer("debug-panel", { exclude = true })

  hg.preset("glass", {
    blur_strength = 1.5,
    refraction_strength = 1.0,
    chromatic_aberration = 0.0,
    fresnel_strength = 1.0,
    specular_strength = 1.0,
    glass_opacity = 1,
    edge_thickness = 0.15,
    tint_color = 0xFFFFFF00,
    lens_distortion = 1,
    brightness = 0.7,
    contrast = 1,
    saturation = 1,
    vibrancy = 1,
    vibrancy_darkness = 1,
    adaptive_dim = 0,
    adaptive_boost = 0,
  })
end
