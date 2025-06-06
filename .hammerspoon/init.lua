-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter {})
-- hs.hotkey.bind({ "cmd", "alt" }, "tab", function()
--     switcher_space:next()
-- end)

-- screen = hs.screen.allScreens()
-- { [1] = hs.screen: DELL S3221QS (0x600002b0b538),[2] = hs.screen: Built-in Retina Display (0x600002b0bd78),}
-- screen[1]:getUUID()
-- hs.spaces.allSpaces()
-- -- {
-- --   ["37D8832A-2D66-02CA-B9F7-8F30A301B230"] = { 220 },
-- --   ["BE8A8F54-2079-4108-8F83-AFF53F7BB009"] = { 1, 3 }
-- -- }
-- hs.spaces.windowsForSpace(3)
-- -- { 34023, 23558, 173, 172, 169, 120, 17911, 119, 992, 192, 177, 184, 181, 118, 33467, 34027, 34229, 33735, 34224, 33874, 33734, 33824, 33739, 171, 135, 2633, 10782, 10784, 10787, 10789, 10791, 10793, 10795, 10873, 11007, 11008, 11034, 16461, 34226 }
-- result = hs.spaces.missionControlSpaceNames()
-- -- {
-- --   ["101166BF-8D92-4B72-AABF-307BBEB89A66"] = {
-- --     [1] = "Desktop 1",
-- --     [3] = "Desktop 2"
-- --   },
-- --   ["37D8832A-2D66-02CA-B9F7-8F30A301B230"] = {
-- --     [237] = "Desktop 3"
-- --   }
-- -- }

require('utils')

local function getSmallestScreen()
    local screens = hs.screen.allScreens()
    local result = screens[0]
    local minScreenSize = nil
    for i, screen in ipairs(screens) do
        local screenArea = screen:frame().area
        if minScreenSize == nil or minScreenSize > screenArea then
            minScreenSize = screenArea
            result = screen
        end
    end
    return result
end

local function getSecondBigScreen()
    local screens = hs.screen.allScreens()
    if #screens <= 2 then
        return screens[1]
    end
    -- eliminate the "primary" and the smallest
    local primaryScreen = hs.screen.primaryScreen()
    local smallestScreen = getSmallestScreen()
    local removeSets = Set({ smallestScreen:id(), primaryScreen:id() })
    RemoveWhere(screens, function(screen) return removeSets[screen:id()] end)
    return screens[1]
end

-- MARK: this is for ⌃ ⌘ ⌥ 0 reset window positions to my "main" layout
-- for laptop only, alacritty on Desktop 1, Chrome on Desktop 2, slack on 3
-- for laptop with one external monitor, this is Alacritty on Desktop 1, Chrome etc on 2, slack on laptop
-- for laptop plus two external monitors, this is Alacritty on screen 1, Chrome etc screen 2, slack on laptop
local function layoutSimple()
    print("layoutSimple")
    hs.alert.show("Performing layout")
    -- get all windows, move everything to space 2 except alacritty, and slack
    local screen1List = { "alacritty", "Alacritty" }
    local smallScreenList = { "Slack" }
    local maximizeAppList = { "Chrome", "Safari" }
    local wf = hs.window.filter.new():setOverrideFilter { fullscreen = false }
    local windows = wf:getWindows()
    local numScreens = #hs.screen.allScreens()
    local primaryScreen = hs.screen.primaryScreen()
    local smallestScreen = getSmallestScreen()
    local secondBigScreen = getSecondBigScreen()

    for i, window in ipairs(windows) do
        -- Perform operations on each window
        local applicationName = window:application():name()
        if ListStrContains(screen1List, applicationName) then
            window:moveToScreen(primaryScreen)
            window:maximize(0)
        elseif ListStrContains(smallScreenList, applicationName) then
            if numScreens == 1 then
                -- moveWindowToSpaceNum(window, "3")
            else
                window:moveToScreen(smallestScreen)
                window:maximize(0)
            end
        else
            if numScreens <= 2 then
                window:moveToScreen(primaryScreen)
            else
                window:moveToScreen(secondBigScreen)
            end
            if ListStrContains(maximizeAppList, applicationName) then
                window:maximize(0)
            end
        end
    end
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "0", layoutSimple)

local function moveMouse()
    local window = hs.window.focusedWindow()
    local topLeft = window:topLeft()
    local halfSize = window:size():getcenter()
    local center = { x = topLeft.x + halfSize.x, y = topLeft.y + halfSize.y }
    hs.mouse.absolutePosition(center)
end

hs.hotkey.bind({ "cmd", "alt", "ctrl", "shift" }, "e", moveMouse)
hs.hotkey.bind({ "shift", "alt", "ctrl" }, "f17", moveMouse)

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--
--   f.x = f.x - 10
--   win:setFrame(f)
-- end)

--------------------------------------------------------------
local function reloadConfig(files)
    local doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
