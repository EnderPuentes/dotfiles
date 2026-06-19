local M = {}

---@param name string
---@param spec vim.api.keyset.highlight
local function hl(name, spec)
  vim.api.nvim_set_hl(0, name, spec)
end

function M.setup_diff_highlights()
  -- diffview, :diffthis, vimdiff
  hl("DiffAdd", { bg = "#1a3d2e", fg = "#9ece6a" })
  hl("DiffDelete", { bg = "#3d1a1a", fg = "#f7768e" })
  hl("DiffChange", { bg = "#3d351a", fg = "#e0af68" })
  hl("DiffText", { bg = "#3d351a", fg = "#e0af68" })

  -- gitsigns gutter + inline hunks
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
  -- Sidebar: slightly recessed from editor (tokyonight Sidebar, or NormalFloat fallback)
  local sidebar = { link = "Sidebar" }
  hl("NeoTreeNormal", sidebar)
  hl("NeoTreeNormalNC", sidebar)
  hl("NeoTreeEndOfBuffer", sidebar)
  hl("NeoTreeSignColumn", { link = "SignColumn" })

  hl("NeoTreeWinSeparator", { link = "WinSeparator" })
  hl("NeoTreeCursorLine", { link = "CursorLine" })
  hl("NeoTreeIndentMarker", { link = "Comment" })
  hl("NeoTreeExpander", { link = "Comment" })
  hl("NeoTreeDimText", { link = "Comment" })
  hl("NeoTreeDotfile", { link = "Comment" })

  hl("NeoTreeDirectoryIcon", { link = "Directory" })
  hl("NeoTreeDirectoryName", { link = "Directory" })
  hl("NeoTreeFileIcon", { link = "Normal" })
  hl("NeoTreeFileName", { link = "Normal" })
  hl("NeoTreeFileNameOpened", { bold = true })
  hl("NeoTreeRootName", { bold = true, italic = true })
  hl("NeoTreeModified", { link = "WarningMsg" })
  hl("NeoTreeFileStats", { link = "Comment" })

  hl("NeoTreeGitAdded", { link = "GitSignsAdd" })
  hl("NeoTreeGitModified", { link = "GitSignsChange" })
  hl("NeoTreeGitDeleted", { link = "GitSignsDelete" })
  hl("NeoTreeGitStaged", { link = "GitSignsAdd" })
  hl("NeoTreeGitUntracked", { link = "Comment", italic = true })
  hl("NeoTreeGitIgnored", { link = "Comment" })
  hl("NeoTreeGitConflict", { link = "ErrorMsg", bold = true })

  hl("NeoTreeTabActive", { bold = true })
  hl("NeoTreeTabInactive", { link = "Comment" })
  hl("NeoTreeTabSeparatorActive", { link = "WinSeparator" })
  hl("NeoTreeTabSeparatorInactive", { link = "WinSeparator" })
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
