-- Shows a macOS menubar item of whether i can currently ping 1.1.1.1

pingMenu = hs.menubar.new()

function refreshPingMenu()
	local task = hs.task.new(
		'/sbin/ping',
		function(_, stdout)
			if string.find(stdout, '0 packets received') then
				pingMenu:setTitle('👎')
			else
				pingMenu:setTitle('👍')
			end
		end,
		{ '-c 1', '-t 2', '1.1.1.1' }
	)

	task:start()
end

-- Init the menu
pingMenu:setTitle("...") -- Loading

-- Read the first value immediately
refreshPingMenu()

-- Refresh the menu every 60 seconds
pingRefresh = hs.timer.doEvery(5, refreshPingMenu)
