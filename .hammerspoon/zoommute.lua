zoomStatusMenuBarItem = hs.menubar.new(nil)
zoomStatusMenuBarItem:setClickCallback(function()
	spoon.Zoom:toggleMute()
end)

updateZoomStatus = function(event)
	hs.printf("updateZoomStatus(%s)", event)
	if (event == "from-running-to-meeting") then
		zoomStatusMenuBarItem:returnToMenuBar()
	elseif (event == "muted") then
		zoomStatusMenuBarItem:setTitle("🔴")
	elseif (event == "unmuted") then
		zoomStatusMenuBarItem:setTitle("🟢")
	elseif (event == "from-meeting-to-running") or (event == "from-running-to-closed") then
		zoomStatusMenuBarItem:removeFromMenuBar()
	end
end

hs.loadSpoon("Zoom")
spoon.Zoom:setStatusCallback(updateZoomStatus)
spoon.Zoom:pollStatus(1)
spoon.Zoom:start()
