local u = require("util")
local n = require("null-ls")
local f = require("fun")

--------------------------------------------------
-- null-ls setup
--------------------------------------------------
-- only enable sources that will work.
local sources = f.iter({
	--formatting
	-- u.can_exec("shellharden") and n.builtins.formatting.shellharden.with({ filetypes = { "sh", "zsh", "bash" } }),
	u.can_exec("black") and n.builtins.formatting.black,
	u.can_exec("sbt") and n.builtins.formatting.scalafmt,
	u.can_exec("zig") and n.builtins.formatting.zigfmt,
	u.can_exec("nim") and n.builtins.formatting.nimpretty,
	u.can_exec("stylua") and n.builtins.formatting.stylua,
	--	u.can_exec("lua-format") and n.builtins.formatting.lua_format,
	u.can_exec("prettierd") and n.builtins.formatting.prettierd,
	u.can_exec("prettier") and n.builtins.formatting.prettier,
	u.can_exec("sqlfluff") and n.builtins.formatting.sqlfluff,
	u.can_exec("shfmt") and n.builtins.formatting.shfmt.with({
		filetypes = { "sh", "zsh", "bash" },
		extra_args = {
			"--indent",
			"0",
			"--case-indent",
			"--keep-padding",
			"--language-dialect",
			"bash",
			"--simplify",
		},
	}),
	--diagnostics
	u.can_exec("vale") and n.builtins.diagnostics.vale,
	u.can_exec("shellcheck") and unpack({
		n.builtins.diagnostics.shellcheck,
		n.builtins.code_actions.shellcheck,
	}),
})
	:filter(function(x)
		return x ~= false
	end)
	:totable()
-- if you're here because you're wanting to change 'autostart:false' in
-- :LspInfo, don't worry, that's only for LSPs managed by lspconfig.
-- null-ls starts on its own. see https://github.com/jose-elias-alvarez/null-ls.nvim/discussions/593
n.setup({
	debug = false,
	sources = sources,
	on_attach = require("config.lsp.on_attach"),
})
