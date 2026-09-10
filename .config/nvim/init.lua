-- General Options
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.cursorline = false
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8

-- Load Wallust Theme / Colorscheme
local ok, _ = pcall(require, "colors")
if not ok then
  -- Fallback if wallust hasn't generated colors.lua yet
  vim.cmd("colorscheme default")
end
