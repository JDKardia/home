local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			-- return client.name == "null-ls"
			return true
		end,
		bufnr = bufnr,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	local l = require("legendary")
	l.setup()
	local w = require("which-key")
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
			f = { vim.lsp.buf.format, "LSP: format the buffer" },
			r = { vim.lsp.buf.rename, "LSP: rename" },
			w = {
				name = "LSP:workspace",
				a = { vim.lsp.buf.add_workspace_folder, "LSP: add workspace folder" },
				r = { vim.lsp.buf.remove_workspace_folder, "LSP: remove workspace folder" },
			},
		},
	})

	local opts = { noremap = true, silent = true }
	l.keymaps({
		{
			"<leader><leader>f",
			vim.lsp.buf.format,
			mode = { "v" },
			description = "LSP: format selected range of the buffer",
			opts = opts,
		},
	})

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end
end

return on_attach
