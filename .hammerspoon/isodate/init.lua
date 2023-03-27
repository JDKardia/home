-- Shows a macOS menubar item with the iso date that copies the date into your
-- clip board when you click the menubar item
--
-- uses the date util for date emission

local isoDateMenu = hs.menubar.new()

local refreshIsoDateMenu = function()
	local task = hs.task.new("/bin/date", function(_, stdout)
		date = string.gsub(stdout, "%s$", "") -- strip the \n off the output
		isoDateMenu:setTitle(date)
	end, { "+%Y-%m-%d" })

	task:start()
end

local copyDate = function()
	hs.pasteboard.setContents(isoDateMenu:title())
end

-- Init the menubar entry
isoDateMenu:setTitle("...") -- Loading
isoDateMenu:setClickCallback(copyDate)

-- Read the first value immediately
refreshIsoDateMenu()

-- Refresh the menu every 60 seconds
isoDateRefresh = hs.timer.doEvery(60, refreshIsoDateMenu)
