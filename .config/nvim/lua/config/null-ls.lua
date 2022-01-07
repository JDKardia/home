local n = require('null-ls')
local f = require('fun')

local canExec =
  function(executable) return vim.fn.executable(executable) == 1 end
-- only enable sources that will work.
local sources = f.iter({
  canExec('shfmt') and n.builtins.formatting.shfmt,
  canExec('shellharden') and n.builtins.formatting.shellharden,
  canExec('black') and n.builtins.formatting.black,
  canExec('sbt') and n.builtins.formatting.scalafmt,
  canExec('zig') and n.builtins.formatting.zigfmt,
  canExec('nim') and n.builtins.formatting.nimpretty,
  canExec('lua-format') and n.builtins.formatting.lua_format,
}):filter(function(x) return x ~= false end):totable()

n.setup({debug=true, sources=sources})
