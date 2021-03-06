-- {{{ License
--
-- Awesome configuration, using awesome 3.4.13 on Arch GNU/Linux
--   * Adrian C. <anrxc@sysphere.org>

-- Screenshot: http://sysphere.org/gallery/snapshots

-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
require("wibox")

-- notify-send style
require('notification')
-- mac osx expose (http://awesome.naquadah.org/wiki/Revelation)
require("revelation")

require("error")
-- User libraries
local vicious = require("vicious")
local scratch = require("scratch")
-- }}}

local terminal = "urxvt"

--awful.util.spawn_with_shell("compton -c -C -t-5 -l-5 -r3 -o1")
-- awful.util.spawn_with_shell("unclutter -noevents")
awful.util.spawn_with_shell("xscreensaver -no-splash")
-- awful.util.spawn_with_shell("compton")
awful.util.spawn_with_shell("shutter --min_at_startup --disable_systray")
-- awful.util.spawn_with_shell("unset DISPLAY; dropbox start")
awful.util.spawn_with_shell("dropbox start") 
awful.util.spawn_with_shell("amixer -c 0 -q set Master 100dB+")
awful.util.spawn_with_shell("gtk-redshift -l 50.061:19.938 -m vidmode -t 5700:4500")

-- {{{ Variable definitions
local altkey = "Mod1"
local modkey = "Mod4"

local home   = os.getenv("HOME")
local config = home.."/.config/awesome/"
local icons  = config.."icons/"
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local scount = screen.count()

-- Beautiful theme
beautiful.init(home .. "/.config/awesome/zenburn.lua")

-- Window management layouts
layouts = {
  awful.layout.suit.tile,        -- 1
  awful.layout.suit.tile.bottom, -- 2
  awful.layout.suit.fair,        -- 3
  awful.layout.suit.max,         -- 4
  awful.layout.suit.magnifier,   -- 5
  awful.layout.suit.floating     -- 6
}
-- }}}



-- {{{ Tags
tags = {
  names  = { "main", "dev", "dev", "web", "web", "misc", "im" },
	keys   = { "z",    "x",   "c",   "a",   "s",   "d",    "v"},
  layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], 
						 layouts[6], layouts[6]},
	icons  = { icons.."taglist/main.png", icons.."taglist/dev.png", icons.."taglist/dev.png", icons.."taglist/web.png", icons.."taglist/web.png",  nil, icons.."taglist/im.png",}
}

for s = 1, scount do
  tags[s] = awful.tag(tags.names, s, tags.layout)
  for i, t in ipairs(tags[s]) do
      awful.tag.setproperty(t, "mwfact", i==7 and 0.13  or  0.5)
      --awful.tag.setproperty(t, "hide",  (i==6 or  i==7) and true)
			awful.tag.seticon(tags.icons[i], t)
  end
end
-- }}}

--[[
-- {{{ Tags
tags = {
  names  = { "term", "emacs", "web", "mail", "im", 6, 7, "rss", "media" },
  layout = { layouts[2], layouts[1], layouts[1], layouts[4], layouts[1],
             layouts[6], layouts[6], layouts[5], layouts[6]
}}

for s = 1, scount do
  tags[s] = awful.tag(tags.names, s, tags.layout)
  for i, t in ipairs(tags[s]) do
      awful.tag.setproperty(t, "mwfact", i==5 and 0.13  or  0.5)
      awful.tag.setproperty(t, "hide",  (i==6 or  i==7) and true)
  end
end
-- }}}
-]]

-- {{{ top_wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ Reusable spacer
space = widget({type = "textbox" })
space.text = " "
-- }}}

-- {{{ Reusable group_open
group_open = widget({ type = "imagebox" })
group_open.image = image(beautiful.widget_group_open)
-- }}}

-- {{{ Reusable group_close
group_close = widget({ type = "imagebox" })
group_close.image = image(beautiful.widget_group_close)
-- }}}

-- {{{ Reusable group_close
spacer = widget({ type = "imagebox" })
spacer.image = image(beautiful.widget_spacer)
-- }}}


-- {{{ CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })
-- Graph properties
cpugraph:set_width(40):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
}) -- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1", 1)
vicious.register(tzswidget, vicious.widgets.thermal, " @ $1°C", 19, "thermal_zone0")

-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
memwidget = widget({ type = "textbox" })
-- Pogressbar properties
--[[
membar:set_vertical(true):set_ticks(true)
membar:set_height(12):set_width(8):set_ticks_size(1)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
--]]
vicious.register(memwidget, vicious.widgets.mem, "$1 / $5 %", 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
-- Initialize widgets
fs = {
  b = awful.widget.progressbar(), r = awful.widget.progressbar(),
  h = awful.widget.progressbar(), s = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(14):set_width(5):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
     beautiful.fg_center_widget, beautiful.fg_end_widget
  }) -- Register buttons
  w.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("rox", false) end)
  ))
end -- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
vicious.register(fs.b, vicious.widgets.fs, "${/boot used_p}", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",     599)
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)
vicious.register(fs.s, vicious.widgets.fs, "${/mnt/storage used_p}", 599)
-- }}}

-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
-- Initialize widget
net_down_widget = widget({ type = "textbox" })
net_up_widget = widget({ type = "textbox" })
-- Register widget
--vicious.register(net_down_widget, vicious.widgets.wifi, "${ssid}", 90)
--vicious.register(net_up_widget, vicious.widgets.wifi, "${link}", 90)
vicious.register(net_down_widget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${wlan0 down_kb}</span>', 3)
vicious.register(net_up_widget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netup_widget ..'">${wlan0 up_kb}</span>', 3)
-- }}}

--[[
-- {{{ Mail subject
mailicon = widget({ type = "imagebox" })
mailicon.image = image(beautiful.widget_mail)
-- Initialize widget
mailwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(mailwidget, vicious.widgets.mbox, "$1", 181, {home .. "/mail/Inbox", 15})
-- Register buttons
mailwidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec("urxvt -T Alpine -e alpine.exp") end)
))
-- }}}
--]]

--[[
-- {{{ Org-mode agenda
orgicon = widget({ type = "imagebox" })
orgicon.image = image(beautiful.widget_org)
-- Initialize widget
orgwidget = widget({ type = "textbox" })
-- Configure widget
local orgmode = {
  files = { home.."/.org/computers.org",
    home.."/.org/index.org", home.."/.org/personal.org",
  },
  color = {
    past   = '<span color="'..beautiful.fg_urgent..'">',
    today  = '<span color="'..beautiful.fg_normal..'">',
    soon   = '<span color="'..beautiful.fg_widget..'">',
    future = '<span color="'..beautiful.fg_netup_widget..'">'
}} -- Register widget
vicious.register(orgwidget, vicious.widgets.org,
  orgmode.color.past..'$1</span>-'..orgmode.color.today .. '$2</span>-' ..
  orgmode.color.soon..'$3</span>-'..orgmode.color.future.. '$4</span>', 601,
  orgmode.files
) -- Register buttons
orgwidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec("emacsclient --eval '(org-agenda-list)'") end),
  awful.button({ }, 3, function () exec("emacsclient --eval '(make-remember-frame)'") end)
))
-- }}}
--]]

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "PCM -c 0")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "PCM -c 0")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("kmix") end),
   awful.button({ }, 4, function () exec("amixer -q set PCM 2dB+", false) end),
   awful.button({ }, 5, function () exec("amixer -q set PCM 2dB-", false) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())
-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%R", 61)
-- Register buttons
datewidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec("pylendar.py") end)
))
-- }}}

-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ top_wibox initialisation
top_wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
	    c.minimized = true
		else
	    if not c:isvisible() then
        awful.tag.viewonly(c:tags()[1])
	    end
	    -- This will also un-minimize
	    -- the client, if needed
	    client.focus = c
	    c:raise()
		end
  end),
	awful.button({ }, 3, function ()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),
	awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
	awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, scount do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

		-- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
        return awful.widget.tasklist.label.currenttags(c, s)
    end, mytasklist.buttons)

    -- Create the top_wibox
    top_wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 16,
        bg = beautiful.bg_normal, position = "top",
        border_color = beautiful.wibox_border_color,
        border_width = beautiful.wibox_border_width
    })

    -- Add widgets to the top_wibox
    top_wibox[s].widgets = {
        {   
					group_open,
					taglist[s], 
					spacer, 
					layoutbox[s], 
					group_close, 
					promptbox[s],space,
          ["layout"] = awful.widget.layout.horizontal.leftright
        },
				
        --s == 1 and group_close or spacer,
				--s == 1 and systray or nil,
        group_close, datewidget, dateicon,
        spacer, volwidget,   volicon, --volbar.widget,
				spacer, batwidget, baticon,
        --spacer, orgwidget,  orgic`on,
        --spacer, mailwidget, mailicon,
        spacer, net_down_widget, upicon , net_up_widget, dnicon,
        --spacer, fs.s.widget, fs.h.widget, fs.r.widget, fs.b.widget, fsicon,
        spacer, memwidget, memicon,
        
        spacer, tzswidget, cpugraph.widget, cpuicon, group_open, space, systray, space, mytasklist[s],
        ["layout"] = awful.widget.layout.horizontal.rightleft
    }
		
end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 2, awful.mouse.client.resize)
)
-- }}}
--[[
local quake = require("quake")

local quakeconsole = {}
for s = 1, screen.count() do
   quakeconsole[s] = quake({ terminal = config.terminal,
			     height = 0.3,
			     screen = s })
end
--]]
--echo 'return awful.client.cycle' | awesome.client
--echo 'awful = require("awful") ; return awful.client.cycle' | awesome.client

-- {{{ Key bindings
-- 




-- {{{ Global keys
globalkeys = awful.util.table.join(
    -- {{{ Applications
		--awful.key({ modkey }, "F12", function () exec(terminal) end),
		--awful.key({ modkey }, "F12", function () quakeconsole[mouse.screen]:toggle() end),
		awful.key({ modkey }, ".", function () exec("amixer -c 0 -q set PCM 2dB+") end),
		awful.key({ modkey }, ",", function () exec("amixer -c 0 -q set PCM 2dB-") end),


		awful.key({ modkey }, "`", function () 
--[[
local urxvt = function (c) 
return awful.rules.match(c, {class = "URxvt"}) 
end 
print "!!!!"
print (awful.client.cycle(urxvt)==nil)
for c in awful.client.cycle(urxvt) do 
c.minimized = false 
end 
--]]


      exec(terminal) end),
		awful.key({ modkey }, "space", function () exec("synapse") end),

		awful.key({  }, "XF86ScreenSaver", function () exec("xscreensaver-command --lock") end),
		awful.key({  }, "Print", function () exec("shutter -s") end),
		awful.key({ modkey }, "Print", function () exec("shutter -f") end),
		awful.key({ modkey }, "F9", function () exec("shutter -wzx") end),

    --awful.key({ modkey }, "e", function () exec("emacsclient -n -c") end),
    awful.key({ modkey }, "r", function () exec("rox", false) end),
    awful.key({ modkey }, "t", function () exec("nautilus") end),
    awful.key({ altkey }, "F1",  function () exec("urxvt") end),
    awful.key({ altkey }, "#49", function () scratch.drop("urxvt", "bottom", nil, nil, 0.30) end),
    awful.key({ modkey }, "g", function () sexec("GTK2_RC_FILES=~/.gtkrc-gajim gajim") end),
    --awful.key({ modkey }, "q", function () exec("emacsclient --eval '(make-remember-frame)'") end),
    awful.key({ altkey }, "#51", function () if boosk then osk(nil, mouse.screen)
        else boosk, osk = pcall(require, "osk") end
    end),
    awful.key({modkey}, "e", revelation),
    -- }}}

    -- {{{ Multimedia keys
    awful.key({}, "#235", function () exec("kscreenlocker --forcelock") end),
    awful.key({}, "#121", function () exec("pvol.py -m") end),
    awful.key({}, "#122", function () exec("pvol.py -p -c -2") end),
    awful.key({}, "#123", function () exec("pvol.py -p -c  2") end),
    awful.key({}, "#232", function () exec("plight.py -c -10") end),
    awful.key({}, "#233", function () exec("plight.py -c  10") end),
    awful.key({}, "#165", function () exec("sudo /usr/sbin/pm-hibernate") end),
    awful.key({}, "#150", function () exec("sudo /usr/sbin/pm-suspend")   end),
    awful.key({}, "#163", function () exec("pypres.py") end),
    -- }}}

    -- {{{ Prompt menus
    awful.key({ altkey }, "F2", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = exec(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),


    --[[
		awful.key({ altkey }, "F3", function ()
        awful.prompt.run({ prompt = "Dictionary: " }, promptbox[mouse.screen].widget,
            function (words)
                sexec("crodict "..words.." | ".."xmessage -timeout 10 -file -")
            end)
    end),
		--]]
    awful.key({ modkey }, "/", function ()
        awful.prompt.run({ prompt = "Web: " }, promptbox[mouse.screen].widget,
            function (command)
                sexec("chromium 'http://www.google.com/search?q="..command.."'")
                awful.tag.viewonly(tags[scount][3])
            end)
    end),
    awful.key({ altkey }, "F5", function ()
        awful.prompt.run({ prompt = "Lua: " }, promptbox[mouse.screen].widget,
        awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
    end),
    -- }}}

    -- {{{ Awesome controls
    awful.key({ modkey }, "b", function ()
        top_wibox[mouse.screen].visible = not top_wibox[mouse.screen].visible
    end),
    awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, "Shift" }, "r", function ()
        promptbox[mouse.screen].text = awful.util.escape(awful.util.restart())
    end),
    -- }}}

    -- {{{ Tag browsing
    awful.key({ altkey }, "n",   awful.tag.viewnext),
    awful.key({ altkey }, "p",   awful.tag.viewprev),
    awful.key({ altkey }, "Tab", awful.tag.history.restore),
    -- }}}

    -- {{{ Layout manipulation
    awful.key({ modkey }, "l",          function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact( 0.05) end),
    awful.key({ modkey,},       "#111", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey },       "#116", function () awful.layout.inc(layouts,  1) end),
    -- }}}

    -- {{{ Focus controls
    awful.key({ modkey }, "p", function () awful.screen.focus_relative(1) end),
    awful.key({ modkey }, "s", function () scratch.pad.toggle() end),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey }, "j", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ altkey }, "Escape", function ()
        awful.menu.menu_keys.down = { "Down", "Alt_L" }
        local cmenu = awful.menu.clients({width=230}, { keygrabber=true, coords={x=525, y=330} })
    end),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1)  end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end)

    -- }}}
)
-- }}}



-- {{{ Client manipulation
clientkeys = awful.util.table.join(
    awful.key({ modkey }, "q", function (c) c:kill() end),
    --awful.key({ modkey }, "m", function (c) scratch.pad.set(c, 0.60, 0.60, true) end),
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey }, "w", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey }, "o",     awful.client.movetoscreen),
		--[[
    awful.key({ modkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
    awful.key({ modkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
		--]]
    awful.key({ modkey, "Control"},"r", function (c) c:redraw() end),
    awful.key({ modkey, "Shift" }, "0", function (c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift" }, "c", function (c) exec("kill -CONT " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "s", function (c) exec("kill -STOP " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey, "Shift" }, "f", function (c) if awful.client.floating.get(c)
        then awful.client.floating.delete(c);    awful.titlebar.remove(c)
        else awful.client.floating.set(c, true); awful.titlebar.add(c) end
    end)
)
-- }}}

-- {{{ Keyboard digits
--[[
local keynumber = 0
for s = 1, scount do
   keynumber = math.max(#tags[s], keynumber);
end
-- }}}

-- {{{ Tag controls
for i = 1, keynumber do
    globalkeys = awful.util.table.join( globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewonly(tags[screen][i]) end
        end),
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewtoggle(tags[screen][i]) end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end))
end
-- }}}
--]]

-- {{{ Tag controls
local keynumber = #tags.keys
extra_tags = {}
for i = 1, keynumber do
    extra_tags[i] = {}
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, tags.keys[i],
                  function ()
		     local screen = mouse.screen
		     local curtag = tags[screen][i]
		     if curtag then
			awful.tag.viewonly(curtag)
		     end
		     for tag,v in pairs(extra_tags[i]) do 
			if v then
			   awful.tag.viewtoggle(tags[screen][tag])
			end
		     end
                  end),
        awful.key({ altkey }, tags.keys[i],
                  function ()
		     local screen = mouse.screen
		     local curtag = awful.tag.getidx(awful.tag.selected(screen))
		     local selected = awful.tag.selectedlist(screen)
		     local found = false
		     for i_,v in ipairs(selected) do 
			v = awful.tag.getidx(v)
			if v == i then
			   found = true
			   break
			end
		     end
		     if found then
			extra_tags[curtag][i] = false
		     else
			extra_tags[curtag][i] = true
		     end
		     if tags[screen][i] then
			awful.tag.viewtoggle(tags[screen][i])
		     end
                  end),
        awful.key({ modkey, "Shift" }, tags.keys[i],
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, tags.keys[i],
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { class = "Firefox",  instance = "Navigator" },
      properties = { tag = tags[scount][3] } },
    { rule = { class = "Emacs",    instance = "emacs" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Emacs",    instance = "_Remember_" },
      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { class = "Xmessage", instance = "xmessage" },
      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { instance = "plugin-container" },
      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { class = "Akregator" },   properties = { tag = tags[scount][8]}},
    { rule = { name  = "Alpine" },      properties = { tag = tags[1][4]} },
    { rule = { class = "Gajim" },       properties = { tag = tags[1][5]} },
    { rule = { class = "Ark" },         properties = { floating = true } },
    { rule = { class = "Geeqie" },      properties = { floating = true } },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Pinentry.*" },  properties = { floating = true } },
		{ rule = { class = "Pidgin" },      properties = { tag = tags[scount][7] }, callback   = awful.client.setslave},
}
-- }}}


-- {{{ Signals
--
-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating then
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, {modkey = modkey}) end
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus;  c.opacity = 1.0 end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal; c.opacity = 0.8 end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, scount do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}
