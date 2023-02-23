local nsc = require("nvim-surround.config")

local function unwrap_cstr(cstr)
	local left, right = string.match(cstr, "(.*)%%s(.*)")
	assert(
		(left or right),
		string.format("[config] Invalid commentstring - %q. Run ':h commentstring' for help.", cstr)
	)
	return vim.trim(left), vim.trim(right)
end
local gen_fold_comments = function()
	local left = "{{{" --}}} to prevent it being read as a fold
	local right = "}}}"
	local left_cs, right_cs = unwrap_cstr(vim.bo.commentstring)
	if left_cs then
		left = left_cs .. " " .. left
		right = left_cs .. " " .. right
	end
	if right_cs then
		left = left .. " " .. right_cs
		right = right .. " " .. right_cs
	end
	-- {{{
	return { { vim.trim(left) }, { vim.trim(right) } }
	-- }}}
end

require("nvim-surround").setup({
	keymaps = { --sandwich style surrounds
		insert = "<C-g>s",
		insert_line = "<C-g>S",
		normal = "s",
		normal_cur = "ss",
		normal_line = "S",
		normal_cur_line = "SS",
		visual = "s",
		visual_line = "S",
		delete = "sd",
		change = "sc",
	},
	surrounds = {
		["z"] = { --custom surround to add fold markers
			add = function()
				local result = gen_fold_comments()
				-- {{{
				print(vim.inspect(result))
				-- }}}
				return result
			end,
			find = function() end,
			delete = function() end,
		},
		["b"] = { --custom surround to add triple backtick surrounds
			add = { "```", "```" },
		},
	},
	aliases = {
		["a"] = false,
		["b"] = false,
		["B"] = false,
		["r"] = false,
		["q"] = { '"', "'", "`" },
		["s"] = { "}", "]", ")", ">", '"', "'", "`" },
	},
})
