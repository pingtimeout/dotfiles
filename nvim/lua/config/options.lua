-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Do not use system clipboard by default
vim.opt.clipboard = ""

-- Enable list mode by default but only show tabs and trailing whitespaces
vim.opt.list = true
vim.opt.listchars = {
  tab = ">-",
  trail = "·",
}
