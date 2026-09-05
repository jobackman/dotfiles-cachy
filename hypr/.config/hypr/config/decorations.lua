-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { CACHYLGREEN, CACHYDGREEN },
                angle = 45,
            },
            inactive_border = CACHYGRAY,
        },
    },
    group = {
        col = {
            border_active = CACHYLBLUE,
            border_inactive = CACHYGRAY,
            border_locked_active = CACHYDBLUE,
            border_locked_inactive = CACHYGRAY,
        },
        groupbar = {
            col = {
                active = CACHYLGREEN,
                inactive = CACHYGRAY,
                locked_active = CACHYDBLUE,
                locked_inactive = CACHYGRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.2,
        rounding = 10,
        active_opacity = 0.9,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
            vibrancy = 0.91696,
        },
    },
})


hl.layer_rule({
    name = "noctalia-bar-glass",
    match = {
        namespace = "^noctalia-bar-.+$",
    },
    no_anim = true,
    ignore_alpha = 0.05,
    blur = true,
    blur_popups = true,
})
