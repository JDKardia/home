require('nvim-treesitter.configs').setup({
  -- one of "all", "maintained", or a list of languages
  ensure_installed='all',
  highlight={enable=true, disable={'scala', 'jsonc', 'fusion', 'jsonc'}},
  rainbow={enable=true, extended_mode=true, max_file_lines=2000},
  playground = { enable = true },
})
