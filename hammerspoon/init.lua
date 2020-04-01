hyper = {"cmd", "alt", "ctrl", "shift"}

--
-- Configuration is reloaded everytime the init.lua file is updated
--
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:bindHotkeys({
  reloadConfiguration = { hyper, "C" }
})
spoon.ReloadConfiguration:start()

--
-- Using Hyper with any arrow resizes the current window to 1/2, 1/3 and then
-- 2/3rd of the screen size.
--
-- Using Hyper-F puts the window in full screen.
--
hs.loadSpoon("MiroWindowsManager")
hs.window.animationDuration = 0.3
hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "f"}
})

