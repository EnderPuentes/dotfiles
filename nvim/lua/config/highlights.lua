local M = {}

---@param name string
---@param spec vim.api.keyset.highlight
local function hl(name, spec)
  vim.api.nvim_set_hl(0, name, spec)
end

---@param name string
---@return table
local function get_hl(name)
  local ok, spec = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  return ok and spec or {}
end

function M.setup_diff_highlights()
  hl("DiffAdd", { bg = "#1a3d2e", fg = "#9ece6a" })
  hl("DiffDelete", { bg = "#3d1a1a", fg = "#f7768e" })
  hl("DiffChange", { bg = "#3d351a", fg = "#e0af68" })
  hl("DiffText", { bg = "#3d351a", fg = "#e0af68" })

  hl("GitSignsAdd", { fg = "#9ece6a" })
  hl("GitSignsChange", { fg = "#e0af68" })
  hl("GitSignsDelete", { fg = "#f7768e" })
  hl("GitSignsAddLn", { bg = "#1a3d2e" })
  hl("GitSignsChangeLn", { bg = "#3d351a" })
  hl("GitSignsDeleteLn", { bg = "#3d1a1a" })
  hl("GitSignsAddLnInline", { bg = "#1a3d2e", fg = "#9ece6a" })
  hl("GitSignsChangeLnInline", { bg = "#3d351a", fg = "#e0af68" })
  hl("GitSignsDeleteLnInline", { bg = "#3d1a1a", fg = "#f7768e" })
end

function M.setup_neotree_highlights()
  -- Sidebar base (NeoTreeNormal, tabs) is defined by tokyonight; refine Cursor-like accents only.
  local cursor = get_hl("CursorLine")
  local directory = get_hl("Directory")
  local visual = get_hl("Visual")

  hl("NeoTreeWinSeparator", { link = "WinSeparator" })
  hl("NeoTreeSignColumn", { link = "SignColumn" })
  hl("NeoTreeEndOfBuffer", { link = "NeoTreeNormal" })

  hl("NeoTreeCursorLine", {
    bg = cursor.bg,
    fg = cursor.fg,
    bold = false,
  })

  hl("NeoTreeFileNameOpened", {
    bg = visual.bg,
    fg = directory.fg,
    bold = false,
  })

  hl("NeoTreeIndentMarker", { link = "Comment" })
  hl("NeoTreeExpander", { link = "Comment" })
  hl("NeoTreeDimText", { link = "Comment" })
  hl("NeoTreeDotfile", { link = "Comment" })
  hl("NeoTreeRootName", { link = "Comment" })
  hl("NeoTreeModified", { fg = directory.fg, bold = false })

  hl("NeoTreeGitAdded", { fg = "#73daca" })
  hl("NeoTreeGitModified", { fg = "#e0af68" })
  hl("NeoTreeGitDeleted", { fg = "#f7768e" })
  hl("NeoTreeGitStaged", { fg = "#9ece6a" })
  hl("NeoTreeGitUntracked", { fg = "#73daca" })
  hl("NeoTreeGitUnstaged", { fg = "#e0af68" })
  hl("NeoTreeGitIgnored", { link = "Comment" })
  hl("NeoTreeGitConflict", { fg = "#f7768e", bold = true })
  hl("NeoTreeGitRenamed", { fg = "#7aa2f7" })

  hl("NeoTreeTabActive", { link = "NormalSB" })
  hl("NeoTreeTabInactive", { link = "Comment" })
  hl("NeoTreeTabSeparatorActive", { link = "Comment" })
  hl("NeoTreeTabSeparatorInactive", { link = "Comment" })
end

function M.setup()
  M.setup_diff_highlights()
  M.setup_neotree_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      M.setup_diff_highlights()
      M.setup_neotree_highlights()
    end,
  })
end

return M
