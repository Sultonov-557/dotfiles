-- =============================================================================
-- Yazi init.lua — custom behaviors
-- =============================================================================
-- Managed by chezmoi

-- Open files in nvim via `<Enter>` on text files
function Linemode:size()
  local h = 10
  local si = self._file.cha.size
  if not si then
    return "-"
  end
  local units = { "B", "K", "M", "G", "T", "P" }
  for i = #units, 1, -1 do
    local step = 1024 ^ i
    if si >= step then
      return string.format("%.1f%s", si / step, units[i + 1])
    end
  end
  return tostring(si) .. "B"
end

-- Bookmark common directories
function Linemode:bookmark()
  return self._file.url
end
