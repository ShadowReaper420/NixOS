package.path = package.path .. ";/split-monitor-workspaces/lua/?.lua"
local smw = require("split-monitor-workspaces")




---------------------
---- KEYBINDINGS ----
---------------------
local mainMod  = "SUPER"
local terminal = "kitty"
local menu     = "~/.config/rofi/launchers/type-6/launcher.sh"

----------------------
---- Applications ----
----------------------

hl.bind(mainMod .. "+ T", hl.dsp.exec_cmd(terminal))
hl.bind("SHIFT + A", hl.dsp.exec_cmd("App_Menu"))
hl.bind (mainMod .. "+ A", hl.dsp.exec_cmd(menu))
hl.bind (mainMod .. "+ Q", hl.dsp.window.close())


---------------------
---- Workspaces -----
---------------------
for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end -- Optional if you configured 10 workspaces: bind workspace 10 to SUPER + 0
    -- Switch to the Nth workspace on the currently focused monitor.
    hl.bind(mainMod .. " +" .. n, smw.workspace(n))
    -- Move the active window to the Nth workspace on the currently focused monitor silently (no focus change).
    hl.bind(mainMod .. " + SHIFT +" .. n, smw.move_to_workspace_silent(n))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("stash"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:stash" }))


---------------------
----- Movement ------
---------------------

-- Move focus with mainMod + arrow keys 
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))



hl.bind(mainMod .. "+ W", hl.dsp.window.float({"toggle"}))
hl.bind(mainMod .. "+ V", hl.dsp.layout("colresize 0.5, +0.2, -0.2"))
hl.bind(mainMod .. "+ .", hl.dsp.layout("consume"))
hl.bind(mainMod .. "+ ,", hl.dsp.layout("expel"))
hl.bind(mainMod .. "+ M", hl.dsp.window.fullscreen({mode = "maximize"}))
hl.bind("ALT + ENTER", hl.dsp.window.fullscreen({mode = "fullscreen"}))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })








--
-- -- Laptop multimedia keys for volume and LCD brightness                                                                                      --
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })      --
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })      --
-- hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })      --
-- hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })      --
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })      --
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })      --
--                                                                                                                                              --
-- -- Requires playerctl                                                                                                                        --
-- hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })                                                        --
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })                                                        --
-- hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })                                                        --
-- hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })                                                        --
--------------------------------------------------------------------------------------------------------------------------------------------------


