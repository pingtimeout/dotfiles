-- ~/.config/nvim/after/ftplugin/asciidoctor.lua
-- Filetype-local tweaks for AsciiDoc buffers (habamax/vim-asciidoctor sets filetype=asciidoctor).

_G.__asciidoctor_reflow_opfunc = function(_)
  vim.cmd("'[,']join")
  vim.cmd([['[,']s/\v([.!?]"*)\zs\s+\ze(\u|["(])/\r/g]])
end

local function reflow_go()
  vim.o.operatorfunc = "v:lua.__asciidoctor_reflow_opfunc"
  return "g@"
end

vim.keymap.set({ "n", "x" }, "gr", reflow_go, {
  buffer = true,
  expr = true,
  desc = "Reflow: one sentence per line",
})

vim.keymap.set("n", "grr", function()
  return reflow_go() .. "_"
end, {
  buffer = true,
  expr = true,
  desc = "Reflow current line: one sentence per line",
})
