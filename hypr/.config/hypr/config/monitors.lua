-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

-- Main monitor to the right
hl.monitor({
    output    = MONITOR1, -- "DP-1"
    mode      = "2560x1440@143.97",
    position  = "1920x0",
    scale     = "1",
})

-- Secondary monitor on the left
hl.monitor({
    output    = MONITOR2, -- "DP-3"
    mode      = "1920x1080@60.0",
    position  = "0x0",
    scale     = "1",
})