-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
--    License:  GNU GPL v2   --
-------------------------------


-- {{{ Main
theme = {}
theme.confdir       = awful.util.getdir("config")
theme.wallpaper_cmd = { "/usr/bin/nitrogen --restore" }
theme.wallpaper_cmd = { "awsetbg /home/wdanilo/Pictures/clean.png" }
-- }}}


-- {{{ Styles
--theme.font      = "Terminus 8"
theme.font      = "ProggyCleanTT CE 12"

-- {{{ Colors
theme.fg_normal = "#AAAAAA"
theme.fg_focus  = "#FFFFFF"
theme.fg_urgent = "#CC9393"
theme.fg_minimize   = "#444444"
theme.bg_normal = "#191919"
theme.bg_focus  = "#191919"
theme.bg_urgent = theme.bg_normal
theme.bg_minimize   = "#191919"
-- }}}

--[[
-- {{{ Borders
theme.border_width  = 1
theme.border_focus  = "#6F6F6F"
theme.border_normal = theme.bg_normal
theme.border_marked = theme.fg_urgent
-- }}}
--]]

-- {{{ Borders
theme.border_width  = "3"
theme.border_normal = "#404040"
theme.border_focus  = "#66A9BA"
theme.border_marked = "#91231c"
theme.wibox_border_width = "0"
theme.wibox_border_color = theme.border_focus
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_normal
-- theme.titlebar_[normal|focus]
-- }}}

-- {{{ Widgets
theme.fg_widget        = "#AECF96"
theme.fg_center_widget = "#88A175"
theme.fg_end_widget    = "#FF5656"
theme.fg_off_widget    = theme.bg_normal
theme.fg_netup_widget  = theme.fg_normal
theme.fg_netdn_widget  = theme.fg_normal
theme.bg_widget        = theme.bg_normal
theme.border_widget    = theme.bg_normal
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.fg_urgent
-- theme.mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Tooltips
-- theme.tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- }}}

-- {{{ Taglist and Tasklist
-- theme.[taglist|tasklist]_[bg|fg]_[focus|urgent]
-- }}}

-- {{{ Menu
-- theme.menu_[bg|fg]_[normal|focus]
-- theme.menu_[height|width|border_color|border_width]
-- }}}
-- }}}


-- {{{ Icons
--
-- {{{ Taglist icons
theme.taglist_squares_sel   = theme.confdir .. "/icons/taglist/tag_sel.png"
theme.taglist_squares_unsel = theme.confdir .. "/icons/taglist/tag_unsel.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc icons
--theme.awesome_icon           = theme.confdir .. "/icons/awesome.png"
--theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
--theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout icons
theme.layout_tile       = theme.confdir .. "/icons/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/icons/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/icons/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/icons/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/icons/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/icons/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/icons/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/icons/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/icons/layouts/floating.png"
-- }}}

-- {{{ Widget icons
theme.widget_cpu    = theme.confdir .. "/icons/widgets/cpu.png"
theme.widget_bat    = theme.confdir .. "/icons/widgets/bat.png"
theme.widget_mem    = theme.confdir .. "/icons/widgets/mem.png"
theme.widget_fs     = theme.confdir .. "/icons/widgets/disk.png"
theme.widget_net    = theme.confdir .. "/icons/widgets/net_download.png"
theme.widget_netup  = theme.confdir .. "/icons/widgets/net_upload.png"
theme.widget_wifi   = theme.confdir .. "/icons/wifi.png"
theme.widget_mail   = theme.confdir .. "/icons/widgets/mail.png"
theme.widget_vol    = theme.confdir .. "/icons/widgets/vol.png"
theme.widget_org    = theme.confdir .. "/icons/cal.png"
theme.widget_date   = theme.confdir .. "/icons/widgets/clock.png"
theme.widget_crypto = theme.confdir .. "/icons/crypto.png"
theme.widget_sep    = theme.confdir .. "/icons/separator.png"

theme.widget_spacer = theme.confdir .. "/icons/widgets/spacer.png"
theme.widget_group_open   = theme.confdir .. "/icons/widgets/left.png"
theme.widget_group_close  = theme.confdir .. "/icons/widgets/right.png"
theme.widget_spacer  = theme.confdir .. "/icons/widgets/spacer.png"
-- }}}

-- {{{ Titlebar icons
theme.titlebar_close_button_focus  = theme.confdir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.confdir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active    = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active   = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active    = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active   = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active    = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active   = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}


return theme
