# frozen_string_literal: true

module ButtonGroupHelper
  def rounded_classes(buttons, index)
    visible_buttons = buttons.count(true)

    return "rounded-lg" if visible_buttons == 1

    return "rounded-l-lg" if buttons.index(true) == index
    return "rounded-r-lg" if buttons.rindex(true) == index

    ""
  end
end
