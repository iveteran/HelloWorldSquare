-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Themes: https://wezfurlong.org/wezterm/colorschemes/index.html
--config.color_scheme = 'AdventureTime'

config.window_decorations = "RESIZE"
config.scrollback_lines = 5000
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 15
config.background = {
  {
    source = {
      Color = '#232627'
    },
    width = "100%",
    height = "100%",
    --opacity = 0.8
  }
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

keys = {
  {
    key = 'F11',
    mods = '',
    action = wezterm.action.ToggleFullScreen,
  }
}

wezterm.on('gui-startup', function()
    local tab, pane, window = mux.spawn_window({})
    window:gui_window():maximize()
end)


-- and finally, return the configuration to wezterm
return config