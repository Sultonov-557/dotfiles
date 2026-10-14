-- =============================================================================
-- Hyprland Look & Feel (Gruvbox Pixel-Art Edition)
-- =============================================================================
-- Palette:
--   Active border: Gruvbox Gold / Amber (#d79921)
--   Inactive border: Gruvbox Dark Surface (#3c3836)
--   Deep canvas: #1d2021
-- Crisp geometry: 4px rounding, 2px borders for clean pixel-art aesthetics

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,
    col = {
      active_border = "rgb(d79921)",
      inactive_border = "rgb(3c3836)",
    },
    resize_on_border = true,
    layout = "dwindle",
    hover_icon_on_border = true,
    extend_border_grab_area = 15,
  },

  cursor = {
    inactive_timeout = 3,
    no_hardware_cursors = 0,
  },

  decoration = {
    rounding = 4,
    rounding_power = 2,

    active_opacity = 1.0,
    inactive_opacity = 0.95,
    fullscreen_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 10,
      render_power = 3,
      color = "rgba(1d2021ee)",
      color_inactive = "rgba(1d202188)",
      offset = "0 3",
      scale = 0.98,
    },

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      vibrancy = 0.1696,
      noise = 0.01,
      contrast = 0.95,
      brightness = 1.0,
      new_optimizations = true,
      xray = false,
    },
  },

  group = {
    col = {
      border_active = "rgb(d79921)",
      border_inactive = "rgb(3c3836)",
      border_locked_active = "rgb(fb4934)",
      border_locked_inactive = "rgb(3c3836)",
    },
    groupbar = {
      col = {
        active = "rgb(d79921)",
        inactive = "rgb(3c3836)",
        locked_active = "rgb(fb4934)",
        locked_inactive = "rgb(3c3836)",
      },
    },
  },
})
