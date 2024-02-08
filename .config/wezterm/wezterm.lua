--
-- Jonathan's Wezterm configuration
-- 
-- https://wezterm.com/
--
local wt = require "wezterm"
local config = wt.config_builder()

local light_scheme = "zenbones"
local dark_scheme = "zenbones_dark"

-- config.term = "wezterm"

-- Fonts
config.font = wt.font("0xProto Nerd Font Mono", { bold = false,  italic = false })
config.font_size = 14.0
config.dpi = 109.0 

-- Behavior
config.scroll_to_bottom_on_input = true
config.quote_dropped_files = "Posix"
config.quit_when_all_windows_are_closed = false
config.prefer_to_spawn_tabs = true
config.mouse_wheel_scrolls_tabs = true

-- GPU
config.prefer_egl = true

-- Appearance
config.window_decorations = "RESIZE"
config.use_resize_increments = true
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.anti_alias_custom_block_glyphs = true
config.ui_key_cap_rendering = "AppleSymbols"
config.native_macos_fullscreen_mode = true

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return dark_scheme
  else
    return light_scheme
  end
end

wt.on("window-config-reloaded", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    
    window:set_config_overrides(overrides)
  end
end)

return config
