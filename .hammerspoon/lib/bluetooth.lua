local ht = require("hs.task")
local M = {}
local function checkResult(rc, stderr, stdout)
	if rc ~= 0 then
		print(string.format("Unexpected result executing `blueutil`: rc=%d stderr=%s stdout=%s", rc, stderr, stdout))
	end
end

local function enable()
	local t = ht.new("/opt/homebrew/bin/blueutil", checkResult, { "--power", "on" })
	t:start()
	return "bluetooth: enabling"
end

local function disable()
	local t = ht.new("/opt/homebrew/bin/blueutil", checkResult, { "--power", "off" })
	t:start()
	return "bluetooth: disabling"
end

M.enable = enable
M.disable = disable

return M
