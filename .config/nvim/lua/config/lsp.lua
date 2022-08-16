require("nvim-lsp-installer").setup({ automatic_installation = true })

local cmp = require("cmp")
local lsp_config = require("lspconfig")
local luasnip = require("luasnip")
local u = require('util')
local n = require("null-ls")
local f = require("fun")

--------------------------------------------------
-- local globals
--------------------------------------------------

local my_servers = {
	"bashls", "clangd", "cmake",
	"cssls", "dockerls", "dotls",
	"elixirls", "eslint", "gopls",
	"html", "jsonls", "puppet",
	"pyright", "solargraph", "sqlls",
	"sumneko_lua", "terraformls", "tsserver",
	"vimls", "yamlls", "zls",
}

local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true }
	local l = require('legendary')
	l.setup()
	local w = require('which-key')
	w.register({
		["[d"] = { vim.diagnostic.goto_prev, "LSP: go to next diagnostic" },
		["]d"] = { vim.diagnostic.goto_next, "LSP: go to previous diagnostic" },
		K = { vim.lsp.buf.hover, "LSP: show hover context" },
		["<C-k>"] = { vim.lsp.buf.signature_help, "LSP: show signature help" },
		g = {
			d = { vim.lsp.buf.definition, "LSP: go to definition" },
			D = { vim.lsp.buf.declaration, "LSP: go to declaration" },
			i = { vim.lsp.buf.implementation, "LSP: go to implementation" },
			r = { vim.lsp.buf.references, "LSP: show references" },
		},
		["<Leader><Leader>"] = {
			D = { vim.lsp.buf.type_definition, "LSP: show type definition" },
			c = { vim.lsp.buf.code_action, "LSP: code action" },
			e = { vim.diagnostic.open_float, "LSP: open " },
			f = { vim.lsp.buf.formatting_sync, "LSP: format the buffer" },
			r = { vim.lsp.buf.rename, "LSP: rename" },
			w = {
				name = "LSP:workspace",
				a = { vim.lsp.buf.add_workspace_folder, "LSP: add workspace folder" },
				r = { vim.lsp.buf.remove_workspace_folder, "LSP: remove workspace folder" },
			},
		},
	})

	local default_opts = { noremap = true, silent = true }
	l.bind_keymaps {

		{ "<leader><leader>f", vim.lsp.buf.range_formatting, mode = { 'v' },
			description = "LSP: format selected range of the buffer", opts = default_opts },
	}
	l.bind_autocmds {
		{
			'BufWritePre',
			vim.lsp.buf.formatting_sync,
			description = 'Format on write with LSP',
		},
	}

end

--------------------------------------------------
-- nvim-cmp config
--------------------------------------------------

cmp.setup({
	snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
	window = {
		--  completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		-- supertab functionality, which I couldn't replicate in coq_nvim
		["<Tab>"] = cmp.mapping(
			function(fallback)
				if cmp.visible() then cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
					-- elseif u.has_words_before() then cmp.complete()
				else fallback()
				end
			end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(
			function(fallback)
				if cmp.visible() then cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then luasnip.jump(-1)
				else fallback()
				end
			end, { "i", "s" }),
	}),
	sources = cmp.config.sources(
		{ { name = "luasnip" }, { name = "nvim_lsp" }, { name = 'path' }, { name = 'cmdline' } },
		{ { name = 'nvim_lsp_signature_help' }, },
		{ { name = "buffer" } })
})
cmp.mapping.confirm({ select = false })


for cmd, source in pairs({
	['/'] = { sources = { { name = 'buffer' } } },
	[':'] = { sources = { { name = 'cmdline' } } }
}) do
	cmp.setup.cmdline(cmd, source)
end


--------------------------------------------------
-- lsp setup
--------------------------------------------------

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local server_specific_settings = {
	sumneko_lua = { Lua = {
		runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
		diagnostics = { globals = { "vim", "use", "use_rocks" }, disable = { "lowercase-global" } },
		workspace = { library = {
			[vim.fn.expand("$VIMRUNTIME/lua")] = true,
			[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
		} },
	} },
	-- gopls = {
	--   settings = {
	--     gopls = {
	--       env = {
	--         GOPACKAGESDRIVER = '/Users/kardia/stripe/gocode/bin/gopackagesdriver.sh'
	--       },
	--       directoryFilters = {
	--         "-/Users/kardia/stripe/gocode/bazel-bin",
	--         "-/Users/kardia/stripe/gocode/bazel-out",
	--         "-/Users/kardia/stripe/gocode/bazel-testlogs",
	--         "-/Users/kardia/stripe/gocode/bazel-mypkg",
	--         "-/Users/kardia/stripe/gocode/config",
	--       },
	--     },
	--   }
	-- }
}
for _, srv in ipairs(my_servers) do
	lsp_config[srv].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		settings = server_specific_settings[srv] -- nil is okay
	})
end

--------------------------------------------------
-- null-ls setup
--------------------------------------------------
-- only enable sources that will work.
local sources = f.iter({
	--formatting
	u.can_exec("shfmt") and
			n.builtins.formatting.shfmt.with({
				filetypes = { "sh", "zsh", "bash" },
				extra_args = {
					"--indent", "0",
					"--case-indent",
					"--keep-padding",
					"--language-dialect", "bash",
					"--simplify",
				},
			}),
	-- u.can_exec("shellharden") and n.builtins.formatting.shellharden.with({ filetypes = { "sh", "zsh", "bash" } }),
	u.can_exec("black") and n.builtins.formatting.black,
	u.can_exec("sbt") and n.builtins.formatting.scalafmt,
	u.can_exec("zig") and n.builtins.formatting.zigfmt,
	u.can_exec("nim") and n.builtins.formatting.nimpretty,
	-- u.can_exec("stylua") and n.builtins.formatting.stylua,
	u.can_exec("lua-format") and n.builtins.formatting.lua_format,
	u.can_exec("prettierd") and n.builtins.formatting.prettierd,
	u.can_exec("prettier") and n.builtins.formatting.prettier,
	u.can_exec("sqlfluff") and n.builtins.formatting.sqlfluff,
	--diagnostics
	u.can_exec("vale") and n.builtins.diagnostics.vale,
})
		:filter(function(x)
			return x ~= false
		end)
		:totable()

n.setup({
	debug = true,
	sources = sources,
	on_attach = on_attach
})
