--       default: /home/USER/.local/share/nvim/site/pack/packer/start
-- current value: /home/USER/.local/share/nvim/site/pack/packer/start
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local config_path = vim.fn.stdpath("config")
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = {
		config_path .. "/*.lua",
		config_path .. "/lua/*.lua",
		config_path .. "/lua/*/*.lua",
		config_path .. "/lua/*/*/*.lua",
	},
	command = "source <afile> | PackerCompile",
	-- callback = function(args)
	-- 	require('packer').compile(args)
	-- end
})

return require("packer").startup({
	function(use)
		use({ "wbthomason/packer.nvim" }) -- manage ourself
		use({ "tweekmonster/startuptime.vim" }) --startup time profiler
		----------------
		-- Theming --
		----------------
		use({ -- love my themes
			"ellisonleao/gruvbox.nvim", -- the original
			--    'mhdahmad/gruvbox.nvim', -- minus lush
			requires = { "rktjmp/lush.nvim" },
			config = function()
				-- is changed by an external script, don't rename
				local script_owned_darkmode = true
				if script_owned_darkmode then
					vim.o.background = "dark"
				else
					vim.o.background = "light"
				end
				require("gruvbox").setup({
					contrast = "hard",
					inverse = true,
				})
				vim.cmd([[colorscheme gruvbox]])
			end,
		})
		---------------------
		-- Editor Context  --
		---------------------

		use("p00f/nvim-ts-rainbow") -- rainbow brackets
		use("chrisbra/colorizer") -- hexcode color highlighter

		use({ -- syntax highlighting
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			requires = "JoosepAlviste/nvim-ts-context-commentstring",
			config = function()
				require("config.treesitter")
			end,
		})
		use("nvim-treesitter/nvim-treesitter-textobjects")

		use({ "somini/vim-textobj-fold", requires = "kana/vim-textobj-user" })

		use({ -- indent indicators
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					space_char_blankline = " ",
					show_current_context = true,
					show_current_context_start = true,
				})
			end,
		})
		use({ -- sidebar git status indicators
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup({ current_line_blame = true })
			end,
		})

		---------------------
		-- Code Completion --
		---------------------
		use({
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({})
			end,
		})

		use({ -- the actual lsp config stuff
			"williamboman/nvim-lsp-installer",
			requires = {
				"neovim/nvim-lspconfig",
				-- lua lsp config
				"folke/neodev.nvim",
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
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("config.legend")
				require("luasnip.loaders.from_vscode").lazy_load()
				require("config.lsp")
			end,
		})

		use({ -- auto pair completion
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup({})
			end,
		})
		use({ -- spellchecker
			"lewis6991/spellsitter.nvim",
			config = function()
				require("spellsitter").setup({
					enable = true,
				})
			end,
		})

		use({ -- lsp issue pane
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("trouble").setup({
					auto_open = false,
					auto_close = false,
					auto_preview = false,
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				})
			end,
		})

		-----------------
		-- Cleanliness --
		-----------------
		use({ -- auto save setup
			"907th/vim-auto-save",
			config = function()
				vim.g.auto_save = 1
				vim.g.auto_save_events = { "CursorHold" }
				vim.g.updatetime = 1000
			end,
		})
		-- use({ "tpope/vim-commentary" }) --commenting commands
		--
		use({
			"numToStr/Comment.nvim",
			after = "nvim-ts-context-commentstring",
			config = function()
				require("Comment").setup({
					pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
				})
			end,
		})

		use({ -- surround commands
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
			after = { "vim-textobj-fold" },
			config = function()
				require("config.surround")
			end,
		})
		use({ "tpope/vim-sensible" }) --the basics
		use({ -- commands to manipulate whitespace
			"ntpeters/vim-better-whitespace",
			config = function()
				vim.g.better_whitespace_operator = "_s"
			end,
		})

		----------------
		-- Navigation --
		----------------
		use({ "nvim-lua/popup.nvim" })
		use({ -- fzf but neovim
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
		})
		use({ -- a tab bar of buffers
			"akinsho/bufferline.nvim",
			tag = "v2.*",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("bufferline").setup({})
			end,
		})

		use({ -- leap by characters
			"phaazon/hop.nvim",
			branch = "v2", -- optional but strongly recommended
			config = function()
				require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
			end,
		})

		use({ -- file tree
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("config.neotree")
			end,
		})

		------------------
		-- File Support --
		------------------
		-- File types for:
		use({ "fladson/vim-kitty" }) -- kitty terminal config
		use({ "ziglang/zig.vim" }) -- zig lang
		use({ "cappyzawa/starlark.vim" }) -- starlark config lang

		-- Fat Plugins for:
		use({ --  go lang
			"fatih/vim-go",
			config = function()
				vim.g.go_fmt_command = "goimports"
				vim.g.go_fmt_autosave = 0
			end,
		})

		-- Replace legacy filetype system with a faster one
		use({
			"nathom/filetype.nvim",
			config = function()
				require("config.filetype")
			end,
		})
		----------------------------
		-- Extended Functionality --
		----------------------------

		--tables and alignment
		use({ "inkarkat/vim-AdvancedSorters", requires = {
			"inkarkat/vim-ingo-library",
		} })
		use({ "godlygeek/tabular" })
		use({ "gpanders/editorconfig.nvim" })

		use({
			"Pocco81/true-zen.nvim",
			config = function()
				local width = 0
				require("true-zen").setup({
					modes = { -- configurations per mode
						ataraxis = {
							shade = "dark", -- `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
							backdrop = 0.10, -- percentage padding windows be dimmed/brightened. ex. 0.10
							minimum_writing_area = { -- minimum size of main window
								width = 90,
								height = 90,
							},
							padding = { -- padding windows
								left = 100,
								right = 100,
								top = 0,
								bottom = 0,
							},
							callbacks = { -- run functions when opening/closing Ataraxis mode
								open_pre = function()
									vim.o.colorcolumn = "" -- solid healthy line lengths
									width = vim.o.textwidth
									vim.o.textwidth = 88
								end,
								open_pos = nil,
								close_pre = nil,
								close_pos = function()
									vim.o.colorcolumn = "88,100" -- solid healthy line lengths
									vim.o.textwidth = width
								end,
							},
						},
					},
				})
			end,
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = { display = { open_fn = require("packer.util").float } },
})
