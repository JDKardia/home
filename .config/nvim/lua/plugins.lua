--         normally /home/USER/.local/share/nvim/site/pack/packer/start
-- currently set to /home/USER/.local/share/nvim/site/pack/packer/start
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
end

-- auto compile when I edit this file!
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost *.lua source <afile> | PackerCompile
    autocmd BufWritePost config/*.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup {
	function(use)
		use { "wbthomason/packer.nvim" } -- manage ourself
		----------------
		-- Theming --
		----------------
		use { -- love my themes
			"ellisonleao/gruvbox.nvim", -- the original
			--    'mhdahmad/gruvbox.nvim', -- minus lush
			requires = { "rktjmp/lush.nvim" },
			config = function()
				require("gruvbox").setup {
					contrast = "hard",
					inverse = true,
				}
				vim.o.background = "dark"
				vim.cmd([[colorscheme gruvbox]])
			end,
		}
		---------------------
		-- Editor Context  --
		---------------------

		use { "p00f/nvim-ts-rainbow" } -- rainbow brackets

		use { -- syntax highlighting
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("config.treesitter")
			end,
		}

		use { -- indent indicators
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup {
					space_char_blankline = " ",
					show_current_context = true,
					show_current_context_start = true,
				}
			end,
		}
		use { -- sidebar git status indicators
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup { current_line_blame = true }
			end,
		}
		use { "chrisbra/colorizer" } -- hexcode color highlighter

		---------------------
		-- Code Completion --
		---------------------

		use { -- the actual lsp config stuff
			"williamboman/nvim-lsp-installer",
			requires = {
				"neovim/nvim-lspconfig",
				-- lua lsp config
				"folke/lua-dev.nvim",
				-- completion engines
				"hrsh7th/nvim-cmp",
				"jose-elias-alvarez/null-ls.nvim",
				-- completion sources
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"saadparwaiz1/cmp_luasnip",
				-- snippet engine for completion
				"L3MON4D3/LuaSnip",
				"rafamadriz/friendly-snippets",
				-- keymaps
				"mrjones2014/legendary.nvim",
				"folke/which-key.nvim",
				-- library for plugins
				"nvim-lua/plenary.nvim"
			},
			config = function()
				require('config.legend')
				require("luasnip.loaders.from_vscode").lazy_load()
				require("config.lsp")
			end,
		}

		use {
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup {}
			end,
		}
		use {
			"lewis6991/spellsitter.nvim",
			config = function()
				require("spellsitter").setup {
					enable = true,
				}
			end,
		}

		use {
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("trouble").setup {
					auto_open = true,
					auto_close = true,
					auto_preview = false
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				}
			end,
		}

		-----------------
		-- Cleanliness --
		-----------------
		use {
			"907th/vim-auto-save",
			config = function()
				vim.g.auto_save = 1
				vim.g.auto_save_events = { "CursorHold" }
				vim.g.updatetime = 1000
			end,
		}
		use { "tpope/vim-commentary" }
		use { "tpope/vim-surround" }
		use { "tpope/vim-sensible" }
		use { "ntpeters/vim-better-whitespace", config = function()
			vim.g.better_whitespace_operator = '_s'
		end }

		----------------
		-- Navigation --
		----------------
		use { "nvim-lua/popup.nvim" }
		use {
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				local actions = require("telescope.actions")

				require("telescope").setup({
					defaults = {
						mappings = {
							i = {
								["<esc>"] = actions.close,
							},
						},
					},
				})
			end,
		}
		use { 'akinsho/bufferline.nvim',
			tag = "v2.*",
			requires = 'kyazdani42/nvim-web-devicons',
			config = function()
				require("bufferline").setup {
					numbers = function(opts)
						return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
					end,
				}
			end
		}

		use {
			'phaazon/hop.nvim',
			branch = 'v2', -- optional but strongly recommended
			config = function()
				require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
			end
		}

		use {
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require('config.neotree')
			end
		}


		------------------
		-- File Support --
		------------------
		use { "fladson/vim-kitty" }
		use { "ziglang/zig.vim" }
		use { 'SidOfc/mkdx' }
		use {
			"fatih/vim-go",
			config = function()
				vim.g.go_fmt_command = "goimports"
				vim.g.go_fmt_autosave = 0
			end,
		}
		use {
			"nathom/filetype.nvim",
			config = function()
				vim.g.did_load_filetypes = 1
			end,
		}

		----------------------------
		-- Extended Functionality --
		----------------------------
		--tables and alignment
		use { "godlygeek/tabular" }
		use {
			"dhruvasagar/vim-table-mode",
			config = function()
				vim.g.table_mode_corner = "|"
			end,
		}
		use { "gpanders/editorconfig.nvim" }
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = { display = { open_fn = require("packer.util").float } },
}
