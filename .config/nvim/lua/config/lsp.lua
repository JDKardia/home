k = require('config/keymapping')
-- LuaFormatter off
local my_servers = {
  'bashls', 'clangd',   'cmake',
  'cssls',  'dockerls', 'dotls',
  'eslint', 'elixirls', 'html',
  'jsonls', 'pyright',  'sumneko_lua',
  'sqlls',  'tsserver', 'vimls',
  'yamlls',  'zls',
}


local generate_on_attach = function()
  return function(client, bufnr)
    -- handle formatting elsewhere (null-ls
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    -- configure signature presence
    require('lsp_signature').on_attach({
      bind=true, -- This is mandatory, otherwise border config won't get registered.
      floating_window=true,
      handler_opts={border='single'},
      zindex=99, -- <100 so that it does not hide completion popup.
      fix_pos=false, -- Let signature window change its position when needed, see GH-53
      toggle_key='<M-x>', -- Press <Alt-x> to toggle signature on and off.
    })
    -- stylua: ignore start
    local opts = {noremap=true, silent=true}
    -- Hot Key Mappings.
    k.setLSPKeyMaps(opts,bufnr)
  end
end

local server_configs = {
  sumneko_lua = {
    settings = {
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
}
}

local lsp_installer = require('nvim-lsp-installer')
local coq = require('coq')
-- See `:help vim.lsp.*` for documentation on any of the below functions
lsp_installer.on_server_ready(function(server)
    local config = server_configs[server.name] or {}

    config.on_attach = generate_on_attach()
    config.capabilities = vim.lsp.protocol.make_client_capabilities()
  -- This setup function is exactly the same lspconfig's setup function
  -- (:help lspconfig-quickstart)
  server:setup(coq.lsp_ensure_capabilities(config))
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
