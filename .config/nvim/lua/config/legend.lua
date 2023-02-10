local l = require("legendary")
local w = require("which-key")
local h = require("legendary.toolbox")
l.setup()
w.setup({
	window = { border = "single" },
})
local base_keymap = {
	["<leader>"] = {
		-- {{{
		s = {
			":source $HOME/.config/nvim/init.lua | source $HOME/.config/nvim/plugin/packer_compiled.lua<CR>",
			"source vimrc",
		},
		m = { h.lazy_required_fn("hop", "hint_words", {}), "move to word in buffer" },
		n = {
			function()
				vim.api.nvim_put({ "## " .. os.date("%Y-%m-%d") }, "l", true, true)
			end,
			"insert markdown heading with today's date",
		},
		f = {
			name = "telescope",
			f = { require("telescope.builtin").find_files, "find file" },
			g = { require("telescope.builtin").live_grep, "find string" },
			b = { require("telescope.builtin").buffers, "find buffer" },
			h = { require("telescope.builtin").help_tags, "find help" },
		},
		x = {
			name = "trouble",
			x = { "<cmd>TroubleToggle<cr>", "open trouble tray" },
			w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "toggle trouble tray for workspace diagnostics" },
			d = { "<cmd>TroubleToggle document_diagnostics<cr>", "toggle trouble tray for document diagnostics" },
			q = { "<cmd>TroubleToggle quickfix<cr>", "toggle trouble tray for quickfixes" },
			l = { "<cmd>TroubleToggle loclist<cr>", "toggle trouble tray for loclist" },
			r = { "<cmd>TroubleToggle lsp_references<cr>", "toggle trouble tray for lsp_references" },
		},
		--buffers
		b = {
			name = "buffers",
			["1"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 1, true), "go to buffer 1" },
			["2"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 2, true), "go to buffer 2" },
			["3"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 3, true), "go to buffer 3" },
			["4"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 4, true), "go to buffer 4" },
			["5"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 5, true), "go to buffer 5" },
			["6"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 6, true), "go to buffer 6" },
			["7"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 7, true), "go to buffer 7" },
			["8"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 8, true), "go to buffer 8" },
			["9"] = { h.lazy_required_fn("bufferline", "go_to_buffer", 9, true), "go to buffer 9" },
			["0"] = { h.lazy_required_fn("bufferline", "go_to_buffer", -1, true), "go to last buffer" },
			n = { h.lazy_required_fn("bufferline", "cycle", 1), "go to next buffer" },
			p = { h.lazy_required_fn("bufferline", "cycle", -1), "go to prev buffer" },
			d = { require("bufferline").close_with_pick, "select and delete buffer" },
		},
		--}}}
	},
}

local which_keymap = {
	[""] = base_keymap,
	v = base_keymap,
}

w.register(which_keymap, {})

local default_opts = { noremap = true, silent = true }
local non_which_keymaps = {
	-- My Custom
	{ "jk", "<esc>", mode = { "i" }, description = "escape!", opts = default_opts },
	{ "kj", "<esc>", mode = { "i" }, description = "escape!", opts = default_opts },
	{ "<leader>y", '"+y', mode = { "n", "v" }, description = "yank into global clipboard", opts = default_opts },
	{ "<leader>p", '"+p', mode = { "n", "v" }, description = "put into global clipboard", opts = default_opts },
	{
		"<leader>m",
		h.lazy_required_fn("hop", "hint_words", {}),
		mode = { "n", "v" },
		description = "hop to word in buffer",
		opts = default_opts,
	},
}
l.keymaps(non_which_keymaps)

local commands = {
	{ ":Wq", ":wq", description = "aliases for sane exiting when I'm moving too fast" },
	{ ":WQ", ":wq", description = "aliases for sane exiting when I'm moving too fast" },
	{ ":Q", ":q", description = "aliases for sane exiting when I'm moving too fast" },
}
l.commands(commands)
