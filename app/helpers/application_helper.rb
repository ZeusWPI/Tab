module ApplicationHelper
  def euro f
    number_to_currency f, unit: '€'
  end

  def euro_from_cents(f)
    if f
      euro (f / 100.0)
    else
      nil
    end
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
