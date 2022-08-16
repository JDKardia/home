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
		-------------------
		-- Code Context  --
		-------------------

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
		use { "gpanders/editorconfig.nvim" }

		----------------
		-- Completion --
		----------------
		-- use{ -- crazy fast completion
		-- 	"ms-jpq/coq_nvim",
		-- 	branch = "coq",
		-- 	event = "VimEnter",
		-- 	config = function()
		-- 		vim.g.coq_settings = { display = { ghost_text = { enabled = false }, pum = { fast_close = false } } }
		-- 		vim.cmd("COQnow --shut-up ")
		-- 	end,
		-- }
		-- use{ "ms-jpq/coq.artifacts", branch = "artifacts" } -- 9000+ Snippets
		-- use{ -- lua & third party sources -- See github
		-- 	"ms-jpq/coq.thirdparty",
		-- 	branch = "3p",
		-- 	config = function()
		-- 		require("coq_3p"){ { src = "nvimlua", short_name = "nLUA" } }
		-- 	end,
		-- }

		use { -- the actual lsp config stuff
			"williamboman/nvim-lsp-installer", -- automatically handle installation
			requires = {
				"neovim/nvim-lspconfig",
				{
					"hrsh7th/nvim-cmp",
					requires = {
						"hrsh7th/cmp-nvim-lsp",
						"hrsh7th/cmp-buffer",
						"hrsh7th/cmp-path",
						"hrsh7th/cmp-cmdline",
						"hrsh7th/cmp-nvim-lsp-signature-help",
						{ "saadparwaiz1/cmp_luasnip",
							requires = {
								"L3MON4D3/LuaSnip",
								"rafamadriz/friendly-snippets"
							},
						},
					},
				},
				{ -- for filling in the gaps where other servers drop the ball
					"jose-elias-alvarez/null-ls.nvim",
					requires = { "nvim-lua/plenary.nvim" },
				},
			},
			config = function()
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
		use { "ntpeters/vim-better-whitespace" }

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

		------------------
		-- File Support --
		------------------
		use { "fladson/vim-kitty" }
		use { "ziglang/zig.vim" }
		use {
			"fatih/vim-go",
			config = function()
				vim.g.go_fmt_command = "goimports"
				vim.g.go_fmt_autosave = 0
			end,
		}
		use { 'SidOfc/mkdx' }

		----------------------------
		-- Extended Functionality --
		----------------------------
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

		use { "godlygeek/tabular" }
		-- use {
		--   'dkarter/bullets.vim',
		--   config=function()
		--     vim.g.bullets_enabled_file_types = {
		--       'markdown', 'text', 'gitcommit', 'scratch',
		--     }
		--   end,
		-- }
		use {
			"nathom/filetype.nvim",
			config = function()
				vim.g.did_load_filetypes = 1
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
			"dhruvasagar/vim-table-mode",
			config = function()
				vim.g.table_mode_corner = "|"
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
		use { "mrjones2014/legendary.nvim", requires = {
			"folke/which-key.nvim",
		},
			config = function() require('config.legend') end
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
				-- remove the deprecated commands from v1.x
				vim.g.neo_tree_remove_legacy_commands = 1


				-- If you want icons for diagnostic errors, you'll need to define them somewhere:
				vim.fn.sign_define("DiagnosticSignError",
					{ text = " ", texthl = "DiagnosticSignError" })
				vim.fn.sign_define("DiagnosticSignWarn",
					{ text = " ", texthl = "DiagnosticSignWarn" })
				vim.fn.sign_define("DiagnosticSignInfo",
					{ text = " ", texthl = "DiagnosticSignInfo" })
				vim.fn.sign_define("DiagnosticSignHint",
					{ text = "", texthl = "DiagnosticSignHint" })

				require("neo-tree").setup({
					close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
					popup_border_style = "rounded",
					enable_git_status = true,
					enable_diagnostics = true,
					sort_case_insensitive = false, -- used when sorting files and directories in the tree
					default_component_configs = {
						container = {
							enable_character_fade = true
						},
						indent = {
							indent_size = 2,
							padding = 1, -- extra padding on left hand side
							-- indent guides
							with_markers = true,
							indent_marker = "│",
							last_indent_marker = "└",
							highlight = "NeoTreeIndentMarker",
							-- expander config, needed for nesting files
							with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
							expander_collapsed = "",
							expander_expanded = "",
							expander_highlight = "NeoTreeExpander",
						},
						icon = {
							folder_closed = "",
							folder_open = "",
							folder_empty = "ﰊ",
							-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
							-- then these will never be used.
							default = "*",
							highlight = "NeoTreeFileIcon"
						},
						modified = {
							symbol = "[+]",
							highlight = "NeoTreeModified",
						},
						name = {
							trailing_slash = false,
							use_git_status_colors = true,
							highlight = "NeoTreeFileName",
						},
						git_status = {
							symbols = {
								-- Change type
								added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
								modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
								deleted   = "✖", -- this can only be used in the git_status source
								renamed   = "", -- this can only be used in the git_status source
								-- Status type
								untracked = "",
								ignored   = "",
								unstaged  = "",
								staged    = "",
								conflict  = "",
							}
						},
					},
					window = {
						position = "right",
						width = 40,
						mapping_options = {
							noremap = true,
							nowait = true,
						},
						mappings = {
							["<space>"] = {
								"toggle_node",
								nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
							},
							["<2-LeftMouse>"] = "open",
							["<cr>"] = "open",
							["S"] = "open_split",
							["s"] = "open_vsplit",
							["t"] = "open_tabnew",
							["w"] = "open_with_window_picker",
							["C"] = "close_node",
							["z"] = "close_all_nodes",
							["Z"] = "expand_all_nodes",
							["a"] = {
								"add",
								-- some commands may take optional config options, see `:h neo-tree-mappings` for details
								config = {
									show_path = "none" -- "none", "relative", "absolute"
								}
							},
							["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
							["d"] = "delete",
							["r"] = "rename",
							["y"] = "copy_to_clipboard",
							["x"] = "cut_to_clipboard",
							["p"] = "paste_from_clipboard",
							["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
							-- ["c"] = {
							--  "copy",
							--  config = {
							--    show_path = "none" -- "none", "relative", "absolute"
							--  }
							--}
							["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
							["q"] = "close_window",
							["R"] = "refresh",
							["?"] = "show_help",
							["<"] = "prev_source",
							[">"] = "next_source",
						}
					},
					nesting_rules = {},
					filesystem = {
						filtered_items = {
							visible = false, -- when true, they will just be displayed differently than normal items
							hide_dotfiles = true,
							hide_gitignored = true,
							hide_hidden = true, -- only works on Windows for hidden files/directories
							hide_by_name = {
								--"node_modules"
							},
							hide_by_pattern = { -- uses glob style patterns
								--"*.meta"
							},
							never_show = { -- remains hidden even if visible is toggled to true
								--".DS_Store",
								--"thumbs.db"
							},
						},
						follow_current_file = false, -- This will find and focus the file in the active buffer every
						-- time the current file is changed while the tree is open.
						group_empty_dirs = false, -- when true, empty folders will be grouped together
						hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
						-- in whatever position is specified in window.position
						-- "open_current",  -- netrw disabled, opening a directory opens within the
						-- window like netrw would, regardless of window.position
						-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
						use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
						-- instead of relying on nvim autocmd events.
						window = {
							mappings = {
								["<bs>"] = "navigate_up",
								["."] = "set_root",
								["H"] = "toggle_hidden",
								["/"] = "fuzzy_finder",
								["D"] = "fuzzy_finder_directory",
								["f"] = "filter_on_submit",
								["<c-x>"] = "clear_filter",
								["[g"] = "prev_git_modified",
								["]g"] = "next_git_modified",
							}
						}
					},
					buffers = {
						follow_current_file = true, -- This will find and focus the file in the active buffer every
						-- time the current file is changed while the tree is open.
						group_empty_dirs = true, -- when true, empty folders will be grouped together
						show_unloaded = true,
						window = {
							mappings = {
								["bd"] = "buffer_delete",
								["<bs>"] = "navigate_up",
								["."] = "set_root",
							}
						},
					},
					git_status = {
						window = {
							position = "float",
							mappings = {
								["A"]  = "git_add_all",
								["gu"] = "git_unstage_file",
								["ga"] = "git_add_file",
								["gr"] = "git_revert_file",
								["gc"] = "git_commit",
								["gp"] = "git_push",
								["gg"] = "git_commit_and_push",
							}
						}
					}
				})

				vim.cmd([[nnoremap \ :Neotree toggle<cr>]])
			end
		}

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = { display = { open_fn = require("packer.util").float } },
}
