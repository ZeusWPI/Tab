# frozen_string_literal: true

module FlashHelper
  FLASH_TYPES = {
    info: "Info",
    notice: "Notice",
    success: "Success",
    warning: "Warning",
    alert: "Warning",
    error: "Error",
    dark: "Dark",
  }.freeze

  def flash_title(key)
    FLASH_TYPES.fetch(key.to_sym, FLASH_TYPES[:dark])
  end

  FLASH_COLOR_CLASSES = {
    info: "text-blue-700 bg-blue-100",
    notice: "text-blue-700 bg-blue-100",
    success: "text-green-700 bg-green-100",
    warning: "text-yellow-700 bg-yellow-100",
    alert: "text-yellow-700 bg-yellow-100",
    error: "text-red-700 bg-red-100",
    dark: "text-gray-700 bg-gray-100",
  }.freeze

  def flash_color_classes(key)
    FLASH_COLOR_CLASSES.fetch(key.to_sym, FLASH_TYPES[:dark])
  end
end
