-- LuaFormatter off
local my_servers = {
  'bashls', 'clangd',   'cmake',
  'cssls',  'dockerls', 'dotls',
  'eslint', 'elixirls', 'html',
  'jsonls', 'pyright',  'sumneko_lua',
  'sqlls',  'tsserver', 'vimls',
  'yamlls',  'zls',
}
-- LuaFormatter on
local generate_on_attach = function()
  return function(client, bufnr)
    -- handle formatting
    client.resolved_capabilities.document_formatting = false

    -- configure signature presence
    require('lsp_signature').on_attach({
      bind=true, -- This is mandatory, otherwise border config won't get registered.
      floating_window=true,
      handler_opts={border='single'},
      zindex=99, -- <100 so that it does not hide completion popup.
      fix_pos=false, -- Let signature window change its position when needed, see GH-53
      toggle_key='<M-x>', -- Press <Alt-x> to toggle signature on and off.
    })
    -- Hot Key Mappings.
    -- stylua: ignore start
    local opts = {noremap=true, silent=true}
    local keymaps = {
      {'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts},
      {'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts},
      {'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts},
      {'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts},
      {'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts},
      {
        'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
        opts,
      },
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
end

local lsp_installer = require('nvim-lsp-installer')
local coq = require('coq')
-- See `:help vim.lsp.*` for documentation on any of the below functions
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach=generate_on_attach(),
    capabilities=vim.lsp.protocol.make_client_capabilities(),
  }

  if server.name == 'sumneko_lua' then
    opts.settings = {
      Lua={
        runtime={version='LuaJIT', path=vim.split(package.path, ';')},
        diagnostics={
          globals={'vim', 'use', 'use_rocks'},
          disable={'lowercase-global'},
        },
        workspace={
          library={
            [vim.fn.expand('$VIMRUNTIME/lua')]=true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')]=true,
          },
        },
      },
    }
  end
  -- This setup function is exactly the same lspconfig's setup function
  -- (:help lspconfig-quickstart)
  server:setup(coq.lsp_ensure_capabilities(opts))
  vim.cmd([[ do User LspAttachBuffers ]])
end)

-- Automatically install if a required LSP server is missing.
for _, lsp_name in ipairs(my_servers) do
  local ok, server = lsp_installer.get_server(lsp_name)
  if ok and not server:is_installed() then
    vim.defer_fn(function()
      -- server:install()   -- headless
      lsp_installer.install(lsp_name) -- with UI (so that users can be notified)
    end, 0)
  end
end
