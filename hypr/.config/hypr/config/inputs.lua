-- Input configuration

hl.config({
    input = {
        -- sensitivity = -0.25,
        accel_profile = "adaptive",

        follow_mouse = 2,

        kb_layout = "se",
        kb_options = "ctrl:nocaps"
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    cursor = {
        -- no_warps = true,
        -- no_hardware_cursors = 1,
    },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
