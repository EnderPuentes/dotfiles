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

function M.setup()
  M.setup_diff_highlights()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = M.setup_diff_highlights,
  })
end

return M
