local setLSPKeyMaps = function(opts, bufnr)
  local keymaps = {
    {'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts},
    {'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts},
    {'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts},
    {'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts},
    {'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts},
    {'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts},
    {
      'n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
      opts,
    }, {
      'n', '<Leader>wl',
      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      opts,
    }, {'n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts},
    {'n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts},
    {'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts},
    {'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts},
    {'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts},
    {'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts},
    {'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts},
    {'n', '<Leader>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts},
    {'n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', opts},
    {'v', '<Leader>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts},
  }
  -- stylua: ignore end
  for _, kmap in ipairs(keymaps) do
    vim.api.nvim_buf_set_keymap(bufnr, unpack(kmap))
  end

end

return {setLSPKeyMaps=setLSPKeyMaps}
