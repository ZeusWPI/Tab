module ButtonGroupHelper
  def rounded_classes(buttons, index)
    visible_buttons = buttons.count(true)

    return "rounded-lg" if visible_buttons == 1

    puts buttons
    puts "Sup"
    puts index
    puts buttons.rindex(true)
    return "rounded-l-lg" if buttons.index(true) == index
    return "rounded-r-lg" if buttons.rindex(true) == index

    ""
  end
end
