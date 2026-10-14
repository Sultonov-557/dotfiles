-- =============================================================================
-- Hyprland Layouts & Gestures
-- =============================================================================

hl.config({
  dwindle = {
    preserve_split = true,
    smart_split = false,
    smart_resizing = true,
    special_scale_factor = 0.85,
    split_width_multiplier = 1.0,
    force_split = 0,
  },
  master = {
    new_status = "master",
    mfact = 0.55,
    special_scale_factor = 0.85,
    orientation = "left",
    new_on_top = true,
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    initial_workspace_tracking = 0,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    enable_swallow = true,
    swallow_regex = "^(kitty|ghostty|alacritty)$",
    vrr = 2,
    disable_autoreload = false,
    animate_manual_resizes = true,
    animate_mouse_windowdragging = true,
  },
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.8,
    },
    numlock_by_default = true,
    float_switch_override_focus = 2,
  },
  binds = {
    pass_mouse_when_bound = false,
    scroll_event_delay = 300,
    workspace_back_and_forth = true,
    allow_workspace_cycles = true,
    movefocus_cycles_fullscreen = false,
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})
