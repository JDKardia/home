require("nvim-lsp-installer").setup({ automatic_installation = true })
local f = require("fun")
local lspconfig = require("lspconfig")

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
	on_attach = require("config.lsp.on_attach"),
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
})
--configure cmp
require("config.lsp.cmp")
--configure null-ls
require("config.lsp.null-ls")

--------------------------------------------------
-- lsp setup
--------------------------------------------------
--
--
require("neodev").setup({})
local capability_base = vim.lsp.protocol.make_client_capabilities()

local custom_configs = {
	terraformls = {
		filetypes = { "terraform", "hcl" },
	},
	sumneko_lua = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				format = { enable = false },
			},
		},
	},
	jsonnet_ls = {
		root_dir = lspconfig.util.root_pattern("config.jsonnet", "gmailctl.libsonnet"),
	},
}
-- my servers
f.iter({
	"clangd",
	"cmake",
	"cssls",
	"dockerls",
	"dotls",
	"elixirls",
	"eslint",
	"gopls",
	"html",
	"jsonls",
	"jsonnet_ls",
	"puppet",
	"pyright",
	"solargraph",
	"sqlls",
	-- "lua_ls",
	-- "sumneko_lua",
	-- "terraformls",
	-- "tsserver",
	"vimls",
	"yamlls",
	-- "zls",
}):each(function(srv)
	lspconfig[srv].setup(custom_configs[srv] or {})
end)
