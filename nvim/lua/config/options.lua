local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.wrap = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"

-- JetBrains Mono for GUI clients (Neovide, gvim). Terminal font is set by the emulator.
if vim.fn.has("gui_running") == 1 then
  opt.guifont = "JetBrainsMono Nerd Font:h13"
end
