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

  def form_errors(object)
    render partial: 'form_errors', locals: { object: object }
  end
end
