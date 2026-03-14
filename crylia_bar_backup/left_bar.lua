--------------------------------------------------------------------------------------------------------------
-- This is the statusbar, every widget, module and so on is combined to all the stuff you see on the screen --
--------------------------------------------------------------------------------------------------------------
-- Awesome Libs
local awful = require("awful")
local color = require("src.theme.colors")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

return function(s, widgets)

  local top_left = awful.popup {
    screen = s,
    widget = wibox.container.background,
    ontop = false,
    bg = "#00000000",
    visible = true,
    maximum_width = dpi(900),
    placement = function(c) awful.placement.top_left(c, { margins = dpi(10) }) end,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 5)
    end
  }

  top_left:struts {
    top = 55
  }

  local fallback_colors = { color["Purple500"], color["Purple700"] }

  local function segment_bg_for(widget, index)
    return widget.bg or fallback_colors[((index - 1) % #fallback_colors) + 1]
  end

  local function create_powerline_segment(widget, index)
    local segment_bg = segment_bg_for(widget, index)

    local left_arrow = wibox.widget {
      {
        text = "",
        align = "center",
        valign = "center",
        font = "JetBrainsMono Nerd Font, ExtraBold 24",
        widget = wibox.widget.textbox
      },
      fg = color["Purple500"],
      bg = "#00000000",
      widget = wibox.container.background
    }

    local segment_body = wibox.widget {
      {
        widget,
        left = dpi(8),
        right = dpi(12),
        top = dpi(4),
        bottom = dpi(4),
        widget = wibox.container.margin
      },
      bg = segment_bg,
      widget = wibox.container.background
    }

    return wibox.widget {
      left_arrow,
      segment_body,
      layout = wibox.layout.fixed.horizontal
    }
  end

  local function prepare_widgets(widget_list)
    local layout = wibox.layout.fixed.horizontal()

    for i, widget in ipairs(widget_list) do
      layout:add(create_powerline_segment(widget, i))
    end

    return wibox.widget {
      layout,
      forced_height = 45,
      widget = wibox.container.constraint
    }
  end

  top_left:setup {
    prepare_widgets(widgets),
    nil,
    nil,
    layout = wibox.layout.fixed.horizontal
  }
end

