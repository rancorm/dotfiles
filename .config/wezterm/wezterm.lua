--
-- Jonathan's WezTerm configuration
-- 
-- https://wezterm.com/
--
local wt = require "wezterm"
local os = require "os"
local io = require "io"

-- Aliases
local act = wt.action
local config = wt.config_builder()

local light_scheme = "Tokyo Night Day"
local dark_scheme = "Tokyo Night"

-- Fonts
config.font = wt.font("0xProto Nerd Font Mono", { bold = false,  italic = false })
config.font_size = 13.0
config.harfbuzz_features = { 'zero' }

-- Keys 
config.scroll_to_bottom_on_input = true

-- Spawn
config.prefer_to_spawn_tabs = true

-- Mouse
config.mouse_wheel_scrolls_tabs = true

-- GPU
config.prefer_egl = true

-- Appearance
config.dpi = 109.0 
config.window_decorations = "RESIZE"
config.anti_alias_custom_block_glyphs = true
config.window_background_opacity = 0.9
--- macOS
config.ui_key_cap_rendering = "AppleSymbols"
config.native_macos_fullscreen_mode = true
config.macos_window_background_blur = 20

-- Other
config.show_tab_index_in_tab_bar = true
config.use_resize_increments = true
-- config.show_new_tab_button_in_tab_bar = false
config.quote_dropped_files = "Posix"
config.quit_when_all_windows_are_closed = false

-- Here be functions
function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return dark_scheme
  else
    return light_scheme
  end
end

-- Events
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
