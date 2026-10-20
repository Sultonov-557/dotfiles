-- =============================================================================
-- Hyprland Monitors Configuration
-- =============================================================================
-- Per-hostname monitor layouts: sentinel, vanguard, archbook
local hostname = io.popen("hostname"):read("*l"):gsub("%s+", "")

if hostname == "archbook" then
  hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "0x0",
    scale = "1.25",
  })
elseif hostname == "vanguard" then
  hl.monitor({
    output = "DP-1",
    mode = "2560x1440@165",
    position = "0x0",
    scale = "1.0",
  })
  hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "2560x0",
    scale = "1.0",
  })
elseif hostname == "sentinel" then
  hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@100",
    position = "1920x0",
    scale = "1.0",
  })
  hl.monitor({
    output = "DP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = "1.0",
  })
  hl.workspace_rule({
    workspace = "1",
    monitor = "DP-1",
    default = true,
  })
else
  hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
  })
end
