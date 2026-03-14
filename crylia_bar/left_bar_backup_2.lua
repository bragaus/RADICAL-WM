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
    bg = color["Grey900"],
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

  local function create_powerline_segment(widget, index, next_widget)
    local current_bg = segment_bg_for(widget, index)
    local next_bg = next_widget and segment_bg_for(next_widget, index + 1) or color["Grey900"]

    local segment_content = wibox.widget {
      widget,
      left = dpi(6),
      right = dpi(6),
      top = dpi(2),
      bottom = dpi(2),
      widget = wibox.container.margin
    }

    local arrow = wibox.widget {
      {
        text = "",
        align = "center",
        valign = "center",
        font = user_vars.font.extrabold,
        widget = wibox.widget.textbox
      },
      fg = next_bg,
      bg = current_bg,
      widget = wibox.container.background
    }

    return wibox.widget {
      {
        segment_content,
        bg = current_bg,
        widget = wibox.container.background
      },
      arrow,
      layout = wibox.layout.fixed.horizontal
    }
  end

  local function prepare_widgets(widget_list)
    local layout = wibox.layout.fixed.horizontal()

    for i, widget in ipairs(widget_list) do
      layout:add(create_powerline_segment(widget, i, widget_list[i + 1]))
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

