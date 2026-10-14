-- =============================================================================
-- Hyprland Animations: "Kinetic Snap"
-- =============================================================================
-- Zero perceived lag, crisp tactile spring curves tuned for high refresh rates

-- Bezier curves
hl.curve("overshoot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("snappy", { type = "bezier", points = { { 0.2, 0.85 }, { 0.32, 1.0 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("quickSpring", { type = "bezier", points = { { 0.1, 1 }, { 0.1, 1.05 } } })

-- Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.0, bezier = "easeOutQuint" })

-- Windows: pop open tactilely, close instantly
hl.animation({ leaf = "windows", enabled = true, speed = 3.8, bezier = "overshoot", style = "popin 85%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.8, bezier = "overshoot", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.6, bezier = "linear", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, bezier = "snappy" })

-- Fading
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.2, bezier = "quick" })

-- Layers (HUDs, Menus, DankMaterialShell)
hl.animation({ leaf = "layers", enabled = true, speed = 2.2, bezier = "quick" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.2, bezier = "quick", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.8, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.4, bezier = "almostLinear" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.2, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.2, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.0, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.0, bezier = "quickSpring", style = "slidevert" })
