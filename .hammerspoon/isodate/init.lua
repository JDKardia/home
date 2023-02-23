-- Shows a macOS menubar item with how much isoDate I've drank today.
-- Uses my `bin/daily` script to get the values.

isoDateMenu = hs.menubar.new()

local function refreshIsoDateMenu()
  local task = hs.task.new(
  '/bin/date',
    function (_, stdout)
      date = string.gsub(stdout, "%s$", "") -- strip the \n off the output
      isoDateMenu:setTitle(date)
    end,
    {'+%Y-%m-%d'}
  )

  task:start()
end

-- Init the menu
isoDateMenu:setTitle("...") -- Loading

-- Read the first value immediately
refreshIsoDateMenu()

-- Refresh the menu every 60 seconds
isoDateRefresh = hs.timer.doEvery(60, refreshIsoDateMenu)
