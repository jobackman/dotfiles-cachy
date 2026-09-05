local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + CONTROL + Return", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))

-- Change focus
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
-- hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab",   hl.dsp.exec_cmd(noctCall .. "window-switcher"))
hl.bind("ALT + Tab",           hl.dsp.exec_cmd(noctCall .. "window-switcher"))

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + CONTROL + Up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CONTROL + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CONTROL + Left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CONTROL + Down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + CONTROL + ALT + Right", hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + ALT + Left",  hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + ALT + Up",    hl.dsp.window.move({ workspace = "previous" }))
hl.bind(mainMod .. " + CONTROL + ALT + Down",  hl.dsp.window.move({ workspace = "emptym" }))

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind("XF86Calculator",           hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))
hl.bind("CONTROL + ALT + Delete", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))
hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd(noctCall .. "settings-toggle"))
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind("ALT + Space",              hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind(mainMod .. " + period",     hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
hl.bind(mainMod .. " + L",          hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind(mainMod .. " + Escape",    hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + P",          hl.dsp.exec_cmd("hyprpicker -a -n"))
hl.bind("Print",                    hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + ALT + P",  hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + ALT + CTRL + P",  hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))
hl.bind(mainMod .. " + Print",      hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))

-- Theming and Wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"))
hl.bind(mainMod .. " + SHIFT + CTRL + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle noctalia/wallhaven:browser"))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Modifier model: Ctrl moves windows, Alt changes workspaces, Ctrl+Alt moves windows between workspaces.
-- Focus or move to the numbered workspace slot on the current monitor.
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,               hl.dsp.focus({ workspace = "m~" .. i }))
    hl.bind(mainMod .. " + CONTROL + ALT + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }))
end

-- Move to adjacent workspaces and next empty on a given monitor
hl.bind(mainMod .. " + ALT + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + ALT + Left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + ALT + Up",    hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + ALT + Down",  hl.dsp.focus({ workspace = "emptym" }))

-- Scroll through workspaces on the focused monitor.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special())
