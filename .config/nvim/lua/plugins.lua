local install_path = vim.fn.stdpath('data')
  .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

-- auto compile when I edit this file!
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' }) -- manage ourself

    -- lua native plugins
    use({ -- love my themes
      'ellisonleao/gruvbox.nvim',
      requires = { 'rktjmp/lush.nvim' },
      config = function()
        vim.o.termguicolors = true
        vim.o.background = 'dark'
        vim.g.gruvbox_contrast_dark = 'hard'
        vim.cmd('colorscheme gruvbox')
      end,
    })

    use({
      'ms-jpq/coq_nvim',
      branch = 'coq',
      event = 'VimEnter',
      config = function()
        vim.cmd('COQnow --shut-up ')
      end,
    })
    use('williamboman/nvim-lsp-installer')
    use('ray-x/lsp_signature.nvim')
    use({
      'neovim/nvim-lspconfig',
      after = {
        'nvim-lsp-installer',
        'coq_nvim',
        'lsp_signature.nvim',
      },
      config = function()
        -- stylua: ignore start
        local my_servers = {
          'bashls', 'clangd',   'cmake',
          'cssls',  'dockerls', 'dotls',
          'eslint', 'elixirls', 'html',
          'jsonls', 'pyright',  'sumneko_lua',
          'sqlls',  'tsserver', 'vimls',
          'yamlls', 'zls',
        }
        -- stylua: ignore end
        local lsp_installer = require('nvim-lsp-installer')
        local coq = require('coq')
        require('config.lsp').config(lsp_installer,coq,my_servers)
      end,
    })

    use({ -- for filling in the gaps where other servers drop the ball
    "jose-elias-alvarez/null-ls.nvim",
    -- config = function()
    --     require("null-ls").setup()
    -- end,
    requires = { "nvim-lua/plenary.nvim" },
})

    -- 9000+ Snippets
    use({ 'ms-jpq/coq.artifacts', branch = 'artifacts' })
    -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
    -- Need to **configure separately**
    use({ 'ms-jpq/coq.thirdparty', branch = '3p' ,config=function() 
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" }}
    end})

    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          -- one of "all", "maintained" (parsers with maintainers), or a list of languages
          ensure_installed = 'all',
          highlight = {
            enable = true,
            disable = { 'scala', 'jsonc', 'fusion', 'jsonc' },
          },
          rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 2000,
          },
          playground = { enable = true },
        })
      end,
    })

    use({
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() end
    })
    use('nvim-lua/popup.nvim')
    -- use 'p00f/nvim-ts-rainbow'
        use {"lukas-reineke/indent-blankline.nvim", config=function() end}

    -- vim native plugins
    use({
      '907th/vim-auto-save',
      config = function()
        vim.g.auto_save = 1
        vim.g.auto_save_events = { 'CursorHold' }
        vim.g.updatetime = 1000
      end,
    })
    use({ 'SirVer/ultisnips', { 'honza/vim-snippets' } })
    use('mhinz/vim-signify')
    use('ntpeters/vim-better-whitespace')
    use('prettier/vim-prettier')
    use('sbdchd/neoformat')
    use('tpope/vim-commentary')
    use('tpope/vim-sensible')
    use('tpope/vim-surround')
    -- use 'kovisoft/slimv'
    use('fladson/vim-kitty')
    use('ziglang/zig.vim')

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = { display = { open_fn = require('packer.util').float } },
})
