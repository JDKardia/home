-- normally /home/USER/.local/share/nvim/site/pack/packer/start
local install_path = vim.fn.stdpath('data') ..
                       '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

-- auto compile when I edit this file!
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost config/*.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup({
  function(use)
    use {'wbthomason/packer.nvim'} -- manage ourself

    -- rocks I use
    use_rocks {'fun', 'inspect'}

    ----------------
    -- Theming --
    ----------------
    use { -- love my themes
      'ellisonleao/gruvbox.nvim', -- the original
      --    'mhdahmad/gruvbox.nvim', -- minus lush
      requires={'rktjmp/lush.nvim'},
      config=function()
        vim.o.termguicolors = true
        vim.o.background = 'dark'
        vim.g.gruvbox_contrast_dark = 'hard'
        vim.cmd('colorscheme gruvbox')
      end,
    }
    -------------------
    -- Code Context  --
    -------------------

    use 'p00f/nvim-ts-rainbow'

    use {
      'nvim-treesitter/nvim-treesitter',
      run=':TSUpdate',
      config=function()
        require('nvim-treesitter.configs').setup({
          -- one of "all", "maintained", or a list of languages
          ensure_installed='all',
          highlight={enable=true, disable={'scala', 'jsonc', 'fusion', 'jsonc'}},
          rainbow={enable=true, extended_mode=true, max_file_lines=2000},
          playground={enable=true},
        })
      end,
    }

    use {
      'lukas-reineke/indent-blankline.nvim',
      config=function()
        require('indent_blankline').setup({
          space_char_blankline=' ',
          show_current_context=true,
          show_current_context_start=true,
        })
      end,
    }
    use {
      'lewis6991/gitsigns.nvim',
      requires={'nvim-lua/plenary.nvim'},
      config=function()
        require('gitsigns').setup({current_line_blame=true})
      end,
    }
    use 'chrisbra/colorizer'

    ----------------
    -- Completion --
    ----------------
    use { -- crazy fast completion
      'ms-jpq/coq_nvim',
      branch='coq',
      event='VimEnter',
      config=function()
        vim.g.coq_settings = {display={ghost_text={enabled=false}}}
        vim.cmd('COQnow --shut-up ')
      end,
    }
    use {'ms-jpq/coq.artifacts', branch='artifacts'} -- 9000+ Snippets
    use { -- lua & third party sources -- See github
      'ms-jpq/coq.thirdparty',
      branch='3p',
      config=function()
        require('coq_3p')({{src='nvimlua', short_name='nLUA'}})
      end,
    }
    use 'williamboman/nvim-lsp-installer' -- automatically handle installation
    use 'ray-x/lsp_signature.nvim' -- provides a signature box for lsp
    use { -- the actual lsp config stuff
      'neovim/nvim-lspconfig',
      after={'nvim-lsp-installer', 'coq_nvim', 'lsp_signature.nvim'},
      config=function() require('config.lsp') end,
    }
    use { -- for filling in the gaps where other servers drop the ball
      'jose-elias-alvarez/null-ls.nvim',
      requires={'nvim-lua/plenary.nvim'},
      rocks={'fun'},
      config=function() require('config.null-ls') end,
    }
    use 'windwp/nvim-autopairs'

    -----------------
    -- Cleanliness --
    -----------------
    use {
      '907th/vim-auto-save',
      config=function()
        vim.g.auto_save = 1
        vim.g.auto_save_events = {'CursorHold'}
        vim.g.updatetime = 1000
      end,
    }
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-sensible'
    use 'ntpeters/vim-better-whitespace'

    ----------------
    -- Navigation --
    ----------------
    use 'nvim-lua/popup.nvim'
    use {
      'nvim-telescope/telescope.nvim',
      requires={'nvim-lua/plenary.nvim'},
      config=function()
        -- SOMETHING HERE SOMEDAY
      end,
    }

    ------------------
    -- File Support --
    ------------------
    use 'fladson/vim-kitty'
    use 'ziglang/zig.vim'

    ----------------------------
    -- Extended Functionality --
    ----------------------------
    use 'godlygeek/tabular'
    use {
      'dkarter/bullets.vim',
      config=function()
        vim.g.bullets_enabled_file_types = {
          'markdown', 'text', 'gitcommit', 'scratch',
        }
      end,
    }

    if packer_bootstrap then require('packer').sync() end
  end,
  config={display={open_fn=require('packer.util').float}},
})
