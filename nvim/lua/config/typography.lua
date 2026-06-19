local M = {}

---@class TypographyFont
---@field family string Full fontconfig name (Nerd Font patch)
---@field size integer Point size for GUI Neovim
---@field linespace integer Extra pixels between lines (helps icon alignment in Neo-tree)
M.font = {
  -- Same family Cursor uses by default; Nerd Font patch covers file/folder/git icons.
  family = "JetBrainsMono Nerd Font",
  size = 13,
  linespace = 2,
}

function M.setup()
  vim.g.have_nerd_font = true

  vim.opt.linespace = M.font.linespace

  if vim.fn.has("gui_running") == 1 then
    vim.opt.guifont = string.format("%s:h%d", M.font.family, M.font.size)
  end
end

---@return table nvim-web-devicons opts
function M.devicons_opts()
  return {
    strict = true,
    default = true,
    color_icons = true,
    override = {},
  }
end

return M
