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

local light_scheme = "rose-pine-dawn"
local dark_scheme = "rose-pine-moon"

-- Fonts
config.font = wt.font("0xProto Nerd Font", { bold = false, italic = false })
config.font_size = 9.0
config.line_height = 1.1
config.harfbuzz_features = { 'zero' }

-- Keys 
config.scroll_to_bottom_on_input = true

-- Spawn
config.prefer_to_spawn_tabs = true

-- Mouse
config.mouse_wheel_scrolls_tabs = true

-- GPU
config.prefer_egl = true

-- Behavior
config.window_close_confirmation = "NeverPrompt"

-- Appearance
config.dpi = 144.0 
config.window_decorations = "RESIZE"
config.anti_alias_custom_block_glyphs = true
config.window_background_opacity = 0.9
config.initial_cols = 100
config.initial_rows = 30

--- macOS
config.ui_key_cap_rendering = "AppleSymbols"
config.native_macos_fullscreen_mode = true
config.macos_window_background_blur = 20

-- Key Bindings
keys = {
  { key = "k", mods = "ALT", action = act.ActivateTabRelative(1) },
  { key = "j", mods = "ALT", action = act.ActivateTabRelative(-1) }
}

config.keys = keys

-- Other
config.show_tab_index_in_tab_bar = true
config.use_resize_increments = true
config.show_new_tab_button_in_tab_bar = false
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

config.hyperlink_rules = wt.default_hyperlink_rules()
config.hyperlink_rules[1].regex = "\\((\\w+://\\S+)\\)"
config.hyperlink_rules[1].format = "$1"
config.hyperlink_rules[1].highlight = 0

return config
