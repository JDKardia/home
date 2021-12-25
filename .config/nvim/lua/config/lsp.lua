local LSP = {}
LSP.lsp_on_attach = function(client, bufnr)
  -- configure signature presence
  require('lsp_signature').on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window = true,
    handler_opts = {
      border = 'single',
    },
    zindex = 99, -- <100 so that it does not hide completion popup.
    fix_pos = false, -- Let signature window change its position when needed, see GH-53
    toggle_key = '<M-x>', -- Press <Alt-x> to toggle signature on and off.
  })
    -- Hot Key Mappings.
    -- stylua: ignore start
    local opts = { noremap = true, silent = true }
    local keymaps = {
      {'n', 'gD',        '<cmd>lua vim.lsp.buf.declaration()<CR>', opts},
      {'n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<CR>', opts},
      {'n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>', opts},
      {'n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>', opts},
      {'n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts},
      {'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts},
      {'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts},
      {'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts},
      {'n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts},
      {'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts},
      {'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts},
      {'n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>', opts},
      {'n', '<space>e',  '<cmd>lua vim.diagnostic.open_float()<CR>', opts},
      {'n', '[d',        '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts},
      {'n', ']d',        '<cmd>lua vim.diagnostic.goto_next()<CR>', opts},
      {'n', '<space>q',  '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts},
    }
  -- stylua: ignore end
  for _, kmap in ipairs(keymaps) do
    vim.api.nvim_buf_set_keymap(bufnr, unpack(kmap))
  end
end

LSP.config = function(lsp_installer, coq, my_servers)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = LSP.lsp_on_attach,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
    }

    if server.name == 'sumneko_lua' then
      opts.settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
                path = vim.split(package.path, ";"),
          },
              diagnostics = {
                globals = {"vim", "use"},
                disable = {"lowercase-global"}
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
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
end

return LSP
