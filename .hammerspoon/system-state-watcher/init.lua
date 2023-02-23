local bluetooth = require('lib.bluetooth')
local fn = require("hs.fnutils")
local w = require("hs.caffeinate.watcher")

local state_to_behavior = {}
state_to_behavior[w.screensDidLock] = "on_screen_lock"
state_to_behavior[w.screensDidUnlock] = "on_screen_unlock"
state_to_behavior[w.screensDidSleep] = "on_screen_sleep"
state_to_behavior[w.screensDidWake] = "on_screen_wake"
state_to_behavior[w.systemWillSleep] = "on_system_sleep"
state_to_behavior[w.systemDidWake] = "on_system_wake"
state_to_behavior[w.systemWillPowerOff] = "on_system_poweroff"
state_to_behavior[w.sessionDidResignActive] = "on_session_resign"
state_to_behavior[w.sessionDidBecomeActive] = "on_session_resume"
state_to_behavior[w.screensaverDidStart] = "on_screensaver_start"
state_to_behavior[w.screensaverWillStop] = "on_screensaver_will_stop"
state_to_behavior[w.screensaverDidStop] = "on_screensaver_stopped"

-- list of tuples, where:
--   tuple[1] is the behavior name to execute callback,
--   tuple[2] is the callback to be executed,
local state_behaviors = {
	{ "on_screen_lock", bluetooth.disable },
	{ "on_screen_unlock", bluetooth.enable },
}


local state_watcher = w.new(function(state)
	local behavior = state_to_behavior[state]
	local behaviors_to_exec = fn.filter(state_behaviors, function(entry)
		return entry[1] == behavior
	end)
	if #behaviors_to_exec ~= 0 then
		print('state_change ' .. behavior .. ":")

	end
	fn.each(behaviors_to_exec, function(entry)
		print("  " .. entry[2]())
	end)

end)

state_watcher:start()
