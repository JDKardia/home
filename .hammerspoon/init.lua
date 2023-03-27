require("hs.ipc")
require("config-autoloader")
require("isodate")
require("ping")
-- require("system-state-watcher")
-- require("zoommute")
stackline = require("stackline")
stackline:init()

--local rb = hs.loadSpoon("recursiveBinder")
-- local b = hs.hotkey.bind

-- local state = {}

-- local coop 	= { "ctrl", "alt" }         -- COOP = COntrol OPtion
-- local cool 	= { "ctrl", "alt", "cmd" }  -- COOL = Command Option contrOL
-- local hyper = { "ctrl", "alt", "cmd", "shift" }

-- Next up:
-- b(cool, 'm',function() z:toggleMute() end)
-- b(cool, 'm',z.toggleMute)
-- -- This lets you click on the menu bar item to toggle the mute state
