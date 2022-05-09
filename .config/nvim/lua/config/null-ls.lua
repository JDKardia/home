local n = require('null-ls')
local f = require('fun')
local k = require('config/keymapping')
local canExec =
  function(executable) return vim.fn.executable(executable) == 1 end
-- only enable sources that will work.
local sources = f.iter({
  canExec('shfmt') and
    n.builtins.formatting.shfmt.with({filetypes={'sh', 'zsh', 'bash'}}),
  canExec('shellharden') and
    n.builtins.formatting.shellharden.with({filetypes={'sh', 'zsh', 'bash'}}),
  canExec('black') and n.builtins.formatting.black,
  canExec('sbt') and n.builtins.formatting.scalafmt,
  canExec('zig') and n.builtins.formatting.zigfmt,
  canExec('nim') and n.builtins.formatting.nimpretty,
  canExec('lua-format') and n.builtins.formatting.lua_format,
  canExec('prettierd') and n.builtins.formatting.prettierd,
  canExec('sqlfluff') and n.builtins.formatting.sqlfluff,
}):filter(function(x) return x ~= false end):totable()

n.setup({
  debug=true,
  sources=sources,
  on_attach=function(client, bufnr)
    local opts = {noremap=true, silent=true}
    k.setLSPKeyMaps(opts, bufnr)
  end,
})
