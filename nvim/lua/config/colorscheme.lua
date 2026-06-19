local M = {}

---@param style? "day" | "night" | "storm" | "moon"
function M.apply(style)
  if not style then
    style = vim.o.background == "light" and "day" or "night"
  end
  require("tokyonight").load({ style = style })
  require("config.highlights").setup()
end

function M.setup()
  M.apply()

  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      M.apply()
    end,
  })
end

return M
